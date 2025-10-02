# USP NAS

Welcome to the USP NAS (Web Application and API Protection) customers repository. This repository contains
the scripts required to build the USP NAS website:

* https://united-security-providers.github.io/usp-nas/

## Requirements

- `mkdocs` to generate the website and deploy it to GitHub pages.


### mkdocs notes

* Do NOT install mkdocs as a system package (e.g. Debian package). Those are often older releases. Install
it with the Python package manager "pip" instead. Also, install all the required Python packages as well.

* mkdocs installation guide: https://www.mkdocs.org/user-guide/installation/#installing-mkdocs

#### Install / upgrade pip

```
python get-pip.py
pip install --upgrade pip
```

#### Install mkdocs

```
# This will create a local directory called ".venv"
python3 -m venv .venv
source .venv/bin/activate
pip install mkdocs pymdown-extensions mkdocs-material mkdocs-redirects mkdocs-swagger-ui-tag mike
```

Now you should be able to run the `mkdocs` command and see something similiar to:

```
mkdocs --version
mkdocs, version 1.6.1 from /home/<myuser>/usp-core-waap/.venv/lib/python3.12/site-packages/mkdocs (Python 3.12)
```

To deactivate the virtual environment again, simply run:

```
deactivate
```

## Generate site locally

To just generate the site locally, run:

```
$ ./release.sh {nas-version}
```

***TODO*** For releases is clear what to indicate and works, but support of snapshots seems to be only partial (e.g. giving `0.0.0-main-SNAPSHOT` as {helm-version} produced at least when I tried an outdated version of the operator changelog).

The site has then been generated within the "build" directory (Markdown source for mkdocs, not yet HTML).

## Test site locally

Generate the site locally as described above, then run `mkdocs` to serve it locally:

```
$ ./release.sh {nas-version}
$ mkdocs serve
```

This will make it available locally (URL visible in output on the shell, typically http://127.0.0.1:8000/).

## Generate site and publish it via GitHub

To generate the site and deploy it to GitHub pages, run:

```
$ ./release.sh {nas-version} deploy
```

