#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils git nix curl

set -e

# this script will generate versions.nix in the right location
# this should contain the versions' revs and hashes
# the stable revs are stored only for ease of skipping

# by default nix-prefetch-url uses XDG_RUNTIME_DIR as tmp
# which is /run/user/1000, which defaults to 10% of your RAM
# unless you have over 64GB of ram that'll be insufficient
# resulting in "tar: no space left on device" for packages3d
# hence:
export TMPDIR=/tmp

# if something goes unrepairably wrong, run 'update.sh all clean'

# TODO
# support parallel instances for each pname
#   currently risks reusing old data
# no getting around manually checking if the build product works...
# if there is, default to commiting?
#   won't work when running in parallel?
# remove items left in /nix/store?

# get the latest tag that isn't an RC or *.99
latest_tag="$(git ls-remote --tags --sort -version:refname \
  https://gitlab.com/kicad/code/kicad.git \
  | grep -o 'refs/tags/[0-9]*\.[0-9]*\.[0-9]*$' \
  | grep -v ".99" | head -n 1 | cut -d '/' -f 3)"

all_versions=( "${latest_tag}" master )

prefetch="nix-prefetch-url --unpack --quiet"

clean=""
check_stable=""
check_unstable=1
commit=""

for arg in "$@"; do
  case "${arg}" in
    help|-h|--help) echo "Read me!" >&2; exit 1; ;;
    kicad|release|tag|stable|*small|5*|6*) check_stable=1; check_unstable="" ;;
    all|both|full) check_stable=1; check_unstable=1 ;;
    commit) commit=1 ;;
    clean|fix|*fuck) check_stable=1; check_unstable=1; clean=1 ;;
    master|*unstable|latest|now|today) check_unstable=1 ;;
    *) ;;
  esac
done

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
now=$(date --iso-8601 --utc)

file="${here}/versions.nix"
# just in case this runs in parallel
tmp="${here}/,versions.nix.${RANDOM}"

libs=( symbols templates footprints packages3d )

get_rev="git ls-remote --heads --tags"

gitlab="https://gitlab.com/kicad"
# append commit hash or tag
gitlab_pre="https://gitlab.com/api/v4/projects/kicad%2Fcode%2Fkicad/repository/archive.tar.gz?sha="

# not a lib, but separate and already moved to gitlab
i18n="${gitlab}/code/kicad-i18n.git"
i18n_pre="https://gitlab.com/api/v4/projects/kicad%2Fcode%2Fkicad-i18n/repository/archive.tar.gz?sha="

count=0

printf "Latest tag is\t%s\n" "${latest_tag}" >&2

if [[ ! -f ${file} ]]; then
  echo "No existing file, generating from scratch" >&2
  check_stable=1; check_unstable=1; clean=1
fi

printf "Writing %s\n" "${tmp}" >&2

