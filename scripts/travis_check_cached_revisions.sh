#!/bin/bash

set -e

# If any tracked revision no longer matches a cached revision, we need to clear the cache
# We do that by deleting what was loaded from cache and allowing it to repopulate itself

function check_revision()
{
  echo Checking cached revision for $1 in $2
  if [ -d $2/.git ]; then
    cache_rev=$(git --git-dir=$2/.git rev-parse HEAD);
  fi
  echo cache_rev for $1 is $cache_rev;
  track_rev=$(cat $3);
  echo track_rev for $1 is $track_rev;
  if [ "$cache_rev" != "$track_rev" ]; then
    echo Revision for $1 has changed, clearing cache.;
    if [ -d external ]; then
      rm -rf external/*;
    fi
    if [ -d build-android/external ]; then
      rm -rf build-android/external/*;
    fi
    exit 0;
  fi
}

# Parameters are tool, cached git repo location, tracked revision location
tool=glslang
dir=external/glslang
rev=external_revisions/glslang_revision
check_revision $tool $dir $rev

tool=spirv-tools
dir=external/spirv-tools
rev=external_revisions/spirv-tools_revision
check_revision $tool $dir $rev

tool=spirv-headers
dir=external/spirv-tools/external/spirv-headers
rev=external_revisions/spirv-headers_revision
check_revision $tool $dir $rev

tool=glslang_android
dir=build-android/external/glslang
rev=build-android/glslang_revision_android
check_revision $tool $dir $rev

tool=spirv-tools_android
dir=build-android/external/spirv-tools
rev=build-android/spirv-tools_revision_android
check_revision $tool $dir $rev

tool=spirv-headers_android
dir=build-android/external/spirv-tools/external/spirv-headers
rev=build-android/spirv-headers_revision_android
check_revision $tool $dir $rev

tool=shaderc_android
dir=build-android/external/shaderc
rev=build-android/shaderc_revision_android
check_revision $tool $dir $rev

exit 0
