# WSL INSTALLABLES

We recommend that you regularly update and upgrade your packages using the preferred package manager for the distribution. For Ubuntu or Debian, use the command:

```
sudo apt update && sudo apt upgrade
```

## .bashrc

> [!CAUTION]
> Back up your own settings if necessary before running this command. 

```bash
curl -o ~/.bashrc https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bashrc && curl -o ~/.bash_aliases https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bash_aliases && curl -o ~/.bash_logout https://raw.githubusercontent.com/skkylimits/.bashrc/main/.bash_logout && echo "Settings downloaded! Restart your terminal or source ~/.bashrc" &&

exec bash
```

## remove sudo man message

```
if [ ! -f ~/.sudo_as_admin_successful ]; then
    touch ~/.sudo_as_admin_successful
    echo "✅ sudo_as_admin_successful aangemaakt."
else
    echo "ℹ️  sudo_as_admin_successful bestaat al, overslaan."
fi
```

## cmatrix

```
sudo apt install -y cmatrix
```

## WGET

```
sudo apt install -y wget
```

## curl

```
sudo apt install -y curl
```

## jq

```
sudo apt install -y jq
```

## git

```
sudo apt install git
```

## nvm

https://github.com/nvm-sh/nvm

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

```

add to ~/.bashrc

```
############################
#                 NVM                   #
############################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

verify installation

```
command -v nvm
```

install LTS

```
nvm install --lts
```

check versions

```
nvm ls

node -v
npm -v
```

### pnpm

https://pnpm.io/installation

Install pnpm and removes the appended code done automatically by pnpm since we already have that in our .bashrc
```sh
curl -fsSL https://get.pnpm.io/install.sh | sh - && sh - && sed -i '/# pnpm/,/# pnpm end/d' ~/.bashrc && sed -i '/^$/d;${/^$/d;}' ~/.bashrc

```

## pyenv

https://github.com/pyenv/pyenv#install-additional-python-versions

update the source list and source list directory

```bash
sudo apt-get update --yes
```

```bash
curl https://pyenv.run | bash
```
Install the depencies(if automatic installer doesn't work)

```bash
sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl wget \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

View available python versions

```bash
pyenv install --list
```

Install python version

```bash
pyenv install 3.12.6
```

Set the default version

```bash
pyenv global 3.12.6 # check the default version
```

python --version# check the executable file
```bash
which python
```

Warning: Never remove default python. WSL depends on this package

python --version# check the executable file
```bash
pyenv versions
```



## Switch between Python versions

To select a Pyenv-installed Python as the version to use, run one of the following commands:

- [`pyenv shell `](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-shell) -- select just for current shell session
- [`pyenv local `](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-local) -- automatically select whenever you are in the current directory (or its subdirectories)
- [`pyenv global `](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-shell) -- select globally for your user account

E.g. to select the above-mentioned newly-installed Python 3.10.4 as your preferred version to use:

```
pyenv global 3.12.6
```



## pipenv

https://code.visualstudio.com/docs/python/environments

Download pip3 after install python3

```bash
pip3 install pipenv
```

List all global dependencies

```
pip3 freeze
```

https://gist.github.com/bradtraversy/c70a93d6536ed63786c434707b898d55


## pipx
https://pipx.pypa.io/stable/installation/

pipx is a Python tool that allows you to install and run Python applications in isolated environments, preventing conflicts with other projects or system packages.

```
sudo apt install pipx
pipx ensurepath
```

### debug

```
which pipx
```
gives 

`/usr/bin/pipx` then its installed in default python system wide.

```
which pipx
```
```
`/usr/bin/pipx` run python --version
⚠️  python is already on your PATH and installed at /home/skkylimits/.pyenv/shims/python. Downloading and running anyway.
Python 3.12.3
```

remove pipx
```
sudo apt remove pipx
```

install pipx in pyenv python 3.12.6
```
pyenv global 3.12.6
python -m pip install --user pipx
python -m pipx ensurepath
```

## whisper

https://github.com/openai/whisper

```
pipx install openai-whisper
```

## vite

```
pnpm create vite
```

## nuxi

```
pnpm install nuxi@latest

```

```
pnpx nuxi init
```

## docker

install docker with docker engine to keep it cli only

1. Set up Docker's apt repository.
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

2. Install the Docker packages.
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

3. Verify that the installation is successful by running the hello-world image:
```
sudo docker run hello-world
```

4. Fix: Allow Your User to Access Docker Without sudo
```
sudo usermod -aG docker $USER
```

```
sudo usermod -aG docker $(whoami)
```

remember to close temrinal and restart for efect to take place

```
newgrp docker || exec bash
```

** manually -> run `docker login`
