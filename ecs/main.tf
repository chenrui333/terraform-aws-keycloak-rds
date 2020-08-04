resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_cluster_name}"
}

# ------------------------------------------------------------------------------
# IAM - Task execution role, needed to pull ECR images etc.
# ------------------------------------------------------------------------------
resource "aws_iam_role" "execution" {
  name               = "${var.ecs_cluster_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

resource "aws_iam_role_policy" "task_execution" {
  name   = "${var.ecs_cluster_name}-task-execution"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.task_execution_permissions.json
}

# resource "aws_iam_role_policy" "read_repository_credentials" {
#   count  = length(var.repository_credentials) != 0 ? 1 : 0
#   name   = "${var.ecs_cluster_name}-read-repository-credentials"
#   role   = aws_iam_role.execution.id
#   policy = data.aws_iam_policy_document.read_repository_credentials.json
# }

# ------------------------------------------------------------------------------
# IAM - Task role, basic. Users of the module will append policies to this role
# when they use the module. S3, Dynamo permissions etc etc.
# ------------------------------------------------------------------------------
resource "aws_iam_role" "task" {
  name               = "${var.ecs_cluster_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

resource "aws_iam_role_policy" "log_agent" {
  name   = "${var.ecs_cluster_name}-log-permissions"
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_permissions.json
}

data "template_file" "task_definition" {
  template = "${file("${path.module}/templates/task-definition.tpl")}"

  vars = {
    image_url               = "${var.docker_image_url}"
    container_name          = "${var.container_name}"
    log_group_region        = "${var.aws_region}"
    log_group_name          = "${var.app_log_group_name}"
    log_group_prefix        = "keycloak-demo"
    container_port          = "${var.docker_container_port}"
    keycloak_admin_username = "${var.keycloak_admin_username}"
    keycloak_admin_password = "${var.keycloak_admin_password}"
    database_hostname       = "${var.database_hostname}"
    database_port           = "${var.database_port}"
    database_name           = "${var.database_name}"
    database_username       = "${var.database_username}"
    database_password       = "${var.database_password}"
  }
}


resource "aws_ecs_task_definition" "main" {
  family                = "${var.ecs_task_family}"
  container_definitions = "${data.template_file.task_definition.rendered}"

  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.execution.arn
}

resource "aws_ecs_service" "main" {
  name            = "ecs_service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  desired_count   = "${var.ecs_desired_instances}"
  iam_role        = "${var.ecs_iam_role_name}"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.docker_container_port}"
  }

  depends_on = [
    "var.alb_listener_front_end",
    "var.ecs_service_iam_role_policy"
  ]
}
