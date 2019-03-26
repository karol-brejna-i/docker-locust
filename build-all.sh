#!/usr/bin/env bash


function join { local IFS="$1"; shift; echo "$*"; }

# Accepts array of path elements.
# Expected path form: ./0.9.0/python3.6/alpine3.9
# which gives the following array . 0.9.0 python3.6 alpine3.9
#
# Returns (via 'echo') computed tag value.
function compute_tag() {
    echo "grubykarol/locust:$2-$3-$4"
}

function build_image() {
    path=$(join / $*)
    tag=$(compute_tag $*)
    docker build -t ${tag} $path
}


function process() {
    for image_version in `find -maxdepth 3 -type d -not -path "./\.*" -not -path "\."`; do

        IFS='/' read -r -a array <<< "$image_version"

        if [[ ${#array[@]} -lt 4 ]]; then
            continue
        fi

        locust_version=${array[1]}
        python_version=${array[2]}

        if case ${locust_version} in "$1"*) false;; *) true;; esac; then
          continue
        fi

        echo "Building ${array[@]}"
        build_image ${array[@]}
    done
}

function usage() {
    echo "usage:"
    echo "    ./build-all.sh [locust-version]"
    echo
    echo "where locust-version is a filter for locust version to be used (see the first level of directories in docker-locust repo)."
    echo "locust-version example values are:"
    echo "  0.8.1 - use 0.8.1 version (directory)"
    echo "  0.9   - use versions 0.9.x (all directories with names starting with '0.9'"
    echo "  (no value) - use all there is"
    echo
}

usage
process $1