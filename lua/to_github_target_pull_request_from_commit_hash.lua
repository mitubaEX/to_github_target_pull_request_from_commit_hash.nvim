local api = vim.api
local fn = vim.fn
local vim = vim

local M = {}

local function run(...)
  local command = table.concat({...}, '|')
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  return string.gsub(result, '\n', '')
end

local function to_github_target_pull_request_from_commit_hash(args)
  local github_url = 'https://github.com'
  local get_remote = [[git remote -v | grep -E "github\.com.*\(fetch\)" | tail -n 1]]
  local get_username = [[sed -E "s/.*com[:\/](.*)\/.*/\\1/"]]
  local get_repo = [[sed -E "s/.*com[:\/].*\/(.*).*/\\1/" | cut -d " " -f 1]]
  local optional_ext = [[sed -E "s/\.git//"]]

  local username = run(get_remote, get_username)
  local repo = run(get_remote, get_repo, optional_ext)

  local current_path = fn.expand("%")
  local current_line = '-L' .. fn.line('.') .. ',' .. fn.line('.')
  local command = 'git blame' .. ' ' .. current_line .. ' ' .. current_path
  local current_line_blame_info = run(command)

  local commit_hash = ''
  if args == nil or args == '' then
    for info in string.gmatch(current_line_blame_info, "%S+") do
      commit_hash = info
      break
    end
  else
    commit_hash = args
  end

  local command_to_get_pr_number = 'git log --merges --oneline --reverse --ancestry-path' .. ' ' .. commit_hash .. '...develop'
  local target_pr_number = run(command_to_get_pr_number, 'grep -o "#[0-9]*" -m 1', 'sed s/#//g')
  local pr_url = table.concat({github_url, username, repo, 'pull', target_pr_number}, '/')
  print(pr_url)
end

local function setup_commands()
  local cmd = api.nvim_create_user_command

  cmd(
    "ToGithubTargetPullRequestFromCommitHash",
    function(opts) to_github_target_pull_request_from_commit_hash(opts.args) end,
    { nargs = "*" }
  )
end

function M.setup()
  setup_commands()
end

return M
