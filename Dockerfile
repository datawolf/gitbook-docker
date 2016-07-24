FROM node:6

MAINTAINER  Wang Long <neu.wanglong@gmail.com>

# install calibre dependencies and gitbook-cli
RUN apt-get update && \
    apt-get install -y unzip  calibre  && \
    npm install gitbook-cli -g && \
    npm install svgexport -g && \
    apt-get clean && \
    rm -fr /var/cache/apt/* /var/lib/apt/lists/*

# install Arial fonts
RUN mkdir -p /tmp/raw_fonts
ADD fonts/arial.zip /tmp/raw_fonts/
RUN cd /tmp/raw_fonts && \
    unzip -o arial.zip && \
    mv -t /usr/share/fonts/truetype Arial*ttf && \
    rm -r /tmp/raw_fonts  && \
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
