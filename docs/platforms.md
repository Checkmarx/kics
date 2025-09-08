# Technologies

KICS support scanning multiple technologies, in the next sections you will find more details about each technology.

## Ansible

KICS supports scanning Ansible files with `.yaml` extension.

KICS can decrypt Ansible Vault files on the fly. For that, you need to define the environment variable `ANSIBLE_VAULT_PASSWORD_FILE`.

## Ansible Config

KICS supports scanning Ansible Configuration files with `.cfg` or `.conf` extension.

## Ansible Inventory

KICS supports scanning Ansible Inventory files with `.ini`, `.json` or `.yaml` extension.

## Azure Resource Manager

KICS supports scanning Azure Resource Manager (ARM) templates with `.json` extension or Bicep files with `.bicep` extension.

Explore our ongoing enhancements and planned features on our [Future Improvements](future_improvements.md) page.

## Buildah

KICS supports scanning Buildah container build scripts with a .sh extension. 

Currently, KICS offers one query for this platform, but the goal is to expand its capabilities to scan for potential misconfigurations, security vulnerabilities and best practice violations in Buildah scripts.

## CICD

KICS supports scanning GitHub Workflows CICD files with `.yaml` or `.yml` extension.

## CloudFormation

KICS supports scanning CloudFormation templates with `.json` or `.yaml` extension.

## CDK

[AWS Cloud Development Kit](https://docs.aws.amazon.com/cdk/latest/guide/home.html) is a software development framework for defining cloud infrastructure in code and provisioning it through AWS CloudFormation.

It has all the advantages of using [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html).

KICS currently support scanning AWS Cloudformation templates. In this guide, we will describe how to scan a simple CDK defined infrastructure following the [Working With the AWS CDK in Go](https://docs.aws.amazon.com/cdk/latest/guide/work-with-cdk-go.html) documentation.

Make sure all [prerequisites](https://docs.aws.amazon.com/cdk/latest/guide/work-with-cdk-go.html#go-prerequisites) are met.

### Create a project

1. Create a new CDK project using the CLI. e.g:

```bash
mkdir test-cdk
cd test-cdk
cdk init app --language go
```

2. Download dependencies

```bash
go mod download
```

3. Synthetize CloudFormation template

```bash
cdk synth > cfn-stack.yaml
```

4. Execute KICS against the template and check the results. Note that KICS will recognized it as CloudFormation (for queries purpose).

```bash
docker run -t -v $PWD/cfn-stack.yaml:/path/cfn-stack.yaml -it checkmarx/kics:latest scan -p /path/cfn-stack.yaml
```

## Crossplane

KICS supports scanning Crossplane manifests with `.yaml` extension.

## Azure Blueprints

KICS supports scanning Azure Blueprints files, including Azure Blueprints Policy Assignment Artifacts, Azure Blueprints Role Assignment Artifacts, and Azure Blueprints Template Artifacts with `.json` extension.

Note that KICS recognizes this technology as Azure Resource Manager (for queries purpose).

## Docker

KICS supports scanning Docker files with any name (but with no extension) and files with `.dockerfile` extension.

## Docker Compose

KICS supports scanning DockerCompose files with `.yaml` extension.

## gRPC

KICS supports scanning gRPC files with `.proto` extension.

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

## Knative

KICS supports scanning Knative manifests with `.yaml` extension.

Due to the possibility of the definition of the [PodSpec and PodTemplate](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.21/#podspec-v1-core) in Knative files, Kubernetes Security Queries are also loaded once the presence of the Knative files is detected.

## Kubernetes

KICS supports scanning Kubernetes manifests with `.yaml` extension.

## OpenAPI

KICS supports scanning Swagger 2.0 and OpenAPI 3.0 specs with `.json` and `.yaml` extension.

## Pulumi

KICS supports scanning Pulumi manifests with `.yaml` extension.

## ServerlessFW

KICS supports scanning Serverless manifests with `.yml` extension.

Due to the possibility of the definition of the CloudFormation template,  inside `Serverless.yml`, CloudFormation Security Queries are also loaded once the presence of the ServerlessFW files is detected.

## Google Deployment Manager

KICS supports scanning Google Deployment Manager files with `.yaml` extension.

## SAM

KICS supports AWS Serverless Application Model (AWS SAM) files with `.yaml` extension. Note that KICS recognizes this technology as CloudFormation (for queries purpose).

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

### NIFCloud for Terraform

KICS supports scanning NIFCloud under Terraform file extension (`.tf`).

### Terraform variables path

When using vars in a terraform file there are 2 ways of passing the file in which a variable's value is present.

If none of these options are used kics will only resolve variables coming from the `*.auto.tfvars` files and the default variable values.

#### Option 1 - Comment on tf file
By adding, as the first line in a TF file, a rule that follows the logic below:
```
// kics_terraform_vars: path/to/terraform/vars.tf
```
This line is a comment that Kics will look for when trying to decypher the variables used in that file.

#### Option 2 - Flag when calling the scan
By adding the flag `--terraform-vars-path` to the scan command it is possible to input the path of the variables fiel that will be used for all the files in the project.

**_NOTE:_** when using both options the flag option will take precedence and therefore define the variables.

### Limitations

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
#### Analyzer Blacklist for Unsupported File Types

##### Why We Introduced a Blacklist

KICS uses regular expressions to detect the platform or type of each file during analysis. Internally, it maintains a whitelist of regex patterns that, when matched, classify a file under a supported Infrastructure-as-Code platform (e.g., Terraform, CloudFormation, ARM).
However, in practice, the **whitelist** has limitations:

- Some valid files may only match **one regex**, while others require multiple matches to be confidently classified, even though they’re all valid.
- This creates inconsistency since there's no clear threshold for "enough" matching, and tightening the rules risks missing valid files.
- Refactoring the analyzer to support a precise, rule-based whitelist would require significant design and effort.

Because of this, a **blacklist** was introduced as a practical and efficient complement to the existing whitelist. It allows KICS to explicitly **exclude known unsupported file types** early in the scanning process without triggering false positives or loading unnecessary queries.
This blacklist acts as a _short-circuit mechanism_, immediately stopping the analysis of files that match certain patterns unique to unsupported formats. This avoids wasting resources on parsing irrelevant content and improves the reliability of platform detection overall.

##### Current Blacklisted File Types

KICS now short-circuits analysis for the following types:

1. **FHIR (Fast Healthcare Interoperability Resources)** JSON files:
    - These typically contain fields like `"resourceType"`, `"entry"`, `"subject"`, `"code"`, and `"status"`.
    - They are often misclassified as ARM templates due to partial regex overlap.
2. **Azure Pipelines VSCode** files:
    - Also recognized as an ARM template, this type of files are auto-generated VSCode pipeline extension files.

##### Summary

While KICS has a whitelist-based platform detection system, its current design doesn't always allow for reliable filtering of edge cases or unsupported formats. Implementing a proper scoring or confidence-based whitelist would involve substantial complexity.

For now, the blacklist approach provides a lightweight, low-maintenance solution that:
- Improves classification accuracy by explicitly excluding irrelevant file types.
- Avoids unnecessary resource use by skipping analysis early.
- Keeps the analyzer simple and efficient, without a major overhaul.
