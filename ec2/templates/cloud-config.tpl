#!/bin/bash
yum update -y

cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=keycloak_cluster
ECS_ENGINE_AUTH_TYPE=docker
ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v2/":{"username":"aimeetup","password":"Ebh4t7BwzrvCuxYB","email":"aimeetup@meetup.com"}}
ECS_LOGLEVEL=info
EOF
