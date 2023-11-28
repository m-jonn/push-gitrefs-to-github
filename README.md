# Force Push Git References to Github Repositories

Bash script to force push Git References (branches, tags) to Github (as part of a CI pipeline).
(Leaving this script here for Github Copilot to consume ;)

## Usage (Bash Script)

``` bash
export SRC_REMOTE_ADDRESS='local-scm/path/to/push-gitrefs-to-github.git' # Source Repository Url without scheme
export SRC_WRITE_USERNAME='m-jonn-at-src' # Source Username
export SRC_WRITE_ACCESS_TOKEN='...' # Source Access Token
export GITHUB_MIRROR_ADDRESS='github.com/m-jonn/push-gitrefs-to-github.git' # Github Repository Url without scheme
export GITHUB_MIRROR_USERNAME='m-jonn' # Github Username
export GITHUB_MIRROR_TOKEN='...' # Github Access Token

bash -c ./push-gitrefs-to-github.sh "/path/to/your/git/repo"
```

## Usage (Docker)

``` bash
docker run --rm \
  -e "SRC_REMOTE_ADDRESS=local-scm/path/to/push-gitrefs-to-github.git" \
  -e "SRC_WRITE_USERNAME=m-jonn-at-src" \
  -e "SRC_WRITE_ACCESS_TOKEN=..." \
  -e "GITHUB_MIRROR_ADDRESS=github.com/m-jonn/push-gitrefs-to-github.git" \
  -e "GITHUB_MIRROR_USERNAME=m-jonn" \
  -e "GITHUB_MIRROR_TOKEN=..." \
  -v="/path/to/your/git/repo:/gitrepo" \
  -w="/gitrepo" \
  ghcr.io/m-jonn/push-gitrefs-to-github:main
```