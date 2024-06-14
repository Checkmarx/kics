data "tencentcloud_vpc_subnets" "vpc" {
  is_default        = true
  availability_zone = "ap-guangzhou-3"
}

resource "tencentcloud_kubernetes_cluster" "has_encryption_protection" {
  vpc_id                  = data.tencentcloud_vpc_subnets.vpc.instance_list.0.vpc_id
  cluster_cidr            = "10.32.0.0/16"
  cluster_max_pod_num     = 32
  cluster_name            = "tf_example_cluster"
  cluster_desc            = "a tf example cluster for the kms test"
  cluster_max_service_num = 32
  cluster_deploy_type     = "MANAGED_CLUSTER"
}


resource "tencentcloud_kms_key" "example" {
  alias       = "tf-example-kms-key"
  description = "example of kms key instance"
  key_usage   = "ENCRYPT_DECRYPT"
  is_enabled  = true
}

resource "tencentcloud_kubernetes_encryption_protection" "example" {
  cluster_id = tencentcloud_kubernetes_cluster.has_encryption_protection.id
  kms_configuration {
    key_id     = tencentcloud_kms_key.example.id
    kms_region = "ap-guangzhou"
  }
}
