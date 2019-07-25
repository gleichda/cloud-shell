FROM gcr.io/cloud-builders/wget AS downloader

RUN VERSION=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'` && \
  wget https://github.com/cdr/code-server/releases/download/$VERSION/code-server$VERSION-linux-x64.tar.gz && \
  tar -xvzf code-server$VERSION-linux-x64.tar.gz -C / && \
  mv /code-server$VERSION-linux-x64/code-server /
RUN VERSION=`curl -s https://api.github.com/repos/segmentio/terraform-docs/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'` && \
  wget https://github.com/segmentio/terraform-docs/releases/download/$VERSION/terraform-docs-$VERSION-linux-amd64 && \
  tar -xvzf code-server$VERSION-linux-x64.tar.gz -C / && \
  mv /code-server$VERSION-linux-x64/code-server /
RUN ls -la /


FROM gcr.io/cloudshell-images/cloudshell:latest

COPY --from=builder /code-server /usr/local/bin/code-server
