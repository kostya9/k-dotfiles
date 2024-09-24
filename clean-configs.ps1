if (Test-Path ~\.ideavimrc)
{
	Remove-Item ~\.ideavimrc
}

if (Test-Path ~\.config\nvim)
{
	Remove-Item ~\.config\nvim
}

if (Test-Path ~\.config\lazygit)
{
	Remove-Item ~\.config\lazygit -Recurse -Force
}

if (Test-Path $env:APPDATA\aichat)
{
	Remove-Item $env:APPDATA\aichat -Recurse -Force
}

if (Test-Path ~\.vimrc)
{
	Remove-Item ~\.vimrc
}

if (Test-Path ~\.config\whkdrc)
{
	Remove-Item ~\.config\whkdrc
}

if (Test-Path ~\komorebi.json)
{
	Remove-Item ~\komorebi.json
}
