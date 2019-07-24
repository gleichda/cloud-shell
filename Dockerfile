FROM gcr.io/cloud-builders/wget AS builder

RUN VERSION=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'` && /
    wget https://github.com/cdr/code-server/releases/download/$VERSION/code-server$VERSION-linux-x64.tar.gz && /
    tar -xvzf code-server$VERSION-linux-x64.tar.gz -C /code-server


FROM gcr.io/cloudshell-images/cloudshell:latest

COPY --from=builder /code-server/code-server /code-server/

RUN apt update && apt install zsh && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
