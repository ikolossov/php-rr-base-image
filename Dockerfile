ARG RR_VERSION=3.0.1
FROM spiralscout/roadrunner:${RR_VERSION} AS rr

FROM php:8.4-cli-alpine
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN apk add tzdata protobuf protobuf-dev
RUN install-php-extensions zip curl sockets pdo_pgsql intl pcntl opcache gd grpc
ARG RR_CONFIG=.rr.yaml
ENV RR_CONFIG=$RR_CONFIG
WORKDIR /app
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/
COPY --from=rr /usr/bin/rr /usr/local/bin/rr
CMD rr serve -c $RR_CONFIG