FROM turbot/steampipe:0.16.4

ARG PLUGINS

RUN steampipe plugin install ${PLUGINS}
