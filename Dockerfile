FROM gcr.io/cloud-builders/wget AS downloader

ENV TERRAFORM_VERSION="0.11.14"
ENV TFDOCS_VERSION="v0.6.0"
ENV CODESERVER_VERSION="1.1156-vsc1.33.1"

RUN apt install -y unzip
RUN mkdir /binaries

ADD https://github.com/cdr/code-server/releases/download/${CODESERVER_VERSION}/code-server${CODESERVER_VERSION}-linux-x64.tar.gz /
RUN  tar -xvzf code-server${CODESERVER_VERSION}-linux-x64.tar.gz -C / && \
  mv /code-server${CODESERVER_VERSION}-linux-x64/code-server /binaries/

ADD https://github.com/segmentio/terraform-docs/releases/download/$TFDOCS_VERSION/terraform-docs-$TFDOCS_VERSION-linux-amd64  /binaries/terraform-docs

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /
RUN unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN mv /terraform /binaries/

RUN chmod +x /binaries/*


FROM gcr.io/cloudshell-images/cloudshell:latest

RUN apt install -y zsh netcat-openbsd
RUN npm install -g markdownlint-cli
COPY --from=downloader /binaries/* /usr/local/bin/
