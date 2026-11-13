FROM httpd:2.4

# Pull in Debian security updates the base image has not been rebuilt with yet
# (libbrotli1 1.1.0-2+deb13u1, CVE-2026-111497).
RUN apt-get update && apt-get -y upgrade && rm -rf /var/lib/apt/lists/*
RUN \
  sed -i'' -e 's/Listen 80$/Listen 8080/' /usr/local/apache2/conf/httpd.conf && \
  echo "Include conf/extra/git-server.conf" >> /usr/local/apache2/conf/httpd.conf && \
  apt update && \
  apt install -y git gitweb && \
  apt clean all
COPY httpd.conf /usr/local/apache2/conf/extra/git-server.conf
