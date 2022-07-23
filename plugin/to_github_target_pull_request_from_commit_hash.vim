scriptencoding utf-8

if exists('g:loaded_to_github_target_pull_request_from_commit_hash')
    finish
endif
let g:loaded_to_github_target_pull_request_from_commit_hash = 1

let s:save_cpo = &cpo
set cpo&vim

command! ToGithubTargetPullRequestFromCommitHash lua require('to_github_target_pull_request_from_commit_hash').to_github_target_pull_request_from_commit_hash()

let &cpo = s:save_cpo
unlet s:save_cpo
