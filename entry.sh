#!/bin/sh
if [ ! $AGREE_TOS ]; then
    echo "You MUST agree Let's Encrypt TOS to continue, set AGREE_TOS to 1."
    exit 1
fi

cat <<EOF > ~/.cloudflare
dns_cloudflare_email = $EMAIL
dns_cloudflare_api_key = $CLOUDFLARE_TOKEN
EOF

chmod 400 ~/.cloudflare

certbot certonly \
    --non-interactive --agree-tos --email $EMAIL \
    --cert-name default \
    --dns-cloudflare --dns-cloudflare-credentials ~/.cloudflare \
    -d $DOMAINS

kubectl --token=$K8S_TOKEN -n $K8S_NAMESPACE delete secret $K8S_SECRET_NAME
kubectl --token=$K8S_TOKEN -n $K8S_NAMESPACE create secret tls $K8S_SECRET_NAME \
    --cert=/etc/letsencrypt/live/default/fullchain.pem --key=/etc/letsencrypt/live/default/privkey.pem