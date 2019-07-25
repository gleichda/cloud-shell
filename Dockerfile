FROM gcr.io/cloud-builders/wget AS downloader

RUN CODESERVER_VERSION=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'` && \
  wget https://github.com/cdr/code-server/releases/download/$CODESERVER_VERSION/code-server$CODESERVER_VERSION-linux-x64.tar.gz && \
  tar -xvzf code-server$CODESERVER_VERSION-linux-x64.tar.gz -C / && \
  mv /code-server$CODESERVER_VERSION-linux-x64/code-server /

RUN TFDOCS_VERSION=`curl -s https://api.github.com/repos/segmentio/terraform-docs/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'` && \
  wget https://github.com/segmentio/terraform-docs/releases/download/$TFDOCS_VERSION/terraform-docs-$TFDOCS_VERSION-linux-amd64 -O /terraform-docs

RUN ls -la /


FROM gcr.io/cloudshell-images/cloudshell:latest

COPY --from=downloader /code-server /usr/local/bin/code-server
COPY --from=downloader /terraform-docs /usr/local/bin/terraform-docs
