# Kuberneter

From version 1.6, KICS calls the Kubernetes API to scan resources deployed in the runtime K8s cluster. The runtime information of the resources is obtained by providing the K8s credentials as environment variables and a kuberneter path to KICS, via `-p` flag. The scan happens immediately after this information is obtained. In the end, results are shown as for any other KICS scan.


## Configure K8s Credentials

For KICS to get the runtime information of your resources, you need to provide your K8s Credentials as environment variables.

### Using Config File

MacOS and Linux:
```sh
export K8S_CONFIG_FILE="<K8S_CONFIG_FILE>"
```

Windows:

```sh
SET K8S_CONFIG_FILE=<K8S_CONFIG_FILE>
```

Powershell:

```sh
$Env:K8S_CONFIG_FILE="<K8S_CONFIG_FILE>"
```

### Using Service Account Token

Note that your Service Account Token should have list permissions for the chosen resources. Additionally to that, note that `K8S_CA_DATA` and `K8S_SA_TOKEN_DATA` should be base64 encoded.

MacOS and Linux:
```sh
export K8S_HOST="<K8S_HOST>"
export K8S_CA_FILE="<K8S_CA_FILE>" or export K8S_CA_DATA="K8S_CA_DATA"
export K8S_SA_TOKEN_FILE="K8S_SA_TOKEN_FILE>" or export K8S_SA_TOKEN_DATA="K8S_SA_TOKEN_DATA"
```

Windows:

```sh
SET K8S_HOST=<K8S_HOST>
SET K8S_CA_FILE=<K8S_CA_FILE> or SET K8S_CA_DATA=<K8S_CA_DATA>
SET K8S_SA_TOKEN_FILE=<K8S_SA_TOKEN_FILE> or SET K8S_SA_TOKEN_DATA=<K8S_SA_TOKEN_DATA>
```

Powershell:

```sh
$Env:K8S_HOST="<K8S_HOST>"
$Env:K8S_CA_FILE="<K8S_CA_FILE>" or $Env:K8S_CA_DATA="<K8S_CA_DATA>"
$Env:K8S_CA_FILE="<K8S_SA_TOKEN_FILE>" or $Env:K8S_CA_DATA="<K8S_SA_TOKEN_DATA>"
```


### Using Certificate

Note that your "certificate user" should have list permissions for the chosen resources. Additionally to that, note that `K8S_CA_DATA`, `K8S_CERT_DATA`, and `K8S_KEY_DATA` should be base64 encoded.

MacOS and Linux:
```sh
export K8S_HOST="<K8S_HOST>"
export K8S_CA_FILE="<K8S_CA_FILE>" or export K8S_CA_DATA="K8S_CA_DATA"
export K8S_CERT_FILE="<K8S_CERT_FILE>" or export K8S_CERT_DATA="K8S_CERT_DATA"
export K8S_KEY_FILE="<K8S_KEY_FILE>" or export K8S_KEY_DATA="K8S_KEY_DATA"
```

Windows:

```sh
SET K8S_HOST=<K8S_HOST>
SET K8S_CA_FILE=<K8S_CA_FILE> or SET K8S_CA_DATA=<K8S_CA_DATA>
SET K8S_CERT_FILE=<K8S_CERT_FILE> or SET K8S_CERT_DATA=<K8S_CERT_DATA>
SET K8S_KEY_FILE=<K8S_KEY_FILE> or SET K8S_KEY_DATA=<K8S_KEY_DATA>
```

Powershell:

```sh
$Env:K8S_HOST="<K8S_HOST>"
$Env:K8S_CA_FILE="<K8S_CA_FILE>" or $Env:K8S_CA_DATA="<K8S_CA_DATA>"
$Env:K8S_CERT_FILE="<K8S_CERT_FILE>" or $Env:K8S_CERT_DATA="<K8S_CERT_DATA>"
$Env:K8S_KEY_FILE="<K8S_KEY_FILE>" or $Env:K8S_KEY_DATA="<K8S_KEY_DATA>"
```

