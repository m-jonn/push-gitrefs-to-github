# Force Push Git References to Github Repository

Bash script to force push Git References (branches, tags) to Github Repositories (as part of a CI pipeline)

## Usage (Bash Script)

``` bash
export SRC_REMOTE_ADDRESS='local-scm/path/to/push-gitrefs-to-github.git' # Source Repository Url without scheme
export SRC_WRITE_USERNAME='m-jonn-at-src' # Source Username
export SRC_WRITE_ACCESS_TOKEN='...' # Source Access Token
export GITHUB_MIRROR_ADDRESS='github.com/m-jonn/push-gitrefs-to-github.git' # Github Repository Url without scheme
export GITHUB_MIRROR_USERNAME='m-jonn' # Github Username
export GITHUB_MIRROR_TOKEN='...' # Github Access Token

bash -c ./pump.sh
```

## Usage (Docker)