module "ecs" {
  source       = "terraform-aws-modules/ecs/aws"
  cluster_name = "my-ecs-cluster"

  services = {
    frontend = {
      cpu    = 512
      memory = 1024
      container_definitions = {
        app = {
          image         = "nginx:latest"
          containerPort = 80
        }
      }
      subnet_ids         = ["subnet-abc123"]
    }
  }
}
