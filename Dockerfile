ARG BASE_IMAGE=debian:testing-slim

FROM ${BASE_IMAGE}
LABEL org.opencontainers.image.source https://github.com/felix-kaestner/latex

ARG USER_ID=1000
ARG USER_NAME=latex
ARG USER_HOME=/home/latex
ARG USER_GECOS=LaTeX

# add default user
RUN adduser \
  --home "$USER_HOME" \
  --uid $USER_ID \
  --gecos "$USER_GECOS" \
  --disabled-password \
  "$USER_NAME"

RUN apt-get update && apt-get install -y \
  # latex packages and german language
  texlive-latex-extra \
  texlive-lang-german \
  texlive-bibtex-extra \
  texlive-fonts-extra \
  texlive-font-utils \
  # latex tools
  cm-super \
  biber \
  latexmk \ 
  # markup format conversion tool
  pandoc \
  pandoc-citeproc \
  # XFig utilities
  fig2dev \
  # syntax highlighting package
  python3-pygments \
  # utilities
  curl \ 
  unzip \ 
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# install TUD-Script - https://github.com/tud-cd/tudscr/
RUN curl -s -L -o /tmp/tudscr.zip https://github.com/tud-cd/tudscr/releases/download/v2.06k/tudscr_v2.06k.zip \
  && unzip -o tudscr.zip -d /usr/local/share/texmf/ \
  && rm tudscr.zip \
  && texhash

# create user home directory and set permissions
RUN mkdir -p $USER_HOME \
  && chown "$USER_NAME:$USER_NAME" $USER_HOME

# switch into home directory as working directory
WORKDIR $USER_HOME

# switch to new user
USER $USER_NAME