FROM ruby:3.1.2

ENV HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo
CMD [rm -f /app/tmp/sockets/puma.sock]

WORKDIR ${HOME}
ADD Gemfile ${HOME}/Gemfile
ADD . ${HOME}

RUN apt-get update -qq \
&& apt-get install -y ca-certificates curl gnupg \
&& mkdir -p /etc/apt/keyrings \
&& curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key |  gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
&& echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update \
&& apt-get install -y nodejs g++ make openssl
RUN npm install -g npm@10.1.0
RUN npm install --global yarn
RUN bundle install
