FROM node:6

MAINTAINER  Wang Long <neu.wanglong@gmail.com>

# install phantomjs
RUN mkdir -p /tmp/phantomjs && \
    cd /tmp/phantomjs && \
    wget -c https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar -xvf phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    mv  phantomjs-2.1.1-linux-x86_64/bin/*  /usr/bin/

# install calibre dependencies and gitbook-cli
RUN apt-get update && \
    apt-get install -y calibre  && \
    npm install gitbook-cli -g && \
    npm install svgexport -g && \
    apt-get clean && \
    rm -fr /var/cache/apt/* /var/lib/apt/lists/*

# install Arial fonts
RUN mkdir -p /tmp/fonts
ADD fonts/arial.zip /tmp/fonts
RUN cd /tmp/fonts && \
    mkdir /usr/share/fonts/truetype
    mv -t /usr/share/fonts/truetype  Arial*ttf && \
    rm -fr /tmp/fonts  && \
    fc-cache -f -v

# install fonts Noto Sans CJK SC for Simplified Chinese
RUN wget -P /raw_fonts https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKsc-hinted.zip && \
    cd /raw_fonts && \
    mkdir /usr/share/fonts/noto && \
    unzip -o NotoSansCJKsc-hinted.zip && \
    mv -t /usr/share/fonts/noto *-DemiLight.otf *-Bold.otf *-Black.otf && \
    rm -r /raw_fonts && \
    fc-cache -f -v

# install gitbook versions
RUN gitbook fetch latest

ENV BOOKDIR /gitbook

VOLUME $BOOKDIR

EXPOSE 4000

WORKDIR $BOOKDIR

CMD ["gitbook", "--help"]
