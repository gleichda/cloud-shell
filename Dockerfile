FROM gcr.io/cloud-builders/wget AS downloader

ENV TERRAFORM_VERSION="0.12.12"
ENV TFDOCS_VERSION="v0.6.0"
ENV CODESERVER_VERSION="2.1665-vsc1.39.2"
ENV HUGO_VERSION=0.59.0

RUN apt install -y unzip
RUN mkdir /binaries

ADD https://github.com/cdr/code-server/releases/download/${CODESERVER_VERSION}/code-server${CODESERVER_VERSION}-linux-x86_64.tar.gz /
RUN  tar -xvzf code-server${CODESERVER_VERSION}-linux-x86_64.tar.gz -C / && \
  mv /code-server${CODESERVER_VERSION}-linux-x86_64/code-server /binaries/

ADD https://github.com/segmentio/terraform-docs/releases/download/$TFDOCS_VERSION/terraform-docs-$TFDOCS_VERSION-linux-amd64  /binaries/terraform-docs

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /
RUN  tar -xvzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /
RUN mv /hugo /binaries/

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /
RUN unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN mv /terraform /binaries/

RUN chmod +x /binaries/*


FROM gcr.io/cloudshell-images/cloudshell:latest

RUN apt update && apt upgrade -y && apt install -y zsh netcat-openbsd time
RUN npm install -g markdownlint-cli
COPY --from=downloader /binaries/* /usr/local/bin/