# not a dangling brace, grouping the output to redirect to file
{

printf "# This file was generated by update.sh\n\n"
printf "{\n"

for version in "${all_versions[@]}"; do

  if [[ ${version} == "master" ]]; then
    pname="kicad-unstable"
    today="${now}"
  else
    pname="kicad"
    today="${version}"
  fi
  # skip a version if we don't want to check it
  if [[ (${version} != "master" && -n ${check_stable}) \
     || (${version} == "master" && -n ${check_unstable}) ]]; then

    printf "\nChecking %s\n" "${pname}" >&2

    printf "%2s\"%s\" = {\n" "" "${pname}"
      printf "%4skicadVersion = {\n" ""
        printf "%6sversion =\t\t\t\"%s\";\n" "" "${today}"
        printf "%6ssrc = {\n" ""

    echo "Checking src" >&2
    src_rev="$(${get_rev} "${gitlab}"/code/kicad.git "${version}" | cut -f1)"
    has_rev="$(grep -sm 1 "\"${pname}\"" -A 4 "${file}" | grep -sm 1 "${src_rev}" || true)"
    has_hash="$(grep -sm 1 "\"${pname}\"" -A 5 "${file}" | grep -sm 1 "sha256")"
    if [[ -n ${has_rev} && -n ${has_hash} && -z ${clean} ]]; then
      echo "Reusing old ${pname}.src.sha256, already latest .rev" >&2
      grep -sm 1 "\"${pname}\"" -A 5 "${file}" | grep -sm 1 "rev" -A 1
    else
          printf "%8srev =\t\t\t\"%s\";\n" "" "${src_rev}"
          printf "%8ssha256 =\t\t\"%s\";\n" \
            "" "$(${prefetch} "${gitlab_pre}${src_rev}")"
          count=$((count+1))
    fi
        printf "%6s};\n" ""
      printf "%4s};\n" ""

      printf "%4slibVersion = {\n" ""
        printf "%6sversion =\t\t\t\"%s\";\n" "" "${today}"
        printf "%6slibSources = {\n" ""

        echo "Checking i18n" >&2
        i18n_rev="$(${get_rev} "${i18n}" "${version}" | cut -f1)"
        has_rev="$(grep -sm 1 "\"${pname}\"" -A 11 "${file}" | grep -sm 1 "${i18n_rev}" || true)"
        has_hash="$(grep -sm 1 "\"${pname}\"" -A 12 "${file}" | grep -sm 1 "i18n.sha256")"
        if [[ -n ${has_rev} && -n ${has_hash} && -z ${clean} ]]; then
          echo "Reusing old kicad-i18n-${today}.src.sha256, already latest .rev" >&2
          grep -sm 1 "\"${pname}\"" -A 12 "${file}" | grep -sm 1 "i18n" -A 1
        else
          printf "%8si18n.rev =\t\t\"%s\";\n" "" "${i18n_rev}"
          printf "%8si18n.sha256 =\t\t\"%s\";\n" "" \
            "$(${prefetch} "${i18n_pre}${i18n_rev}")"
          count=$((count+1))
        fi

          for lib in "${libs[@]}"; do
            echo "Checking ${lib}" >&2
            url="${gitlab}/libraries/kicad-${lib}.git"
            lib_rev="$(${get_rev} "${url}" "${version}" | cut -f1 | head -n1)"
            has_rev="$(grep -sm 1 "\"${pname}\"" -A 19 "${file}" | grep -sm 1 "${lib_rev}" || true)"
            has_hash="$(grep -sm 1 "\"${pname}\"" -A 20 "${file}" | grep -sm 1 "${lib}.sha256")"
            if [[ -n ${has_rev} && -n ${has_hash} && -z ${clean} ]]; then
              echo "Reusing old kicad-${lib}-${today}.src.sha256, already latest .rev" >&2
              grep -sm 1 "\"${pname}\"" -A 20 "${file}" | grep -sm 1 "${lib}" -A 1
            else
              printf "%8s%s.rev =\t" "" "${lib}"
              case "${lib}" in
                symbols|templates) printf "\t" ;; *) ;;
              esac
              printf "\"%s\";\n" "${lib_rev}"
              printf "%8s%s.sha256 =\t\"%s\";\n" "" \
                "${lib}" "$(${prefetch} "https://gitlab.com/api/v4/projects/kicad%2Flibraries%2Fkicad-${lib}/repository/archive.tar.gz?sha=${lib_rev}")"
              count=$((count+1))
            fi
          done
        printf "%6s};\n" ""
      printf "%4s};\n" ""
    printf "%2s};\n" ""
  else
    printf "\nReusing old %s\n" "${pname}" >&2
    grep -sm 1 "\"${pname}\"" -A 23 "${file}"
  fi
done
printf "}\n"
} > "${tmp}"

if grep '""' "${tmp}"; then
	echo "empty value detected, out of space?" >&2
	exit "1"
fi

mv "${tmp}" "${file}"

printf "\nFinished\nMoved output to %s\n\n" "${file}" >&2

if [[ ${count} -gt 0 ]]; then
  if [[ ${count} -gt 1 ]]; then s="s"; else s=""; fi
  echo "${count} revision${s} changed" >&2
  if [[ -n ${commit} ]]; then
    git commit -am "$(printf "kicad: automatic update of %s item%s\n" "${count}" "${s}")"
  fi
  echo "Please confirm the new versions.nix works before making a PR." >&2
else
  echo "No changes, those checked are up to date" >&2
fi
