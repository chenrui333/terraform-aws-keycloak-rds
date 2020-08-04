#!/bin/bash
yum update -y

cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=$${ecs_cluster_name}
ECS_ENGINE_AUTH_TYPE=docker
ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/":{"username":"my_name","password":"my_password","email":"email@example.com"}}
ECS_LOGLEVEL=$${ecs_log_level}
EOF
