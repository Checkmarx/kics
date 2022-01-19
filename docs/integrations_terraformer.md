# Running KICS with Terraformer

From version 1.5, KICS integrates with Terraformer to scan resources deployed in the Cloud. The runtime information of the resources is obtained by providing a Terraformer path to KICS, via `-p` flag. The scan happens immediately after this information is obtained. In the end, results are shown as for any other KICS scan.

**Cloud providers supported:**
- AWS

## Configure AWS Credentials

For KICS to get the runtime information of your resources you need to provide AWS account Credentials as environment variables. Please note the AWS account provided should have read permissions to list service resources.

Setting AWS credentials as environment variables

MacOS and Linux:
```sh
export AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN="<AWS_SESSION_TOKEN>"
```

Windows:

```sh
SET AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
SET AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
SET AWS_SESSION_TOKEN=<AWS_SESSION_TOKEN>
```

Powershell:

```sh
$Env:AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
$Env:AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"
$Env:AWS_SESSION_TOKEN="<AWS_SESSION_TOKEN>"
```



## KICS Terraformer Path Syntax

```sh
terraformer::{CloudProvider}:{Resources}:{Regions}
```

**CloudProvider**: The name of the Cloud Provider to import from.

Possible values:
- `aws`

**Resources:** A slash-separated list of the resources intended to be imported and scanned.

You can find a complete list of possible values [here](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md#supported-services)

To import all resources please use: `*`

**Regions**: A slash-separated list of the regions to import from.

## Running KICS with Terraformer

When Running KICS using a terraformer path, resources are imported using the credentials set as environment variables in terraform format to the current working directory in a new folder named `kics-extract-terraformer` following the above-described structure.
KICS will then run a scan on these local files.

If the flag `-o, --output-path` is passed the folder `kics-extract-terraformer` will be generated in the reports directory instead.

### Imported Resources tree structure:

```
 ▾ kics-extract-terraformer/
    ▾ {region}/
        ▾ {resource}/
            provider.tf
            {resource}.tf
            terraform.tfstate
            variables.tf
```

### Docker

To run KICS Terraformer integration with Docker simply pass the AWS Credentials that were set as environment variables to the `docker run` command and use the terraformer path syntax

Examples:

```sh
docker run -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_SESSION_TOKEN checkmarx/kics:latest scan -p "terraformer::aws:vpc:eu-west-2" -v --no-progress
```
```sh
docker run -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_SESSION_TOKEN -v ${PWD}:/path/ checkmarx/kics:latest scan -p "terraformer::aws:vpc:eu-west-2" -v --no-progress -o /path/results
```



<img src="./img/docker_terraformer.gif" />

### Executable


### **Disclaimer:** In order to run terraformer with KICS executable please follow these prerequisites:

### Install Terraform

Follow the steps described in Hashicorp documentation https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform to install terraform.

### Install AWS Provider Plugin

It is required that the AWS Provider plugin for terraform to be present.

To install AWS Provider plugin:
- Download the plugin from [Terraform Providers](https://releases.hashicorp.com/terraform-provider-aws/3.72.0/) according to your architecture.
- Unzip the file to:

### Linux:
```
$HOME/.terraform.d/plugins/linux_{arch}/

Example:
~/.terraform.d/plugins/linux_amd64/terraform-provider-aws_v3.71.0_x5
```

### MacOS

```
$HOME/.terraform.d/plugins/darwin_{arch}

Example:
$HOME/.terraform.d/plugins/darwin_amd64/terraform-provider-aws_3.72.0_darwin_amd64
```

### Windows:

For Windows a little more work is required, since you can't globally install the AWS Provider plugin, you need to have it present in every directory you wish to import the resources to.

Please follow these steps:

- Create a versions.tf file in the folder you wish to run KICS and import the resources to.

- Paste the code found under `USE PROVIDER` from terraform AWS Provider [Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) in the versions.tf file you just created.

- run the command `terraform init` on the directory containing `versions.tf`. A new folder named `.terraform` should have been created containing the plugin. This folder must be present in every directory you wish to run KICS on using terraformer.

**NOTE:** `.terraform.hcl.lock` can be deleted

Example tf file:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.72.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

## Examples:

Example path:

```sh
kics scan -p 'terraformer::aws:vpc/subnet:eu-west-2/eu-west-1'
```

These examples showcase KICS integration with terraformer for importing and scanning our VPCs in region `eu-west-2`.

### Linux

<img src="./img/linux_terraformer.gif" />

### Windows

<img src="./img/windows_terraformer.gif" />

## **NOTES**

- If environment credentials are incorrect a timeout may occur.
- If the resource to import doesn't exist in the region specified a {resource}.tf file will not be created.
