#!/bin/bash

set -o errexit -o nounset -o pipefail

LAME="lame-3.99.5"
LAME_TARBALL="lame-3.99.5.tar.gz"
LAME_URL="http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"

X264_TARBALL="last_x264.tar.bz2"
X264_URL="http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2"

YASM="yasm-1.3.0"
YASM_TARBALL="yasm-1.3.0.tar.gz"
YASM_URL="http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"

main() {
  if [ ! -d ".git" ]; then
    echo "$0 has to be ran under the root directory"
    exit 1
  fi

  local ROOT="$(pwd)"

  echo "### bazel"
  checkout_git https://github.com/google/bazel.git tools
  cd "${ROOT}/tools"
  for dir in cpp defaults genrule; do
    [ -d "${dir}" ] || ln -s "bazel/tools/${dir}"
  done

  echo "### fdk-aac"
  cd "${ROOT}/fdk-aac"
  [ -d fdk-aac ] || git clone git://github.com/mstorsjo/fdk-aac

  echo "### lame"
  cd "${ROOT}/lame"
  [ -f ${LAME_TARBALL} ] || wget "${LAME_URL}"
  [ -d "${LAME}" ] || tar xzvf "${LAME_TARBALL}"
  [ -e lame ] || ln -s "${LAME}" lame

  echo "### x264"
  cd "${ROOT}/x264"
  [ -f "${X264_TARBALL}" ] || wget "${X264_URL}"
  [ -d x264-snapshot* ] || tar xjvf "${X264_TARBALL}"
  [ -e x264 ] || ln -s x264-snapshot* x264

  echo "### x265"
  cd "${ROOT}/x265"
  [ -d x265 ] || hg clone https://bitbucket.org/multicoreware/x265

  echo "### yasm"
  cd "${ROOT}/yasm"
  [ -f "${YASM_TARBALL}" ] || wget "${YASM_URL}"
  [ -d "${YASM}" ] || tar xzvf "${YASM_TARBALL}"
  [ -e yasm ] || ln -s "${YASM}" yasm
}

checkout_git() {
  local repo="${1}"
  local path="${2}/$(basename "${repo}")"
  path="${path%.git}"
  [ -d "${path}" ] || git clone "${repo}" "${path}"
}

main
