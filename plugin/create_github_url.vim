scriptencoding utf-8

if exists('g:loaded_create_github_url')
    finish
endif
let g:loaded_create_github_url = 1

let s:save_cpo = &cpo
set cpo&vim

command! ToGithubTargetPullRequestFromCommitHash lua require('create_github_url').to_github_target_pull_request_from_commit_hash()

let &cpo = s:save_cpo
unlet s:save_cpo
