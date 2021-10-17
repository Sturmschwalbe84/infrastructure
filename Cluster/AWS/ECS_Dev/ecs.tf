#======================================================================
# Rainbow Gravity's Inrastructure for exam
# 
# Elsatic Compute Service resources
#======================================================================

# sed -i 's/ignore_changes = \[\]/ignore_changes = []/' ecs.tf
# sed -i "s/ignore_changes = []/ignore_changes = []/" ecs.tf

resource "aws_ecs_service" "VPC_ECS_Service_Dev" {
  name            = "${local.ENV_Tag}-Dev"
  cluster         = data.terraform_remote_state.Instances_State.outputs.ECS_Cluster
  task_definition = aws_ecs_task_definition.Task_Dev.arn
  desired_count   = local.Dev_App.amount
  launch_type     = "EC2"
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  load_balancer {
    target_group_arn = data.terraform_remote_state.Instances_State.outputs.VPC_Dev_Target_Group
    container_name   = "${local.ENV_Tag}-Dev-Container"
    container_port   = local.Dev_App.port
  }
  tags = local.ECS_Service
}

resource "aws_ecs_task_definition" "Task_Dev" {
  family = "${local.ENV_Tag}-Dev-APP"
  container_definitions = jsonencode([
    {
      name      = "${local.ENV_Tag}-Dev-Container"
      image     = local.Dev_App.image
      cpu       = local.Dev_App.cpu
      memory    = local.Dev_App.memory
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = local.Dev_App.port
          hostPort      = 0
        }
      ]
    }
  ])
  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }
  lifecycle {
    ignore_changes = []
  }
}