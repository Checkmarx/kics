# Running KICS with Terraformer (Deprecated after 1.7.13)

From version 1.5, KICS integrates with Terraformer to scan resources deployed in the Cloud. The runtime information of the resources is obtained by providing a Terraformer path to KICS, via `-p` flag. The scan happens immediately after this information is obtained. In the end, results are shown as for any other KICS scan.

**Cloud providers supported:**
- AWS
- AZURE
- GCP

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


## Configure AZURE Credentials
KICS provides two possibilities to use Terraformer with AZURE. Each one requires AZURE account credentials that you need to set as environment variables.

#### Using Service Principal with Client Certificate

MacOS and Linux:
```sh
export ARM_SUBSCRIPTION_ID="<ARM_SUBSCRIPTION_ID>"
export ARM_CLIENT_ID="<ARM_CLIENT_ID>"
export ARM_CLIENT_CERTIFICATE_PATH="<ARM_CLIENT_CERTIFICATE_PATH>"
export ARM_CLIENT_CERTIFICATE_PASSWORD="<ARM_CLIENT_CERTIFICATE_PASSWORD>"
export ARM_TENANT_ID="<ARM_TENANT_ID>"
```

Windows:

```sh
SET ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID>
SET ARM_CLIENT_ID="<ARM_CLIENT_ID>"
SET ARM_CLIENT_CERTIFICATE_PATH="<ARM_CLIENT_CERTIFICATE_PATH>"
SET ARM_CLIENT_CERTIFICATE_PASSWORD="<ARM_CLIENT_CERTIFICATE_PASSWORD>"
SET ARM_TENANT_ID="<ARM_TENANT_ID>"
```

Powershell:

```sh
$Env:ARM_SUBSCRIPTION_ID="<ARM_SUBSCRIPTION_ID>"
$Env:ARM_CLIENT_ID="<ARM_CLIENT_ID>"
$Env:ARM_CLIENT_CERTIFICATE_PATH="<ARM_CLIENT_CERTIFICATE_PATH>"
$Env:ARM_CLIENT_CERTIFICATE_PASSWORD="<ARM_CLIENT_CERTIFICATE_PASSWORD>"
$Env:ARM_TENANT_ID="<ARM_TENANT_ID>"
```

#### Service Principal with Client Secret

MacOS and Linux:
```sh
export ARM_SUBSCRIPTION_ID="<ARM_SUBSCRIPTION_ID>"
export ARM_CLIENT_ID="<ARM_CLIENT_ID>"
export ARM_CLIENT_SECRET="<ARM_CLIENT_SECRET>"
export ARM_TENANT_ID="<ARM_TENANT_ID>"
```

Windows:

```sh
SET ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID>
SET ARM_CLIENT_ID="<ARM_CLIENT_ID>"
SET ARM_CLIENT_SECRET="<ARM_CLIENT_SECRET>"
SET ARM_TENANT_ID="<ARM_TENANT_ID>"
```

Powershell:

```sh
$Env:ARM_SUBSCRIPTION_ID="<ARM_SUBSCRIPTION_ID>"
$Env:ARM_CLIENT_ID="<ARM_CLIENT_ID>"
$Env:ARM_CLIENT_SECRET="<ARM_CLIENT_SECRET>"
$Env:ARM_TENANT_ID="<ARM_TENANT_ID>"
```

## KICS Terraformer Path Syntax


### AWS

```sh
terraformer::{CloudProvider}:{Resources}:{Regions}
```

### AZURE
```sh
terraformer::{CloudProvider}:{Resources}
```

### GCP
```sh
terraformer::{CloudProvider}:{Resources}:{Regions}:{Projects}
```

**CloudProvider**: The name of the Cloud Provider to import from.

Possible values:
- `aws`
- `azure`
- `gcp`

