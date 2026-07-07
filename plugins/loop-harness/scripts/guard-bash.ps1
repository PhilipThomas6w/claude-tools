# PreToolUse(Bash|PowerShell): block deploy/destroy. Exit 2 blocks the tool call and shows stderr
# to Claude. This is a convention fence, not a security boundary — for unattended/headless runs,
# also pin --allowedTools or use sandboxing; a deny-list can always be worked around deliberately.
$raw = [Console]::In.ReadToEnd()
$cmd = ''
try { $cmd = ($raw | ConvertFrom-Json).tool_input.command } catch { $cmd = '' }

$denyPatterns = @(
  'az\s+deployment'
  'az\s+group\s+(create|delete)'
  'az\s+(resource|webapp|sql|storage).*delete'
  'azd\s+(up|down)'
  'func\s+azure.*publish'
  'git\s+push.*(--force|-f\b)'
  'git\s+push\s+\S+\s+\+\S+'
  'git\s+push\s+.*--delete'
  'git\s+reset\s+--hard'
  'git\s+clean\s+-f'
  'gh\s+repo\s+delete'
  'rm\s+-rf\s+/'
  'rm\s+-rf\s+(~|\.|\.\.|\*|\$HOME)(\s|$)'
  'Remove-Item\s+(-Recurse\s+-Force|-Force\s+-Recurse)\s+[\\/]'
  'Remove-Item\s+(-Recurse\s+-Force|-Force\s+-Recurse)\s+[A-Za-z]:\\?(\s|$)'
  'terraform\s+(apply|destroy)'
  'kubectl\s+(apply|delete)'
  'helm\s+(install|upgrade|uninstall|delete)'
)
$deny = ($denyPatterns -join '|')

if ($cmd -match $deny) {
  [Console]::Error.WriteLine("Deployment or destructive command blocked by loop-harness. Deployment is pipeline-only with a human approval gate; author the change and stop. If this is a false positive, run it yourself.")
  exit 2
}
exit 0
