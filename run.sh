#!/bin/bash 

export STORAGE_ACCOUNT=${STORAGE_ACCOUNT:-STORAGEACCOUNT}
export STORAGE_ACCOUNT_ACCESS_KEY=${STORAGE_ACCOUNT_ACCESS_KEY:-STORAGE_ACCOUNT_ACCESS_KEY}

envsubst < /etc/fluent/fluent.template > /etc/fluent/fluent.conf

/usr/sbin/rsyslogd

exec fluentd