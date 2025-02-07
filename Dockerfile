FROM ubuntu:22.04

ARG HOME=/root
ENV GODOT_VERSION=3.6-stable
ENV GODOT_VERSION_DOTTED=3.6.stable

WORKDIR /opt

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip \
    && wget -O godot.zip https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux_headless.64.zip --no-check-certificate \
    && unzip godot.zip \
    && rm godot.zip \
    && mv Godot_v${GODOT_VERSION}_linux_headless.64 /usr/local/bin/godot \
    && mkdir -p ${HOME}/.local/share/godot/templates/${GODOT_VERSION} \
    && wget -O export_templates.tpz https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_export_templates.tpz --no-check-certificate \
    && unzip export_templates.tpz -d ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED} \
    && mv ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED}/templates/webassembly* ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED}/ \
    && rm -rf ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED}/templates/*

FROM ubuntu:22.04

ARG HOME=/root
ENV GODOT_VERSION_DOTTED=3.6.stable

RUN mkdir -p ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED}/

COPY --from=0 /usr/local/bin/godot /usr/local/bin
COPY --from=0 ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED}/ ${HOME}/.local/share/godot/templates/${GODOT_VERSION_DOTTED}/

WORKDIR /app

