# to_github_target_pull_request_from_commit_hash.nvim

This plugin create github pull request url from commit hash in current line.

## Requirements

- Neovim 0.5+

## Installation
```lua
use { 'mitubaEX/to_github_target_pull_request_from_comm
```

## Usage
```vim
:ToGithubTargetPullRequestFromCommitHash

" => https://github.com/hoge/fuga/pull/1111
```

## Development
Load current repository files by bellow command.

```sh
nvim --cmd "set rtp+=."
```
