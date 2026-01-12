#!/usr/bin/env bash

set -eu
set -o pipefail

readonly PROGDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILDPACKDIR="$(cd "${PROGDIR}/.." && pwd)"

# shellcheck source=SCRIPTDIR/.util/tools.sh
source "${PROGDIR}/.util/tools.sh"

# shellcheck source=SCRIPTDIR/.util/print.sh
source "${PROGDIR}/.util/print.sh"

function main() {
  local token
  token=""

  while [[ "${#}" != 0 ]]; do
    case "${1}" in
      --help|-h)
        shift 1
        usage
        exit 0
        ;;

      --token|-t)
        token="${2}"
        shift 2
        ;;

      "")
        # skip if the argument is empty
        shift 1
        ;;

      *)
        util::print::error "unknown argument \"${1}\""
    esac
  done

  tools::install "${token}"

  util::print::title "Building Hugo site..."
  "${BUILDPACKDIR}/.bin/hugo"

  util::print::success "Site built successfully!"
}

function usage() {
  cat <<-USAGE
build.sh [OPTIONS]

Builds the Hugo site.

OPTIONS
  --help   -h         prints the command usage
  --token  -t <token> Token used to download assets from GitHub (optional)
USAGE
}

main "${@:-}"

