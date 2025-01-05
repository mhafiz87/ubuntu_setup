# Ubuntu Setup

## Essential

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install git cmake unzip curl build-essential zip unzip ninja-build nmap htop bat ripgrep tree wl-clipboard pass pinentry-tty gnupg

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

```

## FastFetch

```bash
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update
sudo apt install fastfetch -y
echo 'fastfetch' >> ~/.bashrc

```

## JQ

```bash
REPO="jqlang/jq"
GITHUB_URL="https://github.com/$REPO/releases/latest"
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' $GITHUB_URL)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/jq-linux-amd64"
sudo mkdir /opt/jq
sudo curl -o /opt/jq/jq $ARTIFACT_URL
echo 'export PATH="$PATH:/opt/jq"' >> ~/.bashrc
source ~/.bashrc

```

## FZF, BAT

```bash
sudo git clone --depth 1 https://github.com/junegunn/fzf.git /opt/fzf
sudo /opt/fzf/install
echo 'export PATH="$PATH:/opt/fzf/bin"' >> ~/.bashrc
source ~/.bashrc
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
echo 'export PATH="$PATH:~/.local/bin"' >> ~/.bashrc
source ~/.bashrc
echo "export FZF_CTRL_T_OPTS=\"
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'\"" >> ~/.bashrc
echo 'export FZF_CTRL_R_OPTS="
  --color header:italic"' >> ~/.bashrc
echo "export FZF_ALT_C_OPTS=\"
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'\"" >> ~/.bashrc

```

## Delta for Git

```bash
REPO="dandavison/delta"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/git-delta_${LATEST_VERSION}_amd64.deb"
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

## Neovim

```bash
REPO="neovim/neovim"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/nvim-linux64.tar.gz"
curl -L $ARTIFACT_URL -o ~/Downloads/neovim.tar.gz
tar -xvzf ~/Downloads/neovim.tar.gz -C ~/Downloads
sudo mv ~/Downloads/nvim-linux64 /opt/neovim
echo 'export PATH="$PATH:/opt/neovim/bin"' >> ~/.bashrc

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
