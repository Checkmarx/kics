# Integrate KICS with Codefresh

Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development cycle of your infrastructure-as-code with KICS Codefresh step by Checkmarx.

You can find the KICS Codefresh step [here](https://github.com/Checkmarx/kics-codefresh-step).

**Please, be aware that the KICS Codefresh step can require MEDIUM instances**.

## ARGUMENTS


| **Variable**                  | **Example Value** &nbsp;                    | **Description** &nbsp;                                                                                                                                          | **Type**    | **Required** | **Default**                                       |
| ------------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------- | --------------------------------------------- |
| PROJECT_PATH                     | terraform/main.tf,Dockerfile            | paths to a file or directories to scan, comma separated list                                                                                                | string  | Yes      | N/A                                           |
| IGNORE\_ON\_EXIT                | results                                                                                 | defines which kind of non-zero exits code should be ignored (all, results, errors, none)                                                                                                                 | string               | No                    | N/A                  |
| FAIL_ON                     | high,medium                                                                     | which kind of results should return an exit code different from 0                                                                                                                                        | string               | No                    | critical,high,medium,low,info                  |
| TIME_OUT                                 | 75                                                                          | number of seconds the query has to execute before being canceled                                                                                                                                         | string               | No                    | 60                  |
| PROFILING                                 | CPU                                                                       | enables performance profiler that prints resource consumption metrics in the logs during the execution (CPU, MEM)                                                                                  | string               | No                     | N/A                  |
| TYPES                           | Ansible,Terraform                                                            | case insensitive list of platform types to scan (Ansible, AzureResourceManager, CloudFormation, Dockerfile, Docker Compose, GRPC, GoogleDeploymentManager, Kubernetes, OpenAPI, Terraform)      | string    | No                    | All                  |
| EXCLUDE_PATHS                     | ./shouldNotScan/*,somefile.txt                                                  | exclude paths from scan                                                                                                                                                                                  | string               | No                    | N/A                  |
| EXCLUDE_QUERIES                 | e69890e6-fce5-461d-98ad-cb98318dfc96,4728cd65-a20c-49da-8b31-9c08b423e4db       | exclude queries by providing the query ID; cannot be provided with query inclusion flags                                                                                                        | string               | No                    | N/A                  |
| EXCLUDE_CATEGORIES          | Access control,Best practices                                                      | exclude categories by providing its name; cannot be provided with query inclusion flags                                                                                                                  | string               | No                    | N/A                  |
| EXCLUDE_SEVERETIES            | info,low                                                                              | exclude results by providing the severity of a result                                                                                                                                                    | string               | No                    | N/A                  |
| EXCLUDE_RESULTS                  | d4a1fa80-d9d8-450f-87c2-e1f6669c41f8                                                    | exclude results by providing the similarity ID of a result                                                                                                                                               | string               | No                    | N/A                  |
| INCLUDE_QUERIES                  | a227ec01-f97a-4084-91a4-47b350c1db54                                                    | include queries by providing the query ID; cannot be provided with query exclusion flags                                                                                                     | string               | No                    | N/A       |
| OUTPUT_FORMATS                | json,sarif                                                                            | formats in which the results will be exported (all, asff, csv, cyclonedx, glsast, html, json, junit, pdf, sarif, sonarqube)                                                                           | string               | No                    | json                  |
| OUTPUT_PATH                         | myResults/                                                                        | directory path to store reports                                                                                                                                                                       | string               | No                    | N/A                  |
| PAYLOAD_PATH                       | /tmp/mypayload.json                                                                   | path to store internal representation JSON file                                                                                                                                                          | string               | No                    | N/A                  |
| QUERIES_PATH                        | query                                                                                  | "example": "/tmp/mypayload.json"                                                                                                                                                                         | string               | No                    | ./assets/queries downloaded with the binaries                  |
| VERBOSE                     | true                                                                           | write logs to stdout too (mutually exclusive with silent)                                                                                                                           | boolean               | No                    | false                  |
| BOM                             | true                                                                          | include bill of materials (BoM) in results output;                                                                                                                                        | boolean               | No                    | false                  |
| DISABLE\_FULL\_DESCRIPTIONS        | true                                                            | disable request for full descriptions and use default vulnerability descriptions                                                                               | boolean               | No                     | false                  |
| DISABLE_SECRETS                   | true                                         | disable secrets  scanning                                                                                                                                                           | boolean               | No                    | false                  |
| SECRETS\_REGEXES\_PATH                 | ./mydir/secrets-config.json                                                             | path to secrets regex rules configuration file                                                                                                                                                           | string               | No                    | N/A                  |
| LIBRARIES_PATH                      | ./myLibsDir                                                                        | path to directory with libraries                                                                                                                                                                         | string               | No                    | N/A                  |


## EXAMPLES


### RUNNING KICS

```
steps:
    clone:
      title: Clone a project
      type: git-clone
      repo: 'rafaela-soares/query'
      git: github
    run_kics:
          title: Scanning IaC files
          type: checkmarx/kics
          arguments:
              PROJECT_PATH: ./query
```

### RUNNING KICS AND SAVING KICS REPORTS

🚨 Be aware that you should set `IGNORE_ON_EXIT: results` to be able to avoid the KICS exit code and run the step that saves the report.

#### GITHUB REPOSITORY
```
steps:
    clone:
      title: Clone a project
      type: git-clone
      repo: 'rafaela-soares/query'
      git: github
    run_kics:
          title: Scanning IaC files
          type: checkmarx/kics
          arguments:
              PROJECT_PATH: ./query
              QUERIES_PATH: ./query/alb_listening_on_http
              OUTPUT_PATH: /codefresh/volume/query/reports
              OUTPUT_FORMATS: all
              VERBOSE: true
              EXCLUDE_PATHS: ./query/alb_listening_on_http/test/negative.yaml
              TYPES: Ansible
              LOG_LEVEL: DEBUG
              PAYLOAD_PATH: /codefresh/volume/query/payload.json
              IGNORE_ON_EXIT: results
    save_reports_and_payload:
          title: Saving KICS payload and KICS reports
          type: git-commit
        arguments:
              repo: 'rafaela-soares/query'
              git: github
              working_directory: '/codefresh/volume/query'
              commit_message: saved payload and reports
              git_user_name: git-user-name
              git_user_email: git-user@email.com
              allow_empty: false
              add:
                - payload.json
                - ./reports
```


#### S3 BUCKET
```
steps:
    clone:
      title: Clone a project
      type: git-clone
      repo: 'rafaela-soares/query'
      git: github
    run_kics:
          title: Scanning IaC files
          type: checkmarx/kics
          arguments:
              PROJECT_PATH: ./query
              QUERIES_PATH: ./query/alb_listening_on_http
              OUTPUT_PATH: /codefresh/volume/query/reports
              OUTPUT_FORMATS: all
              VERBOSE: true
              EXCLUDE_PATHS: ./query/alb_listening_on_http/test/negative.yaml
              TYPES: Ansible
              LOG_LEVEL: DEBUG
              IGNORE_ON_EXIT: results
    save_reports_in_s3_bucket:
             title: Saving KICS reports
             image: 'amazon/aws-cli'
             working_directory: '/codefresh/volume/query'
             commands:
                 - mkdir ~/.aws
                 - touch ~/.aws/config
                 - chmod 600 ~/.aws/config
                 - echo "[default]" > ~/.aws/config
                 - echo "aws_access_key_id=${AWS_ACCESS_KEY_ID}" >> ~/.aws/config
                 - echo "aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/config
                 - echo "aws_session_token=${AWS_SESSION_TOKEN}" >> ~/.aws/config
                 - echo "region=${AWS_REGION}" >> ~/.aws/config
                 - aws s3 cp ./reports s3://${{BUCKET_NAME}}/ --recursive
```
