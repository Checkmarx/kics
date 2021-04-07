# Techonologies

KICS support multiple technologies, following you will find more details about each technology.

## Ansible

KICS supports Ansible files with `.yaml` extension.

## CloudFormation

KICS supports CloudFormation files with `.json` or `.yaml` extension.

## Docker

KICS supports Docker files with `.dockerfile` extension.

## Helm

TBD

## Kubernetes

KICS supports Kubernetes files with `.yaml` extension.

## Terraform

KICS support `.tf` extension and input variables using `terraform.tfvars` or files with `.auto.tfvars` extension that are in same directory of `.tf` files.

Although KICS support variables and interpolations, KICS does not support functions and enviroment variables. In case of variables used as function parameters, it will parse as wrapped expression, so the following function call: 

```hcl
resource "aws_launch_configuration" "example" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "${concat(list("${var.name}", "${var.other_name}"), var.node_tags)}"
  spot_price    = var.price
  user_data_base64 = "${var.data}=="
}
```

Considering `var.data = a123B` and `var.price = 1.023`, it would be parsed like the following example:

```hcl
resource "aws_launch_configuration" "example" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "${concat(list("${var.name}", "${var.other_name}"), var.node_tags)}"
  spot_price    = 1.023
  user_data_base64 = "a123B=="
}
```
