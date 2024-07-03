# Python cheatsheet

## Using a Virtual Environment

### Using venv

venv (part of the Python standard library) is limited to installing packages using pip,
while using [conda](https://www.anaconda.com/blog/understanding-conda-and-pip)
you have both pip and conda package installer available.

    apt install python3.12-venv
    python3 -m venv myenv
    source myenv/bin/activate

### Using pipx

   apt install pipx
   pipx install radicale

## Use Virtual Environments to Install pip Packages

First, create the virtual environment with:

    python3 -m venv venv
    source venv/bin/activate

## Without externally-managed-environment

The simplest fix to avoid the pip "externally-managed" error.
Navigate to /usr/lib/python3.xx and delete the EXTERNALLY-MANAGED file in the directory.

    cd /usr/lib/python3.12
    rm EXTERNALLY-MANAGED

## Use pipx to Install Python Packages

    apt install pipx

## Webserver

Serve current directory tree at http://localhost:8000/

    python -m SimpleHTTPServer