**Resources:** A slash-separated list of the resources intended to be imported and scanned.
You can find a complete list of possible values in the links below:
- [aws](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md#supported-services)
- [azure](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/azure.md#list-of-supported-azure-resources)
- [gcp](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/gcp.md)

To import all resources please use: `*`

**Regions**: A slash-separated list of the regions to import from. **It is only required for AWS and GCP**.

**Projects**: A slash-separated list of the projects ids to import from. **It is only required for GCP**.

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

### [AWS] Run KICS Terraformer integration with Docker

To run KICS Terraformer integration with Docker simply pass the AWS Credentials that were set as environment variables to the `docker run` command and use the terraformer path syntax

Examples:

```sh
docker run -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_SESSION_TOKEN checkmarx/kics:latest scan -p "terraformer::aws:vpc:eu-west-2" -v --no-progress
```
```sh
docker run -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_SESSION_TOKEN -v ${PWD}:/path/ checkmarx/kics:latest scan -p "terraformer::aws:vpc:eu-west-2" -v --no-progress -o /path/results
```

![docker_terraformer.gif](img/docker_terraformer.gif)

### [AZURE] Run KICS Terraformer integration with Docker
To run KICS Terraformer integration with Docker simply pass the AZURE Credentials that were set as environment variables to the docker run command and use the terraformer path syntax. Choose one of the following options:

#### Using Service Principal with Client Certificate
Note that you should fill the `<certificate_path>` with the path that points to the directory where your certificate is located, and the `<certificate-name>` should point to the certificate name located in `<certificate_path>`.

```sh
docker run -v <certificate_path>:/certificate -e ARM_CLIENT_CERTIFICATE_PATH=/certificate/<certificate_name>.pfx -e ARM_CLIENT_CERTIFICATE_PASSWORD -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_SUBSCRIPTION_ID checkmarx/kics:latest scan -p "terraformer::azure:storage_account" -v --no-progress
```
```sh
docker run -v <certificate_path>:/certificate -v ${PWD}:/path/ -e ARM_CLIENT_CERTIFICATE_PATH=/certificate/<certificate_name>.pfx -e ARM_CLIENT_CERTIFICATE_PASSWORD -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_SUBSCRIPTION_ID checkmarx/kics:latest scan -p "terraformer::azure:storage_account" -v --no-progress -o /path/results
```

![client_certificate_terraformer_azure](https://user-images.githubusercontent.com/74001161/152843317-7e83b70c-2a44-4f22-8a5e-fa9434950269.gif)


#### Service Principal with Client Secret
```sh
docker run -e ARM_SUBSCRIPTION_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_TENANT_ID checkmarx/kics:latest scan -p "terraformer::azure:storage_account" -v --no-progress
```
```sh
docker run -e ARM_SUBSCRIPTION_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_TENANT_ID -v ${PWD}:/path/ checkmarx/kics:latest scan -p "terraformer::azure:storage_account" -v --no-progress -o /path/results
```

![client_secret_terraformer_azure](https://user-images.githubusercontent.com/74001161/152833926-68b7cc56-23c0-4297-b308-56f4c6746e09.gif)


### [GCP] Run KICS Terraformer integration with Docker
To run KICS Terraformer integration with Docker, pass the path that points to the JSON file that contains your service account key as an environment variable (GOOGLE_APPLICATION_CREDENTIALS) to the docker run command and use the terraformer path syntax. Note that your project should have a region defined, and your account should have read permissions to list resources.

Also note that you should fill the `<credentials_path>` with the path that points to the directory where your service account key file is located, and the `<credentials-file-name>` should point to the service account key file name located in `<credentials_path>`.

```sh
 docker run -v <credentials_path>:/credentials -e GOOGLE_APPLICATION_CREDENTIALS=/credentials/<credentials-file-name> checkmarx/kics:latest scan -p "terraformer::gcp:gcs:us-east4:project" -v --no-progress --log-level=DEBUG
```
```sh
 docker run -v <credentials_path>:/credentials -v ${PWD}:/path/ -e GOOGLE_APPLICATION_CREDENTIALS=/credentials/<credentials-file-name> checkmarx/kics:latest scan -p "terraformer::gcp:gcs:us-east4:project" -v --no-progress --log-level=DEBUG -o /path/results
```

 ![credentials_key_gcp](https://user-images.githubusercontent.com/74001161/153022195-9d2a1cae-71c3-443a-ac08-4e2697f93469.gif)


## **NOTES**

- If environment credentials are incorrect a timeout may occur.
- If the resource to import doesn't exist in the region specified a {resource}.tf file will not be created.
- You can find the Terraform output in `terraformer-output.txt` inside `kics-extract-terraformer` folder.
