FROM node:18.12.1-alpine3.16

ENV HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    NODE_OPTIONS=--openssl-legacy-provider \
    HOST=0.0.0.0

WORKDIR /app

RUN apk update
# RUN bundle install
# CMD ["npm", "run", "dev"];