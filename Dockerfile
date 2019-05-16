FROM debian:buster-slim
LABEL maintainer="kmuto_docker@kmuto.jp"

ENV REVIEW_VERSION 3.1.0
ENV LANG en_US.UTF-8

# setup
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      locales curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8 && update-locale en_US.UTF-8

# install lightweight Re:VIEW environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern tex-gyre fonts-texgyre texlive-pictures texlive-plain-generic \
      ghostscript gsfonts \
      cm-super \
      fonts-noto-cjk-extra && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
## if you want to use ipa font instead of noto font, use this settings
# RUN kanji-config-updmap ipaex

# setup Re:VIEW
RUN gem install bundler rake --no-rdoc --no-ri && \
    gem install review -v "$REVIEW_VERSION" --no-rdoc --no-ri

## install font map of noto for dvipdfmx
COPY noto-otc/ /usr/share/texlive/texmf-dist/fonts/map/dvipdfmx/ptex-fontmaps/noto-otc/

## use noto for uplatex
RUN texhash && kanji-config-updmap-sys noto-otc

COPY review-covermaker review-jlreq.cls review-cover.sty /usr/bin/

## set cache folder to work folder (disabled by default)
# RUN mkdir -p /etc/texmf/texmf.d && echo "TEXMFVAR=/work/.texmf-var" > /etc/texmf/texmf.d/99local.cnf
