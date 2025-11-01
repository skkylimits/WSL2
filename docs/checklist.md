

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
