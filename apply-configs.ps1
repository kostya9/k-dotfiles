./clean-configs.ps1

$currentDirectory = Get-Location

$ideavimrcLocation = Join-Path $currentDirectory "rider/.ideavimrc"
New-Item -ItemType SymbolicLink -Target $ideavimrcLocation -Path "~/.ideavimrc" | Out-Null

$vimrcLocation = Join-Path $currentDirectory "vim/.vimrc"
New-Item -ItemType SymbolicLink -Target $vimrcLocation -Path "~/.vimrc" | Out-Null

New-Item -ItemType Directory -Force -Path "~/nvim/.config" | Out-Null
$nvimDirectory = Join-Path $currentDirectory "nvim/.config/nvim"
New-Item -ItemType SymbolicLink -Target $nvimDirectory -Path "~/.config/nvim" | Out-Null

setx XDG_CONFIG_HOME "%USERPROFILE%\.config"

New-Item -ItemType Directory -Force -Path "~/.config" | Out-Null
$whkdrcLocation = Join-Path $currentDirectory "komorebi/whkdrc"
New-Item -ItemType SymbolicLink -Target $whkdrcLocation -Path "~/.config/whkdrc" | Out-Null

$komorebiLocation = Join-Path $currentDirectory "komorebi/komorebi.json"
Copy-Item -Path $komorebiLocation -Destination "~/komorebi.json"

$komorebiBarLocation = Join-Path $currentDirectory "komorebi/komorebi.bar.json"
New-Item -ItemType SymbolicLink -Target $komorebiBarLocation -Path "~/komorebi.bar.json" | Out-Null

$lazygitDirectory = Join-Path $currentDirectory "lazygit"
New-Item -ItemType SymbolicLink -Target $lazygitDirectory -Path "~/.config/lazygit" | Out-Null

$aichatDirectory = Join-Path $currentDirectory "aichat"
New-Item -ItemType SymbolicLink -Target $aichatDirectory -Path "$env:APPDATA/aichat" | Out-Null

$windowsTerminalSettingsLocation = Join-Path $currentDirectory "windows-terminal/settings.json"
Copy-Item -Path $windowsTerminalSettingsLocation -Destination "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force
