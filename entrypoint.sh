#!/bin/bash
USER_ID=${LOCAL_USER_ID:-9001}

if ! getent passwd $USER_ID; then
    adduser -s /bin/bash -u $USER_ID -S -D -h /dehydrated user
fi
chown -R $USER_ID /dehydrated
export HOME=/dehydrated

if [ "$FORCE_RENEW" = "true" ]; then
    force_flag='--force'
else
    force_flag=''

exec /usr/local/bin/gosu "$USER_ID" dockerize -template config.tmpl:config /bin/bash dehydrated $force_flag -t dns-01 -k hooks/cloudflare/hook.py $@
