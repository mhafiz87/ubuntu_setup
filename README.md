# Ubuntu Setup

## Essential

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git cmake unzip curl build-essential zip unzip ninja-build nmap htop bat ripgrep tree wl-clipboard shellcheck bash-completion pass pinentry-tty gnupg openssh-server
sudo snap install --classic code
sudo snap install brave
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow from any to any port 3389 proto tcp
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
ln -s ~/dotfiles/nvim ~/.config/nvim
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

## Fonts

### JetBrains

```bash
test -d $HOME/.fonts || mkdir -p $HOME/.fonts
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r '.assets[] | select(.name | contains("JetBrainsMono.zip")) | .browser_download_url')
curl -L -o $HOME/JetBrainsMono.zip $DOWNLOAD_URL
unzip -o $HOME/JetBrainsMono.zip -d $HOME/.fonts
rm -f $HOME/JetBrainsMono.zip
find . -maxdepth 1 -type f ! -regex ".*MonoNerdFont-.*" -delete
```

## Apps

### JQ

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

### FastFetch

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

### FZF, BAT

```bash
if [ -d "/opt/fzf" ]; then
    sudo rm -rf /opt/fzf
fi
sudo git clone --depth 1 https://github.com/junegunn/fzf.git /opt/fzf
sudo /opt/fzf/install
echo 'export PATH=$PATH:/opt/fzf/bin' >> ~/.bashrc
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

### Delta for Git

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

### Git Credential Manager

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

### Oh My Posh

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

### UV (Python)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
echo "" >> ~/.bashrc
source ~/.bashrc

```

### Pyenv (Python)

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

### Color Scripts

```bash
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
cd ~

```

### NodeJS

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

### Neovim

```bash
REPO="neovim/neovim"
FILENAME="nvim-linux-x86_64.tar.gz"
LATEST_VERSION=$(curl -sL https://api.github.com/repos/$REPO/releases/latest | jq -r ".tag_name")
ARTIFACT_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/$FILENAME"
if curl --silent --head --fail -o /dev/null "$ARTIFACT_URL"; then
  echo "URL exists"
  curl -L $ARTIFACT_URL -o ~/Downloads/neovim.tar.gz
  tar -xvzf ~/Downloads/neovim.tar.gz -C ~/Downloads
  sudo rm -rf /opt/neovim
  sudo mkdir -p /opt/neovim
  sudo mv ~/Downloads/nvim-linux-x86_64/* /opt/neovim
  echo 'export PATH=$PATH:/opt/neovim/bin' >> ~/.bashrc
  echo "" >> ~/.bashrc
  source ~/.bashrc
  rm ~/Downloads/neovim.tar.gz
  rm -rf ~/Downloads/nvim-linux-x86_64
else
  echo "URL does not exist"
  return
fi

mkdir -p ~/.venv
uv venv ~/.venv/neovim --python 3.13.8
source ~/.venv/neovim/bin/activate
uv pip install pynvim
deactivate

```

### Wezterm

```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm -y

```

## LSP

### LuaLS

```bash
test -d $HOME/lsp || mkdir -p $HOME/lsp
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | jq -r '.assets[] | select(.name | contains("lua-language-server-3.15.0-linux-x64.tar.gz")) | .browser_download_url')
curl -L -o luals.tar.gz $DOWNLOAD_URL
test -d $HOME/lsp/luals || rmdir -rf $HOME/lsp/luals
mkdir -p $HOME/lsp/luals
tar -xzf $HOME/luals.tar.gz -C $HOME/lsp/luals
rm -f $HOME/luals.tar.gz
if ! command -v lua-language-server; then
  echo 'export PATH=$PATH:$HOME/lsp/luals/bin' >> $HOME/.bashrc
fi
source $HOME/.bashrc
clear
```

### Stylua

```bash
test -d $HOME/lsp || mkdir -p $HOME/lsp.
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest | jq -r '.assets[] | select(.name | contains("stylua-linux-x86_64.zip")) | .browser_download_url')
curl -L -o stylua.zip $DOWNLOAD_URL
unzip -o $HOME/stylua.zip -d $HOME/lsp
rm -f $HOME/stylua.zip
if ! command -v stylua; then
  echo 'export PATH=$PATH:$HOME/lsp' >> $HOME/.bashrc
fi
source $HOME/.bashrc
clear
```

### bash-language-server

```bash
sudo snap install bash-language-server --classic
```

## Add nvim_clean to bash

```bash
nvim_set_1="set mouse=a nu rnu splitbelow splitright smartindent expandtab shiftwidth=4 softtabstop=4 timeoutlen=500 nowrap clipboard=unnamedplus completeopt=fuzzy,menu,menuone,noinsert,noselect,popup ignorecase scrolloff=8 sidescrolloff=8 guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175 wildmode=longest:full,full wildoptions=fuzzy,pum,tagfile winborder=rounded list listchars=extends:🠞,precedes:🠜"
nvim_set_2="imap jk <Esc>"
nvim_set_3="highlight NonText gui=NONE guifg=#908caa"
nvim_set_4="vmap y ygv<Esc>"
nvim_set_10="nnoremap <expr> j v:count == 0 ? 'gj' : 'j'"

# append |alias nvim_clean="nvim --clean -c |
sed -i '$s/$/\nalias nvim_clean="nvim --clean -c /' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc
# append $nvim_set_1
sed -i '$s|$|'"$nvim_set_1"'|' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc

# append | -c |
sed -i '$s/$/ -c /' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc
# append $nvim_set_2
sed -i '$s|$|'"$nvim_set_2"'|' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc

# append | -c |
sed -i '$s/$/ -c /' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc
# append $nvim_set_2
sed -i '$s|$|'"$nvim_set_3"'|' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc

# append | -c |
sed -i '$s/$/ -c /' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc
# append $nvim_set_2
sed -i '$s|$|'"$nvim_set_4"'|' $HOME/.bashrc
# append |'|
sed -i '$s/$/'\''/' $HOME/.bashrc

# append |"|
sed -i '$s/$/"/' $HOME/.bashrc
echo "" >> ~/.bashrc
source $HOME/.bashrc
```

## Setup DHCP server for one of network interfaces

- Find your target network interface to set as DHCP server:

```bash
ip a
```

- install isc-dhcp-server

```bash
sudo apt update
sudo apt install isc-dhcp-server -y
```

- edit target network interface to use static IP in `/etc/netplan/01-network-manager-all.yaml`. It might be a different yaml file, check what yaml file exist in `/etc/netplan` directory. In below example, `enp7s0` is the default LAN port, by setting dhcp4 to yes, it will be assign IP by the router or internet provider. `enx00051bc1e31d` is the `USB to ethernet` device to be used as DHCP server.

```bash
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp7s0:
      dhcp4: yes
    enx00051bc1e31d:
      dhcp4: no
      addresses: [192.168.0.1/24]
```

- apply changes from previous step:

```bash
sudo netplan apply
```

- backup `/etc/dhcp/dhcpd.conf`

```bash
sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.ori
```

- configure dhcp server by editing `/etc/dhcp/dhcpd.conf`,:

```bash
default-lease-time 43200;
max-lease-time 86400;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.0.255;
option domain-name "local.lan";
authoritative;
subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.100 192.168.0.200;
  option routers 192.168.0.1;
  option domain-name-servers 192.168.0.1;
}
```

- set network interface to use as DHCP server by editing `/etc/default/isc-dhcp-server`

```bash
INTERFACESv4="<network-interface>"
```

- start isc-dhcp-server

```bash
sudo systemctl start isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server
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
