$currentDirectory = Get-Location

$ideavimrcLocation = Join-Path $currentDirectory "rider/.ideavimrc"
New-Item -ItemType SymbolicLink -Target $ideavimrcLocation -Path "~/.ideavimrc" | Out-Null

New-Item -ItemType Directory -Force -Path "~/nvim/.config" | Out-Null
if(!(Test-Path -Path "~/.config/nvim")) {
	$nvimDirectory = Join-Path $currentDirectory "nvim/.config/nvim"
	New-Item -ItemType SymbolicLink -Target $nvimDirectory -Path "~/.config/nvim" | Out-Null
}
