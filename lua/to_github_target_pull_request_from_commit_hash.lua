local vim = vim

local function run(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  return result
end

local function to_github_target_pull_request_from_commit_hash()
  local github_url = 'https://github.com'
  local get_remote = [[git remote -v | grep -E "github\.com.*\(fetch\)" | tail -n 1]]
  local get_username = [[sed -E "s/.*com[:\/](.*)\/.*/\\1/"]]
  local get_repo = [[sed -E "s/.*com[:\/].*\/(.*).*/\\1/" | cut -d " " -f 1]]
  local optional_ext = [[sed -E "s/\.git//"]]

  local username = run(get_remote .. '|' .. get_username)
  local repo = run(get_remote .. '|' .. get_repo .. '|' .. optional_ext)

  local current_path = vim.fn.expand("%")
  local current_line = '-L' .. vim.fn.line('.') .. ',' .. vim.fn.line('.')
  local command = 'git blame' .. ' ' .. current_line .. ' ' .. current_path
  local current_line_blame_info = run(command)

  local current_line_commit_hash = ''
  for info in string.gmatch(current_line_blame_info, "%S+") do
    current_line_commit_hash = info
    break
  end

  local command_to_get_pr_number = 'git log --merges --oneline --reverse --ancestry-path' .. ' ' .. current_line_commit_hash .. '...develop'
  local target_pr_number = run(command_to_get_pr_number .. '|' .. 'grep -o "#[0-9]*" -m 1', 'sed s/#//g')
  local pr_url = github_url .. '/' .. username .. '/' .. repo .. '/' .. 'pull' .. '/' .. target_pr_number
  print(pr_url)
end

return {
  to_github_target_pull_request_from_commit_hash = to_github_target_pull_request_from_commit_hash
}
