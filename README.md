# linux-setup

Some scripts for setting up a fresh Linux install

## Assumptions

* APT Package Manager (Debian based distro)
* May be behind corporate proxy

## Applications

The follow applications are to be installed and configured.

* VS Code
* Firefox
* Git
* Node.js
* Docker
* Python 3.x
* Golang
* Azure CLI 2.0
* GIMP
* Inkscape

## Uneeded Packages

The following are packages that come with Ubuntu, but are not desired.

* Libre Office
* Rhythmbox
* Evolution
* Empathy

## Bash

The [~/.bashrc](./home/.bashrc) has personalized customization for BASH.

## Proxy

If behind a corporate proxy, the following must be setup to enable internet access. The files in [~/.proxy](./home/.proxy) can help automate enabling and disabling the proxy settings across multiple systems.

Many applications look for an environment variable `HTTP_PROXY` and `HTTPS_PROXY`, but not all of them.

> If using VirtualBox and the corporate proxy requires Windows authentication, you can install Fiddler on the host OS and enable `Automatically Authenticate`. Then the proxy configuration in the guest OS should point at the port on the local host where Fiddler is capturing traffic.

### Environment Variables

To ensure environment variables are injected into all new sessions, the following should be appended to `/etc/environment`:

```text
http_proxy="http://$ADDRESS:$PORT/"
https_proxy="http://$ADDRESS:$PORT/"
ftp_proxy="ftp://$ADDRESS:$PORT/"
socks_proxy="socks://$ADDRESS:$PORT/"
```

### Gnome

To set the Gnome window manager proxy configuration, run the following:

```bash
gsettings set org.gnome.system.proxy mode $MODE_MANUAL
gsettings set org.gnome.system.proxy.http host $ADDRESS
gsettings set org.gnome.system.proxy.http port $PORT
gsettings set org.gnome.system.proxy.https host $ADDRESS
gsettings set org.gnome.system.proxy.https port $PORT
gsettings set org.gnome.system.proxy.ftp host $ADDRESS
gsettings set org.gnome.system.proxy.ftp port $PORT
gsettings set org.gnome.system.proxy.socks host $ADDRESS
gsettings set org.gnome.system.proxy.socks port $PORT
```

### Aptitude

To configure the proxy in aptitude (Debian pacakage manager), the `/etc/apt/apt.conf.d/95proxies` file must be updated with the following:

```text
Acquire::http::proxy "http://$ADDRESS:$PORT/";
Acquire::https::proxy "https://$ADDRESS:$PORT/";
Acquire::ftp::proxy "ftp://$ADDRESS:$PORT/";
Acquire::socks::proxy "socks://$ADDRESS:$PORT/";
```

If using Gnome, setting the proxy via the UI will automatically update aptitude proxy configuration.

### Git

To configure the proxy in Git, run:

```bash
git config --global http.proxy $ADDRESS:$PORT
git config --global https.proxy $ADDRESS:$PORT
```

### NPM

To configure the proxy in NPM, run:

```bash
npm config set proxy http://$ADDRESS:$PORT
npm config set https-proxy http://$ADDRESS:$PORT
```