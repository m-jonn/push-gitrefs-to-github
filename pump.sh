#!/bin/bash

set -e

git_toplevel_dir=$(git rev-parse --show-toplevel)
if [[ -z "$git_toplevel_dir" ]] 
then
    echo "Please run from git repository"
    exit 1
fi

#####################
# CHECK ENVIRONMENT #
#####################
check_env_exists () {
  env_var_name=$1
  env_var_value="${!env_var_name}"

  # Check Variables exist
  if [ -z "$env_var_value" ]; 
    then
      echo "[ERROR] \"$env_var_name\" is undefined"
      exit 1
  fi
}

# Ensure Environment Variables are defined
check_env_exists 'GITHUB_MIRROR_ADDRESS'
check_env_exists 'GITHUB_MIRROR_USERNAME'
check_env_exists 'GITHUB_MIRROR_TOKEN'
check_env_exists 'SRC_REMOTE_ADDRESS'
check_env_exists 'SRC_WRITE_USERNAME'
check_env_exists 'SRC_WRITE_ACCESS_TOKEN'

###############
# ADD REMOTES #
###############
REMOTE_SRC_NAME="source"
REMOTE_GITHUB_NAME="github"

git remote add ${REMOTE_SRC_NAME} "https://${SRC_WRITE_USERNAME}:${SRC_WRITE_ACCESS_TOKEN}@$SRC_REMOTE_ADDRESS"
git remote add ${REMOTE_GITHUB_NAME} "https://${GITHUB_MIRROR_USERNAME}:${GITHUB_MIRROR_TOKEN}@$GITHUB_MIRROR_ADDRESS"

###################
# refs: fetch all #
###################
git fetch -p "${REMOTE_SRC_NAME}" > /dev/null 2>&1
git fetch -p "${REMOTE_GITHUB_NAME}" > /dev/null 2>&1

SRC_REFS_AND_OBJS=$(git for-each-ref --format '%(refname):%(objectname)' "refs/remotes/${REMOTE_SRC_NAME}")
GITHUB_REFS_AND_OBJS=$(git for-each-ref --format '%(refname):%(objectname)' "refs/remotes/${REMOTE_GITHUB_NAME}")

SAVEIFS=$IFS
IFS=$'\n'
SRC_REFS_AND_OBJS_ARRAY=($SRC_REFS_AND_OBJS)
GITHUB_REFS_AND_OBJS_ARRAY=($GITHUB_REFS_AND_OBJS)
IFS=$SAVEIFS

##########################
# refs: source -> github #
##########################
for SRC_REF_AND_OBJ in "${SRC_REFS_AND_OBJS_ARRAY[@]}"
do
    SRC_OBJ="${SRC_REF_AND_OBJ##*:}"
    SRC_REF="${SRC_REF_AND_OBJ%:*}"
    SRC_BRANCH="${SRC_REF##*remotes\/${REMOTE_SRC_NAME}\/}"
    if [ "${SRC_BRANCH}" = 'HEAD' ]
    then
        # No HEAD branch please
        continue
    fi

    IS_ALREADY_AVAILABLE=''
    for GITHUB_REF_AND_OBJ in "${GITHUB_REFS_AND_OBJS_ARRAY[@]}"
    do
        GITHUB_OBJ="${GITHUB_REF_AND_OBJ##*:}"
        GITHUB_REF="${GITHUB_REF_AND_OBJ%:*}"
        GITHUB_BRANCH="${GITHUB_REF##*remotes\/${REMOTE_GITHUB_NAME}\/}"

        if [ "${SRC_BRANCH}" = "${GITHUB_BRANCH}" ] && [ "${SRC_OBJ}" = "${GITHUB_OBJ}" ]
        then
            IS_ALREADY_AVAILABLE="true"
            break
        fi
    done

    if [[ -n "$IS_ALREADY_AVAILABLE" ]] 
    then
        continue
    fi

    echo "git push -q --force ${REMOTE_GITHUB_NAME} ${SRC_REF}:refs/heads/${SRC_BRANCH}"
    git push -q --force "${REMOTE_GITHUB_NAME}" "${SRC_REF}:refs/heads/${SRC_BRANCH}"
done

##########################
# tags: source -> github #
##########################
echo "git fetch --tags ${REMOTE_SRC_NAME}"
git fetch --tags "${REMOTE_SRC_NAME}"
echo "git push --tags ${REMOTE_GITHUB_NAME}"
git push --tags "${REMOTE_GITHUB_NAME}"
