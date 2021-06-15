# Scanning AWS CDK output with KICS

[AWS Cloud Development Kit](https://docs.aws.amazon.com/cdk/latest/guide/home.html) is a software development framework for defining cloud infrastructure in code and provisioning it through AWS CloudFormation.

It has all the advantages of using [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html).

KICS currently support scanning AWS Cloudformation templates. In this guide, we will describe how to scan a simple CDK defined infrastructure following the [Working With the AWS CDK in Go](https://docs.aws.amazon.com/cdk/latest/guide/work-with-cdk-go.html) documentation.

Make sure all [prerequisites](https://docs.aws.amazon.com/cdk/latest/guide/work-with-cdk-go.html#go-prerequisites) are met.

## Create a project

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

4. Execute KICS against the template and check the results

```bash
docker run -v $PWD/cfn-stack.yaml:/path/cfn-stack.yaml -it checkmarx/kics:latest scan -p /path/cfn-stack.yaml
```
