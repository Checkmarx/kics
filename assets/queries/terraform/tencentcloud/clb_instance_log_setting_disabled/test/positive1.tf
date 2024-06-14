resource "tencentcloud_vpc" "vpc_test" {
  name       = "clb-test"
  cidr_block = "10.0.0.0/16"
}

resource "tencentcloud_route_table" "rtb_test" {
  name   = "clb-test"
  vpc_id = tencentcloud_vpc.vpc_test.id
}

resource "tencentcloud_subnet" "subnet_test" {
  name              = "clb-test"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-guangzhou-3"
  vpc_id            = tencentcloud_vpc.vpc_test.id
  route_table_id    = tencentcloud_route_table.rtb_test.id
}

resource "tencentcloud_clb_instance" "internal_clb" {
  network_type                 = "INTERNAL"
  clb_name                     = "clb_example"
  project_id                   = 0
  vpc_id                       = tencentcloud_vpc.vpc_test.id
  subnet_id                    = tencentcloud_subnet.subnet_test.id
  load_balancer_pass_to_target = true

  tags = {
    test = "tf"
  }
}
