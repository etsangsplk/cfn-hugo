FROM alpine:latest
MAINTAINER Subhajit Ghosh

ENV HUGO_VERSION 0.17
ENV HUGO_TAR hugo_${HUGO_VERSION}_Linux-64bit
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux_amd64

# Install GNU libc (aka glibc)
RUN ALPINE_GLIBC_PACKAGE_VERSION="2.23-r1" && \
    ALPINE_GLIBC_BASE_URL="https://github.com/andyshinn/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    # Install wget and ca-certs
    apk add --no-cache --virtual=build-dependencies wget ca-certificates && \
    # Download glibc packages
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    # Install glibc packages
    apk add --no-cache --allow-untrusted \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    # Force C.UTF-8 as default locale
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    # Cleanup
    apk del glibc-i18n && \
    apk del build-dependencies && \
    # Remove downloaded packages
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

# set C.UTF-8 locale as default.
ENV LANG=C.UTF-8

# Install awscli and dependencies for hugo
RUN apk -v --update add \
        python \
        py-pip \
        py-pygments && \
    pip install --upgrade awscli s3cmd python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

# Download and install hugo
ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_TAR}.tar.gz /usr/local/
RUN tar xvf /usr/local/${HUGO_TAR}.tar.gz -C /usr/local/ && \
    ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo && \
    rm /usr/local/${HUGO_TAR}.tar.gz

# Create working directory
RUN mkdir /blog
WORKDIR /blog
ADD s3sync.sh .

EXPOSE 1313
CMD hugo version

