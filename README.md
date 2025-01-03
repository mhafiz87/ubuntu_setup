# Ubuntu Setup

## Essential

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install git cmake unzip curl build-essential zip unzip ninja-build nmap htop bat ripgrep tree
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
