./clean-configs.ps1

$currentDirectory = Get-Location

$ideavimrcLocation = Join-Path $currentDirectory "rider/.ideavimrc"
New-Item -ItemType SymbolicLink -Target $ideavimrcLocation -Path "~/.ideavimrc" | Out-Null

New-Item -ItemType Directory -Force -Path "~/nvim/.config" | Out-Null
$nvimDirectory = Join-Path $currentDirectory "nvim/.config/nvim"
New-Item -ItemType SymbolicLink -Target $nvimDirectory -Path "~/.config/nvim" | Out-Null

setx XDG_CONFIG_HOME "%USERPROFILE%\.config"