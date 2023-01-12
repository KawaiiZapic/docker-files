#!/bin/sh
if [ ! $AGREE_TOS ]; then
    echo "You MUST agree Let's Encrypt TOS to continue, set AGREE_TOS to 1."
    exit 1
fi
P_DOMAINS=""
for domain in $DOMAINS; do
    P_DOMAINS="$P_DOMAINS -d $domain"
done
certbot certonly \
    --non-interactive --agree-tos \
    --dns-cloudflare --dns-cloudflare-credentials ~/.cloudflare \
    $P_DOMAINS