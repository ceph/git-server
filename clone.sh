#!/bin/bash
set -ex
REPOS=(${REPOS})
cd /git
set +e
for repo in ${REPOS[@]}; do
  base=$(basename $repo)
  if [ -e $base -o -e $base.git ]; then
    continue
  fi
  # Full mirror clone on purpose.  Shallow mirrors (--shallow-since/--depth)
  # look cheaper but cost more to serve: git never writes a commit-graph in a
  # shallow repo, and every clone served from one is grafted to the same
  # truncated history.  Disk is cheap; the git-data PVC sat at 8G/200G after
  # a month of shallow mirrors.
  git clone --mirror $repo
done
