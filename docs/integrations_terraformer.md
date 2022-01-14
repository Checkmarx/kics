# Running KICS with Terraformer for AWS

## **Disclaimer:** In order to run terraformer with KICS please follow the following prerequisites:

### Install Terraform

Follow the steps described in Hashicorp documentation https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform in order to install terraform.

### Configure AWS Credentials

<!-- - Install AWS CLI following these [steps](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Configure your AWS CLI following these [steps](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config) -->

Set your AWS credentials as environment variables

```sh
export AWS_ACCESS_KEY_ID="<AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN="<AWS_SESSION_TOKEN>"
```

Windows:
```sh
$env:AWS_ACCESS_KEY_ID='<AWS_ACCESS_KEY_ID>'
$env:AWS_SECRET_ACCESS_KEY='<AWS_SECRET_ACCESS_KEY>'
$env:AWS_SESSION_TOKEN='<AWS_SESSION_TOKEN>'
```


### Install AWS Provider Plugin

In order for KICS to import resources using terraformer is required that the AWS Provider plugin for terraform be present.

To install AWS Provider plugin:
- Download the plugin from [Terraform Providers](https://releases.hashicorp.com/terraform-provider-aws/3.72.0/) according to your architecture.
- Unzip the file to:

### Linux:
```
$HOME/.terraform.d/plugins/linux_{arch}/

Example:
~/.terraform.d/plugins/linux_amd64/terraform-provider-aws_v3.71.0_x5
```

### Windows:

```
%APPDATA%\terraform.d\plugins\windows_{arch}

Example:
%APPDATA%\terraform.d\plugins\windows_amd64\terraform-provider-aws_v3.72.0_x5.exe
```

### Darwin

```
$HOME/.terraform.d/plugins/darwin_{arch}

Example:
$HOME/.terraform.d/plugins/darwin_amd64/terraform-provider-aws_3.72.0_darwin_amd64
```


## KICS Terraform Path Syntax

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



## Running KICS with Terraformer Behaviour

Example path:

```sh
kics scan -p 'terraformer::aws:vpc/subnet:eu-west-2/eu-west-1'
```

Imported Resources tree structure:

```
 ▾ kics-extract-terraformer/
    ▾ {region}/
        ▾ {resource}/
            provider.tf
            {resource}.tf
            terraform.tfstate
            variables.tf
```

When Running KICS using a terraformer path, resources are imported using the credentials set as environment variables in terraform format to the current working directory to a newly created folder named `kics-extract-terraformer` following the above-described structure.
KICS will then run a scan on these local files.

## **NOTES**

- If environment credentials are incorrect a timeout may occur.
- If the resource to import doesn't exist in the region specified a {resource}.tf file will not be created.
