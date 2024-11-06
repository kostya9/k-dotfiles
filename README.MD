This is my personal dotfiles for
- neovim
- vim
- rider
- komorebi

For neovim config to work correctly, you need to have
- ANTHROPIC_API_KEY env variable set up
- netcoredbg installed (https://github.com/Samsung/netcoredbg)
- Run :Copilot auth on first launch to log in into GitHub
- Install lazygit (winget install lazygit)
- fzf
- cargo install aichat
- cargo install stylua
- Install Caskaydia Cove Nerd Font 
```powershell
& ([scriptblock]::Create((iwr 'https://to.loredo.me/Install-NerdFont.ps1')))
```

For GitLab:
- setup GITLAB_TOKEN 
- setup GITLAB_URL to the gitlab instance
- winget install GnuWin32.Make
- winget install Golang.Go
- not sure why the plugin doesnt do this, but run
`go build -o bin.exe` ./cmd in `%localappdata%\nvim-data\lazy\gitlab.nvim`
and copy config folder everywhere?
 

Check the checkbox for enabling powershell scripts
