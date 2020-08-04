#!/bin/bash
yum update -y

cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=keycloak_cluster
ECS_ENGINE_AUTH_TYPE=docker
ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/":{"username":"my_name","password":"my_password","email":"email@example.com"}}
ECS_LOGLEVEL=info
EOF
