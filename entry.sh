#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

# Copy default config from cache
if [ ! "$(ls -A /etc/monit/conf.d)" ]; then
   cp -a /etc/monit/conf.d.cache/. /etc/monit/conf.d/
fi

# Check that SMTP variables are defined
if [ -z "${SMTP_PORT_587_TCP_ADDR}" -a -z "$SMTP_HOST" ]; then
    echo "You must link this container with SMTP or define SMTP_HOST"
    exit 1
fi

# Check that Auth variables are defined
if [ -z "$PASSWORD" ]; then
    echo "You must define PASSWORD"
    exit 1
fi

# Alias SMTP variables
if [ -z "$SMTP_HOST" ]; then
    export SMTP_HOST="${SMTP_PORT_587_TCP_ADDR:-localhost}"
fi
if [ -z "$SMTP_PORT" ]; then
    export SMTP_PORT="${SMTP_PORT_587_TCP_PORT:-587}"
fi
echo "$(basename $0) >> Set SMTP_HOST=$SMTP_HOST, SMTP_PORT=$SMTP_PORT"

# Alert Configuration
if [ -n "$ALERT_EMAIL" ]; then
cat << EOF > /etc/monit/conf.d/alert.cfg
set alert ${ALERT_EMAIL}
EOF
echo "$(basename $0) >> Set alerts=$ALERT_EMAIL"
fi

# SMTP Configuration
cat << EOF > /etc/monit/conf.d/smtp.cfg
set mailserver ${SMTP_HOST} port ${SMTP_PORT}
EOF

# Login Configuration
cat << EOF > /etc/monit/conf.d/setting.cfg
set httpd port 2812 and
    use address 0.0.0.0
    allow ${USERNAME:-admin}:${PASSWORD} readonly
EOF

echo "Running $@"
exec "$@"