## KICS Kuberneter Path Syntax

```sh
kuberneter::{namespaces}:{apiVersions}:{kinds}
```

To import all the namespaces, apiVersions, or kinds, please use: `*`. For example, `kuberneter::*:*:*`.

To specify the namespaces, apiVersions, or kinds, please use: separator `+`. For example,` kuberneter::*:apps/v1+v1:ServiceAccount`.

The API Versions and their respective kinds (both case sensitive) are listed below:

| API Versions                       | Kinds                                                                                                                   |
|------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| apps/v1                            | DaemonSet <br/>Deployment <br/>ReplicaSet <br/>StatefulSet                                                                             |
| core/v1                                 | LimitRange <br/>Pod <br/>PersistentVolume <br/>PersistentVolumeClaim <br/>ReplicationController <br/>ResourceQuota <br/>Secret ServiceAccount Service |
| batch/v1                           | CronJob <br/>Job                                                                                                             |
| networking.k8s.io/v1               | IngressClass <br/>Ingress <br/>NetworkPolicy                                                                                      |
| policy/v1                          | PodDisruptionBudget                                                                                                     |
| rbac.authorization.k8s.io/v1       | ClusterRoleBinding <br/>ClusterRole <br/>RoleBinding <br/>Role                                                                         |
| apps/v1beta1                       | Deployment <br/>StatefulSet                                                                                                  |
| apps/v1beta2                       | DaemonSet <br/>Deployment <br/>ReplicaSet S<br/>tatefulSet                                                                             |
| batch/v1beta1                      | CronJob                                                                                                                 |
| networking.k8s.io/v1beta1          | IngressClass <br/>Ingress                                                                                                    |
| policy/v1beta1                     | PodDisruptionBudget <br/>PodSecurityPolicy                                                                                   |
| rbac.authorization.k8s.io/v1alpha1 | ClusterRoleBinding <br/>ClusterRole <br/>RoleBinding <br/>Role                                                                         |
| rbac.authorization.k8s.io/v1beta1  | ClusterRoleBinding <br/>ClusterRole <br/>RoleBinding <br/>Role                                                                         |


## Running KICS to scan runtime K8s cluster

When running KICS using a kuberneter path, the resources are imported using the credentials set as environment variables in Kubernetes format to the current working directory in a new folder named `kics-extract-kuberneter` following the above-described structure.
KICS will then run a scan on these local files.

If the flag `-o, --output-path` is passed, the folder `kics-extract-kuberneter` will be generated in the reports directory instead.

### Imported Resources tree structure:

```
 ▾ kics-extract-kuberneter/
    ▾ {apiGroup}/
        ▾ {apiVersion}/
            ▾ {kind}.yaml
```

### Run KICS to scan runtime K8s cluster with Docker

To run KICS Kuberneter with Docker, you can simply pass the K8s Credentials that were set as environment variables to the docker run command and use the kuberneter path syntax

Examples:


#### Using Config File
```sh
docker run -v <credentials_path>:/credentials -v ${PWD}:/path/ -e K8S_CONFIG_FILE=/credentials/<config-file-name> checkmarx/kics:latest scan -p "kuberneter::*:*:*" -v --no-progress -o /path/results
```

#### Using Service Account Token
```sh
docker run -v ${PWD}:/path/ -e K8S_HOST -e K8S_CA_DATA -e K8S_SA_TOKEN_DATA kuberneter scan -p "kuberneter::*:*:*" -v --no-progress -o /path/results
```

#### Using Certificate
```sh
docker run -v ${PWD}:/path/ -e K8S_HOST -e K8S_CA_DATA -e K8S_SA_TOKEN_DATA kuberneter scan -p "kuberneter::*:*:*" -v --no-progress -o /path/results
```

#### Using Certificate
```sh
docker run -v ${PWD}:/path/ -e K8S_HOST -e K8S_CA_DATA -e K8S_CERT_DATA -e K8S_KEY_DATA checkmarx/kics:latest scan -p "kuberneter::*:*:*" -v --no-progress -o /path/results
```
