# Technologies

KICS support scanning multiple technologies, in the next sections you will find more details about each technology.

## Ansible

KICS supports scanning Ansible files with `.yaml` extension.

## Azure Resource Manager

KICS supports scanning Azure Resource Manager (ARM) templates with `.json` extension. To build ARM JSON templates from Bicep code check the [official ARM documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli#build) and [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/compare-template-syntax) to understand the differences between ARM JSON templates and Bicep

## CloudFormation

KICS supports scanning CloudFormation templates with `.json` or `.yaml` extension.

## Docker

KICS supports scanning Docker files named `Dockerfile` or with `.dockerfile` extension.

## Helm

KICS supports scanning Helm by rendering charts and running Kubernetes queries against the rendered manifest.

The charts file structure must be as explained by Helm: https://helm.sh/docs/topics/charts/#the-chart-file-structure.

Results are displayed against original Helm files:

```
Service With External Load Balance, Severity: MEDIUM, Results: 1
Description: Service has an external load balancer, which may cause accessibility from other networks and the Internet
Platform: Kubernetes

        [1]: /charts/nginx-ingress/templates/controller-service.yaml:20

                019:     release: {{ template "nginx-ingress.releaseLabel" . }}
                020:   name: {{ template "nginx-ingress.controller.fullname" . }}
                021: spec:

```

## Kubernetes

KICS supports scanning Kubernetes manifests with `.yaml` extension.

## OpenAPI

KICS supports scanning OpenAPI 3.0 specs with `.json` and `.yaml` extension.

## Terraform

KICS supports scanning Terraform's HCL files with `.tf` extension and input variables using `terraform.tfvars` or files with `.auto.tfvars` extension that are in same directory of `.tf` files.

### Terraform Plan

KICS supports scanning terraform plans given in JSON. The `planned_values` will be extracted, built in a way KICS can understand, and scanned as a normal terraform file.

Results will point to the plan file.

To get terraform plan in JSON format simply run the command:
```
terraform show -json plan-sample.tfplan > plan-sample.tfplan.json
```

### Limitations

Although KICS support variables and interpolations, KICS does not support functions and enviroment variables. In case of variables used as function parameters, it will parse as wrapped expression, so the following function call:

```hcl
resource "aws_launch_configuration" "example" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "${concat(list("${var.name}", "${var.other_name}"), var.node_tags)}"
  spot_price    = var.price
  user_data_base64 = "${var.data}=="
}
```

Considering `var.data = "a123B"` and `var.price = 1.023`, it would be parsed like the following example:

```hcl
resource "aws_launch_configuration" "example" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "${concat(list("${var.name}", "${var.other_name}"), var.node_tags)}"
  spot_price    = 1.023
  user_data_base64 = "a123B=="
}
```
