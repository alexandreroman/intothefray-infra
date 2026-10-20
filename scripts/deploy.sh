#!/bin/sh
# Deploys or rolls back the Into The Fray stack on the VPS. The deploy
# workflow copies this script, compose.yaml and the Caddyfile to
# /opt/intothefray/incoming/, then runs it over SSH as the deploy user.
#
# Usage:
#   deploy.sh deploy [TAG]  install the files of incoming/ and run image TAG
#                           (default: the tag running now)
#   deploy.sh rollback      restore the files and the tag that ran before the
#                           last deploy
#
# The workflow validates TAG (a 40-character commit SHA) before calling this.
set -eu

APP_DIR=/opt/intothefray
INCOMING_DIR=$APP_DIR/incoming
PREVIOUS_DIR=$APP_DIR/previous
ENV_FILE=$APP_DIR/.env

# The files that make up a deployment, saved before each deploy so that a
# rollback also undoes a broken compose.yaml or Caddyfile.
STACK_FILES="compose.yaml Caddyfile .env"

# Seconds to wait for every service to be running, and healthy when it has a
# healthcheck
WAIT_TIMEOUT=180

log() {
	printf '%s\n' "$*"
}

fail() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

# Prints the value of variable $2 in env file $1, or nothing when either the
# file or the variable is missing. The file is parsed, never sourced.
read_env_var() {
	if [ -f "$1" ]; then
		sed -n "s/^$2=//p" "$1" | tail -n 1
	fi
}

write_env_file() {
	image_tag=$1
	previous_tag=$2
	printf 'APP_IMAGE_TAG=%s\nAPP_PREVIOUS_TAG=%s\n' "$image_tag" "$previous_tag" >"$ENV_FILE.tmp"
	mv "$ENV_FILE.tmp" "$ENV_FILE"
}

# Replaces the saved deployment with the current one. It runs first on every
# deploy, so a rollback never restores an older deployment than the last one.
save_current_files() {
	rm -rf "$PREVIOUS_DIR"
	mkdir -p "$PREVIOUS_DIR"
	for file in $STACK_FILES; do
		if [ -f "$APP_DIR/$file" ]; then
			cp -p "$APP_DIR/$file" "$PREVIOUS_DIR/$file"
		fi
	done
}

start_stack() {
	docker compose up --detach --remove-orphans --wait --wait-timeout "$WAIT_TIMEOUT"
}

deploy() {
	requested_tag=${1:-}

	save_current_files

	current_tag=$(read_env_var "$ENV_FILE" APP_IMAGE_TAG)
	previous_tag=$(read_env_var "$ENV_FILE" APP_PREVIOUS_TAG)

	if [ -n "$requested_tag" ]; then
		new_tag=$requested_tag
	elif [ -n "$current_tag" ]; then
		new_tag=$current_tag
	else
		fail "no image tag deployed yet: run the workflow with a commit SHA"
	fi

	# A redeploy of the same tag keeps the tag that ran before it, so that
	# APP_PREVIOUS_TAG always names a different image to go back to.
	if [ "$new_tag" != "$current_tag" ]; then
		previous_tag=$current_tag
	fi

	cp "$INCOMING_DIR/compose.yaml" "$INCOMING_DIR/Caddyfile" "$APP_DIR/"
	write_env_file "$new_tag" "$previous_tag"

	log "Deploying image $new_tag (previous: ${previous_tag:-none})"
	docker compose pull --quiet
	start_stack

	# Images no container uses, built more than a week ago: keeps the disk
	# from filling up with one image per deploy. A rollback to a pruned tag
	# pulls it again.
	docker image prune --all --force --filter "until=168h" >/dev/null
	log "Deployed image $new_tag"
}

rollback() {
	if [ ! -f "$PREVIOUS_DIR/.env" ]; then
		fail "no previous deployment to roll back to"
	fi

	for file in $STACK_FILES; do
		if [ -f "$PREVIOUS_DIR/$file" ]; then
			cp -p "$PREVIOUS_DIR/$file" "$APP_DIR/$file"
		fi
	done

	log "Rolling back to image $(read_env_var "$ENV_FILE" APP_IMAGE_TAG)"
	start_stack
	log "Rolled back"
}

main() {
	cd "$APP_DIR"

	command=${1:-}
	case $command in
	deploy)
		deploy "${2:-}"
		;;
	rollback)
		rollback
		;;
	*)
		fail "usage: $0 deploy [TAG] | rollback"
		;;
	esac
}

main "$@"
