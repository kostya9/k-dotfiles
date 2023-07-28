cp "rider/.ideavimrc" ~

New-Item -ItemType Directory -Force -Path "~/nvim/.config" | Out-Null
if(!(Test-Path -Path "~/.config/nvim")) {
	$currentDirectory = Get-Location
	$nvimDirectory = Join-Path $currentDirectory "nvim/.config/nvim"
	New-Item -ItemType SymbolicLink -Target $nvimDirectory -Path "~/.config/nvim" | Out-Null
}
