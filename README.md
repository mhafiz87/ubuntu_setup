# Ubuntu Setup

## Essential

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git cmake unzip curl build-essential zip unzip ninja-build nmap htop bat ripgrep tree wl-clipboard shellcheck bash-completion python3.12-venv pass pinentry-tty gnupg
echo "" >> ~/.bashrc
echo -e 'source /etc/profile.d/bash_completion.sh\n' >> ~/.bashrc
source ~/.bashrc

```

## Clone Dotfiles

```bash

```

## Symbolic Link

```
# Only perform after clone dotfiles
ln -s ~/dotfiles/wezterm ~/.config/
ln -s ~/dotfiles/neovim/nvim_dev ~/.config/nvim-dev
ln -s ~/dotfiles/bash/.bash_profile ~/.bash_profile

```

## To Check Wayland or X11

```bash
loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'

```

## XDG Path

```bash
echo 'export XDG_CONFIG_HOME="$HOME/.config"' >> ~/.bashrc
echo 'export XDG_DATA_HOME="$HOME/.local/share"' >> ~/.bashrc
echo 'export XDG_CACHE_HOME="$HOME/.cache"' >> ~/.bashrc

echo 'if [ ! -w ${XDG_RUNTIME_DIR:="/run/user/$UID"} ]; then
  echo "\$XDG_RUNTIME_DIR ($XDG_RUNTIME_DIR) not writable. Unsetting." >&2
  unset XDG_RUNTIME_DIR
else
  export XDG_RUNTIME_DIR
fi' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc

```

## JQ

```bash
REPO="jqlang/jq"
GITHUB_URL="https://github.com/$REPO/releases/latest"
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' $GITHUB_URL)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/jq-linux-amd64"
if [ -d "/opt/jq" ]; then
    sudo rm -rf /opt/jq
fi
sudo mkdir /opt/jq
sudo curl -L $ARTIFACT_URL -o /opt/jq/jq 
echo 'export PATH="$PATH:/opt/jq"' >> ~/.bashrc
echo "" >> ~/.bashrc
sudo chmod 755 /opt/jq/jq
source ~/.bashrc

```

## FastFetch

```bash
REPO="fastfetch-cli/fastfetch"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/fastfetch-linux-amd64.deb"
if [ ! -d "$HOME/Downloads" ]; then
    mkdir $HOME/Downloads
fi
curl -L $ARTIFACT_URL -o ~/Downloads/fastfetch.deb
sudo dpkg -i ~/Downloads/fastfetch.deb
rm ~/Downloads/fastfetch.deb

echo 'fastfetch' >> ~/.bashrc
source ~/.bashrc

```

## FZF, BAT

```bash
if [ -d "/opt/fzf" ]; then
    sudo rm -rf /opt/fzf
fi
sudo git clone --depth 1 https://github.com/junegunn/fzf.git /opt/fzf
sudo /opt/fzf/install
echo 'export PATH="$PATH:/opt/fzf/bin"' >> ~/.bashrc
echo 'eval "$(fzf --bash)"' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc
echo "export FZF_CTRL_T_OPTS=\"
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'\"" >> ~/.bashrc
echo 'export FZF_CTRL_R_OPTS="
  --color header:italic"' >> ~/.bashrc
echo "export FZF_ALT_C_OPTS=\"
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'\"" >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc

```

## Delta for Git

```bash
REPO="dandavison/delta"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/git-delta_${LATEST_VERSION}_amd64.deb"
if [ ! -d "$HOME/Downloads" ]; then
    mkdir $HOME/Downloads
fi
curl -L $ARTIFACT_URL -o ~/Downloads/delta.deb
sudo dpkg -i ~/Downloads/delta.deb
rm ~/Downloads/delta.deb
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global merge.conflictStyle zdiff3

```

## Git Credential Manager

```bash
REPO="git-ecosystem/git-credential-manager"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/gcm-linux_amd64.${LATEST_VERSION//v/}.deb"
curl -L $ARTIFACT_URL -o ~/Downloads/gcm-linux-amd64.deb
sudo dpkg -i ~/Downloads/gcm-linux-amd64.deb
git-credential-manager configure
git config --global credential.credentialStore gpg
echo "export GPG_TTY=$(tty)" >> ~/.bashrc

```

## Oh My Posh

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
echo "oh-my-posh
if [[ \$? -eq 0 ]]; then
    clear
    eval \"\$(oh-my-posh init bash --config ~/dotfiles/ohmyposh/zen.toml)\"
fi" >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc

```

## UV (Python)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
echo "" >> ~/.bashrc
source ~/.bashrc

```

## Pyenv (Python)

```bash
curl -fsSL https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
echo "" >> ~/.bashrc
source ~/.bashrc
# Installing python build dependencies
sudo apt update; sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
pyenv update
clear
  
```

## Color Scripts

```bash
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
cd ~

```

## NodeJS

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v
nvm current

# Verify npm version:
npm -v

```

## Neovim

```bash
REPO="neovim/neovim"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/nvim-linux64.tar.gz"
curl -L $ARTIFACT_URL -o ~/Downloads/neovim.tar.gz
tar -xvzf ~/Downloads/neovim.tar.gz -C ~/Downloads
sudo mv ~/Downloads/nvim-linux64 /opt/neovim
echo 'export PATH="$PATH:/opt/neovim/bin"' >> ~/.bashrc
source ~/.bashrc
mkdir ~/.venv
cd ~/.venv
python3 -m venv neovim
source ~/.venv/neovim/bin/activate
python -m pip install pynvim
deactivate

```

## Wezterm

```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm -y

```

---

## References

1. [Neovim](https://github.com/neovim/neovim)
2. [jq](https://github.com/jqlang/jq)
3. [bat](https://github.com/sharkdp/bat)
4. [ripgrep](https://github.com/BurntSushi/ripgrep)
5. [fzf](https://github.com/junegunn/fzf)
6. [fastfetch](https://github.com/fastfetch-cli/fastfetch)
7. [wezterm](https://wezfurlong.org/wezterm/index.html)
8. [How to get git hub repo latest version using bash or powershell](https://blog.markvincze.com/download-artifacts-from-a-latest-github-release-in-sh-and-powershell/)
9. [How to get git hub repo latest version using JQ](https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/)
10. [Check Wayland or X11](https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used)
11. [Clipboard in Ubuntu](https://askubuntu.com/questions/1486871/how-can-i-copy-and-paste-outside-of-neovim)
12. [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager)
13. [Setting up Git Credential Manager with 'Pass'](https://medium.com/@brightoning/cozy-ubuntu-24-04-setting-up-git-credential-manager-with-pass-2cae4c02ff8c)
