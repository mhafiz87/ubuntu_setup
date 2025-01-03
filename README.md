# Ubuntu Setup

## Essential

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install git cmake unzip curl build-essential zip unzip ninja-build nmap htop bat ripgrep
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
tar -xvzf ~/Downloads/neovim.tar.gz -C ~/Downlaods
sudo mv ~/Downloads/nvim-linux64 /opt/neovim
echo 'export PATH=$PATH:/opt/neovim/bin' >> ~/.bashrc

```

---

## References

1. [Neovim](https://github.com/neovim/neovim)
2. [jq](https://github.com/jqlang/jq)
3. [bat](https://github.com/sharkdp/bat)
4. [ripgrep](https://github.com/BurntSushi/ripgrep)
5. [fzf](https://github.com/junegunn/fzf)
6. [How to get git hub repo latest version using bash or powershell](https://blog.markvincze.com/download-artifacts-from-a-latest-github-release-in-sh-and-powershell/)
7. [How to get git hub repo latest version using JQ](https://fabianlee.org/2021/02/16/bash-determining-latest-github-release-tag-and-version/)
