data "aws_ssm_parameter" "RDS_PASSWORD" {
  name = "/spada/production/RDS_PASSWORD"  
}

data "aws_ssm_parameter" "RDS_USERNAME" {
  name = "/spada/production/RDS_USERNAME"  
}

data "aws_ssm_parameter" "RDS_DB_NAME" {
  name = "/spada/production/RDS_DB_NAME"  
}

data "aws_ssm_parameter" "RDS_PORT" {
  name = "/spada/production/RDS_PORT"  
}

data "template_file" "task" {

  template = var.mode_database == "rds" ? file( format("%s/task-definitions/task_rds.json", path.module)) : file( format("%s/task-definitions/envoy.json", path.module))

  vars = {
    image               = aws_ecr_repository.registry.repository_url
    container_name      = var.service_name
    container_port      = var.container_port
    log_group           = aws_cloudwatch_log_group.logs.name
    desired_task_cpu    = var.desired_task_cpu
    desired_task_memory = var.desired_task_mem
    mesh_name           = var.cluster_mesh
    virtual_node        = aws_appmesh_virtual_node.blue.name
    envoy_log_level     = var.envoy_log_level
    envoy_cpu           = var.envoy_cpu
    envoy_mem           = var.envoy_mem
    xray_cpu            = var.xray_cpu
    xray_mem            = var.xray_mem
    rds_hostname        = var.rds_hostname
    rds_db_name         = data.aws_ssm_parameter.RDS_DB_NAME.value
    rds_username        = data.aws_ssm_parameter.RDS_USERNAME.value
    rds_password        = data.aws_ssm_parameter.RDS_PASSWORD.value
    rds_port            = data.aws_ssm_parameter.RDS_PORT.value
    region              = var.region
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = format("%s-%s", var.cluster_name, var.service_name)

  container_definitions    = data.template_file.task.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  // cpu                       = var.desired_task_cpu
  // memory                    = var.desired_task_mem
  cpu                      = var.desired_task_cpu + var.envoy_cpu + var.xray_cpu
  memory                   = var.desired_task_mem + var.envoy_mem + var.xray_mem

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_execution_role.arn
}
