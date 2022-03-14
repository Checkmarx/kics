# Technologies

KICS support scanning multiple technologies, in the next sections you will find more details about each technology.

## Ansible

KICS supports scanning Ansible files with `.yaml` extension.

KICS can decrypt Ansible Vault files on the fly. For that, you need to define the environment variable `ANSIBLE_VAULT_PASSWORD_FILE`.

## Azure Resource Manager

KICS supports scanning Azure Resource Manager (ARM) templates with `.json` extension. To build ARM JSON templates from Bicep code check the [official ARM documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli#build) and [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/compare-template-syntax) to understand the differences between ARM JSON templates and Bicep

## Buildah
KICS supports scanning Buildah files with `.sh` extension.


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

KICS supports scanning Swagger 2.0 and OpenAPI 3.0 specs with `.json` and `.yaml` extension.

## Google Deployment Manager

KICS supports scanning Google Deployment Manager files with `.yaml` extension.

## gRPC

KICS supports scanning gRPC files with `.proto` extension.

## Terraform

KICS supports scanning Terraform's HCL files with `.tf` extension and input variables using `terraform.tfvars` or files with `.auto.tfvars` extension that are in same directory of `.tf` files.

### Terraform Plan

KICS supports scanning terraform plans given in JSON. The `planned_values` will be extracted, built in a way that KICS can understand, and scanned as a normal terraform file.

Results will point to the plan file.

To get terraform plan in JSON format simply run the command:
```
terraform show -json plan-sample.tfplan > plan-sample.tfplan.json
```

### Terraform Modules
KICS supports some official modules for AWS that can be found on [Terraform registry](https://registry.terraform.io/providers/hashicorp/aws/latest), you can see the supported modules list in the libraries folder [common.json file](https://github.com/Checkmarx/kics/blob/master/assets/libraries/common.json). This means KICS can find issues in verified modules listed on this json.

Currently, KICS does not support unofficial or custom modules.

### Cloud Development Kit for Terraform (CDKTF) 

KICS supports scanning CDKTF output JSON. It recognizes it through the fields `metadata`, `stackName`, and `terraform`.

To get your CDKTF output JSON, run the following command inside the directory that contains your app:
```
cdktf synth
```

You can also run the command `cdktf synth --json` to display it in the terminal.

### Limitations

#### Ansible
At the moment, KICS does not support a robust approach to identifying Ansible samples. The identification of these samples is done through exclusion. When a YAML sample is not a CloudFormation, Google Deployment Manager, Helm, Kubernetes or OpenAPI sample, KICS recognize it as Ansible.

Thus, KICS recognize other YAML samples (that are not Ansible) as Ansible, e.g. GitHub Actions samples. However, you can ignore these samples by writing `#kics-scan ignore` on the top of the file. For more details, please read this [documentation](https://github.com/Checkmarx/kics/blob/25b6b703e924ed42067d9ab7772536864aee900b/docs/running-kics.md#using-commands-on-scanned-files-as-comments).


#### Terraform
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
