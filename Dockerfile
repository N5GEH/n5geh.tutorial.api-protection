FROM kong:3.5

LABEL description="Ubuntu + Kong  + kong-oidc plugin + LUA Plugins"

USER root
# RUN apk add --update nodejs npm python3 make g++ && rm -rf /var/cache/apk/*
# RUN npm install --unsafe -g kong-pdk@0.5.3

ENV term xterm
RUN apt-get update
RUN apt-get install -y  vim

RUN apt-get install -y  curl git gcc musl-dev
RUN luarocks install luaossl OPENSSL_DIR=/usr/local/kong CRYPTO_DIR=/usr/local/kong
RUN luarocks install --pin lua-resty-jwt
# RUN luarocks install kong-oidc -- deprecated
RUN luarocks install lunajson

COPY ./luaplugins/oidc /plugins/oidc
WORKDIR /plugins/oidc
RUN luarocks make

COPY ./luaplugins/query-checker /plugins/query-checker
WORKDIR /plugins/query-checker
RUN luarocks make

COPY ./luaplugins/multi-tenancy /plugins/multi-tenancy
WORKDIR /plugins/multi-tenancy
RUN luarocks make

COPY ./luaplugins/rbac /plugins/rbac
WORKDIR /plugins/rbac
RUN luarocks make

COPY ./luaplugins/scope-checker /plugins/scope-checker
WORKDIR /plugins/scope-checker
RUN luarocks make

USER kong