cp "rider/.ideavimrc" ~

New-Item -ItemType Directory -Force -Path "~/nvim/.config" | Out-Null
if(!(Test-Path -Path "~/.config/nvim")) {
	New-Item -ItemType SymbolicLink -Path "nvim/.config/nvim" -Target "~/.config/nvim"
}
