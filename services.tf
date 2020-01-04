
# module "service_helloworld" {
#     source          = "./modules/service"
#     vpc_id          = module.vpc.vpc_id
#     region          = var.aws_region

#     is_public       = true

#     # Service name
#     service_name        = "service-helloworld"
#     service_base_path   = [ "/*" ]
#     service_priority    = 800
#     container_port      = 80

#     service_launch_type = "FARGATE"

#     service_healthcheck = {
#         healthy_threshold   = 3
#         unhealthy_threshold = 10
#         timeout             = 60
#         interval            = 120
#         matcher             = "200"
#         path                = "/actuator/health"
#         port                = 80
#     }

#     # Cluster to deploy your service - see in clusters.tf
#     cluster_name        = var.cluster_name
#     cluster_id          = module.cluster_example.cluster_id
#     cluster_listener    = module.cluster_example.listener
#     cluster_mesh        = module.cluster_example.cluster_mesh

#     cluster_service_discovery = module.cluster_example.cluster_service_discovery

#     # Auto Scale Limits
#     desired_tasks   = 1
#     min_tasks       = 1
#     max_tasks       = 10

#     # Tasks CPU / Memory limits
#     desired_task_cpu        = 256
#     desired_task_mem        = 512

#     # CPU metrics for Auto Scale
#     cpu_to_scale_up         = 80
#     cpu_to_scale_down       = 20
#     cpu_verification_period = 60
#     cpu_evaluation_periods  = 1

#     # Pipeline Configuration
#     build_image         = "aws/codebuild/standard:2.0"

#     git_repository_owner    = "longhanhee"
#     git_repository_name     = "microservice-hello-world"
#     git_repository_branch   = "master"

#     # AZ's
#     availability_zones  = [
#         module.vpc.public_subnet_1a,
#         module.vpc.public_subnet_1b,
#         module.vpc.public_subnet_1c
#     ]
# }

# module "service_currency" {
#     source          = "./modules/service"
#     vpc_id          = module.vpc.vpc_id
#     region          = var.aws_region

#     is_public       = true  

#     # Service name
#     service_name        = "service-currency"
#     service_base_path   = [ "/*" ]
#     service_priority    = 701
#     container_port      = 8000

#     service_launch_type = "FARGATE"

#     service_healthcheck = {
#         healthy_threshold   = 3
#         unhealthy_threshold = 10
#         timeout             = 60
#         interval            = 120
#         matcher             = "200"
#         path                = "/api/currency-exchange-microservice/manage/health"
#         port                = 8000
#     }

#     # Cluster to deploy your service - see in clusters.tf
#     cluster_name        = var.cluster_name
#     cluster_id          = module.cluster_example.cluster_id
#     cluster_listener    = module.cluster_example.listener
#     cluster_mesh        = module.cluster_example.cluster_mesh

#     cluster_service_discovery = module.cluster_example.cluster_service_discovery

#     # Auto Scale Limits
#     desired_tasks   = 1
#     min_tasks       = 1
#     max_tasks       = 10

#     # Tasks CPU / Memory limits
#     desired_task_cpu        = 256
#     desired_task_mem        = 512

#     # CPU metrics for Auto Scale
#     cpu_to_scale_up         = 80
#     cpu_to_scale_down       = 20
#     cpu_verification_period = 60
#     cpu_evaluation_periods  = 1

#     # Pipeline Configuration
#     build_image         = "aws/codebuild/standard:2.0"

#     git_repository_owner    = "longhanhee"
#     git_repository_name     = "currency-exchange-service-h2-xray"
#     git_repository_branch   = "master"

#     # AZ's
#     availability_zones  = [
#         module.vpc.public_subnet_1a,
#         module.vpc.public_subnet_1b,
#         module.vpc.public_subnet_1c
#     ]
# }


module "service_currency_rds" {
    source          = "./modules/service"
    vpc_id          = module.vpc.vpc_id
    region          = var.aws_region

    is_public       = true
    mode_database   = "rds"
    rds_hostname    = module.rds_instance.this_db_instance_endpoint

    # Service name
    service_name        = "service-currency-rds"
    service_base_path   = [ "/*" ]
    service_priority    = 701
    container_port      = 8000

    service_launch_type = "FARGATE"

    service_healthcheck = {
        healthy_threshold   = 3
        unhealthy_threshold = 10
        timeout             = 60
        interval            = 120
        matcher             = "200"
        path                = "/api/currency-exchange-microservice/manage/health"
        port                = 8000
    }

    # Cluster to deploy your service - see in clusters.tf
    cluster_name        = var.cluster_name
    cluster_id          = module.cluster_example.cluster_id
    cluster_listener    = module.cluster_example.listener
    cluster_mesh        = module.cluster_example.cluster_mesh

    cluster_service_discovery = module.cluster_example.cluster_service_discovery

    # Auto Scale Limits
    desired_tasks   = 1
    min_tasks       = 1
    max_tasks       = 10

    # Tasks CPU / Memory limits
    desired_task_cpu        = 256
    desired_task_mem        = 512

    # CPU metrics for Auto Scale
    cpu_to_scale_up         = 80
    cpu_to_scale_down       = 20
    cpu_verification_period = 60
    cpu_evaluation_periods  = 1

    # Pipeline Configuration
    build_image         = "aws/codebuild/standard:2.0"

    git_repository_owner    = "longhanhee"
    git_repository_name     = "currency-exchange-service-mysql"
    git_repository_branch   = "master"

    # AZ's
    availability_zones  = [
        module.vpc.public_subnet_1a,
        module.vpc.public_subnet_1b,
        module.vpc.public_subnet_1c
    ]
}