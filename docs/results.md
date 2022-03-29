# Results

KICS can export results in multiple formats which can be seen on the following list:

-   ASFF (asff)
-   CSV (csv)
-   CycloneDX (cyclonedx)
-   Gitlab SAST (glsast)
-   HTML (html)
-   JSON (json)
-   JUnit (junit)
-   PDF (pdf)
-   SARIF (sarif)
-   SonarQube (sonarqube)

To export in JSON format in current directory, you can use the following command:

```bash
./kics scan -p <path-of-your-project-to-scan> -o ./
```

To generate in other formats you can use the following command:

```bash
./kics scan -p <path-of-your-project-to-scan> --report-formats <formats-wanted> -o ./
```

KICS also can export multiple format in a single scan, to do this the flags output-path and report-formats should be combined,
where the output-path will be the directory containing all report files and report-formats all extensions wanted, like following example:

```bash
./kics scan -p <path-of-your-project-to-scan> -o ./output --report-formats "all"
```

The last command will execute the scan and save all types reports on output folder with results name.

You can also change the default name by using the following command:

```bash
./kics scan -p <path-of-your-project-to-scan> -o ./output --report-formats "glsast,html,pdf" --output-name kics-result
```

This will generate an HTML and Gitlab SAST reports on output folder, with `kics-result` and `gl-sast-kics-result` names.

## Descriptions

After the scanning process is done, If an internet connection is available, KICS will try to fetch CIS Proprietary vulnerability descriptions from a HTTP endpoint, this can be disabled with `--disable-cis-descriptions`. If used in offline mode or no internet connection is available, KICS should use the default descriptions.

In case of using KICS behind a corporate proxy, proxy configurations can be set with environment variables such as `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`

# Report examples

## JSON

The JSON report is the default report to be generate, if no arg is passed to `report-formats` flag, also you can explicitly use it with `--report-formats "json"`.
JSON reports are sorted by severity (from high to info) and should looks like as following:

```json
{
    "files_scanned": 2,
    "files_parsed": 2,
    "files_failed_to_scan": 0,
    "queries_total": 253,
    "queries_failed_to_execute": 0,
    "queries_failed_to_compute_similarity_id": 0,
    "queries": [
        {
            "query_name": "Container Allow Privilege Escalation Is True",
            "query_id": "c878abb4-cca5-4724-92b9-289be68bd47c",
            "severity": "MEDIUM",
            "platform": "Terraform",
            "files": [
                {
                    "file_name": "assets/queries/terraform/kubernetes/container_allow_privilege_escalation_is_true/test/positive.tf",
                    "similarity_id": "063ed2389809f5f01ff420b63634700a9545c5e5130a6506568f925cdb0f8e13",
                    "line": 11,
                    "issue_type": "IncorrectValue",
                    "search_key": "kubernetes_pod[test3].spec.container.allow_privilege_escalation",
                    "search_value": "",
                    "expected_value": "Attribute 'allow_privilege_escalation' is undefined or false",
                    "actual_value": "Attribute 'allow_privilege_escalation' is true",
                    "value": null
                }
            ]
        }
    ],
    "scan_id": "console",
    "severity_counters": {
        "HIGH": 0,
        "INFO": 0,
        "LOW": 0,
        "MEDIUM": 1
    },
    "total_counter": 1
}
```

## SARIF

You can export sarif report by using `--report-formats "sarif"`.
SARIF reports are sorted by severity (from high to info), following [SARIF v2.1.0 standard](https://docs.oasis-open.org/sarif/sarif/v2.1.0/cs01/sarif-v2.1.0-cs01.html) and looks like:

```json
{
    "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
    "version": "2.1.0",
    "runs": [
        {
            "tool": {
                "driver": {
                    "name": "KICS",
                    "version": "1.2.0",
                    "fullName": "Keeping Infrastructure as Code Secure",
                    "informationUri": "https://www.kics.io/",
                    "rules": [
                        {
                            "id": "c878abb4-cca5-4724-92b9-289be68bd47c",
                            "name": "Container Allow Privilege Escalation Is True",
                            "shortDescription": {
                                "text": "Container Allow Privilege Escalation Is True"
                            },
                            "fullDescription": {
                                "text": "Admission of privileged containers should be minimized"
                            },
                            "defaultConfiguration": {
                                "level": "warning"
                            },
                            "helpUri": "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod#allow_privilege_escalation",
                            "relationships": [
                                {
                                    "target": {
                                        "id": "CAT001",
                                        "index": 5,
                                        "toolComponent": {
                                            "name": "Categories",
                                            "guid": "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
                                            "index": 0
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            },
            "results": [
                {
                    "ruleId": "c878abb4-cca5-4724-92b9-289be68bd47c",
                    "ruleIndex": 0,
                    "kind": "fail",
                    "message": {
                        "text": "Attribute 'allow_privilege_escalation' is true"
                    },
                    "locations": [
                        {
                            "physicalLocation": {
                                "artifactLocation": {
                                    "uri": "assets/queries/terraform/kubernetes/container_allow_privilege_escalation_is_true/test/positive.tf"
                                },
                                "region": {
                                    "startLine": 11
                                }
                            }
                        }
                    ]
                }
            ],
            "taxonomies": [
                {
                    "guid": "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
                    "name": "Categories",
                    "fullDescription": {
                        "text": "This taxonomy contains the types an issue can assume"
                    },
                    "shortDescription": {
                        "text": "Vulnerabilities categories"
                    },
                    "taxa": [
                        {
                            "id": "CAT000",
                            "name": "Undefined Category",
                            "shortDescription": {
                                "text": "Category is not defined"
                            },
                            "fullDescription": {
                                "text": "Category is not defined"
                            }
                        },
                        {
                            "id": "CAT010",
                            "name": "Observability",
                            "shortDescription": {
                                "text": "Logging and Monitoring"
                            },
                            "fullDescription": {
                                "text": "Logging and Monitoring"
                            }
                        },
                        {
                            "id": "CAT011",
                            "name": "Resource Management",
                            "shortDescription": {
                                "text": "Resource and privilege limit configuration"
                            },
                            "fullDescription": {
                                "text": "Resource and privilege limit configuration"
                            }
                        },
                        {
                            "id": "CAT012",
                            "name": "Secret Management",
                            "shortDescription": {
                                "text": "Secret and Key management"
                            },
                            "fullDescription": {
                                "text": "Secret and Key management"
                            }
                        },
                        {
                            "id": "CAT013",
                            "name": "Supply-Chain",
                            "shortDescription": {
                                "text": "Dependency version management"
                            },
                            "fullDescription": {
                                "text": "Dependency version management"
                            }
                        },
                        {
                            "id": "CAT001",
                            "name": "Access Control",
                            "shortDescription": {
                                "text": "Service permission and identity management"
                            },
                            "fullDescription": {
                                "text": "Service permission and identity management"
                            }
                        },
                        {
                            "id": "CAT004",
                            "name": "Best Practices",
                            "shortDescription": {
                                "text": "Metadata management"
                            },
                            "fullDescription": {
                                "text": "Metadata management"
                            }
                        },
                        {
                            "id": "CAT005",
                            "name": "Build Process",
                            "shortDescription": {
                                "text": "Insecure configurations when building/deploying Docker images"
                            },
                            "fullDescription": {
                                "text": "Insecure configurations when building/deploying Docker images"
                            }
                        },
                        {
                            "id": "CAT007",
                            "name": "Insecure Configurations",
                            "shortDescription": {
                                "text": "Configurations which expose the application unnecessarily"
                            },
                            "fullDescription": {
                                "text": "Configurations which expose the application unnecessarily"
                            }
                        },
                        {
                            "id": "CAT009",
                            "name": "Networking and Firewall",
                            "shortDescription": {
                                "text": "Network port exposure and firewall configuration"
                            },
                            "fullDescription": {
                                "text": "Network port exposure and firewall configuration"
                            }
                        },
                        {
                            "id": "CAT002",
                            "name": "Availability",
                            "shortDescription": {
                                "text": "Reliability and Scalability"
                            },
                            "fullDescription": {
                                "text": "Reliability and Scalability"
                            }
                        },
                        {
                            "id": "CAT003",
                            "name": "Backup",
                            "shortDescription": {
                                "text": "Survivability and Recovery"
                            },
                            "fullDescription": {
                                "text": "Survivability and Recovery"
                            }
                        },
                        {
                            "id": "CAT006",
                            "name": "Encryption",
                            "shortDescription": {
                                "text": "Data Security and Encryption configuration"
                            },
                            "fullDescription": {
                                "text": "Data Security and Encryption configuration"
                            }
                        },
                        {
                            "id": "CAT008",
                            "name": "Insecure Defaults",
                            "shortDescription": {
                                "text": "Configurations that are insecure by default"
                            },
                            "fullDescription": {
                                "text": "Configurations that are insecure by default"
                            }
                        }
                    ]
                }
            ]
        }
    ]
}
```

## Gitlab SAST

You can export html report by using `--report-formats "glsast"`.
Gitlab SAST reports are sorted by severity (from high to info), following [Gitlab SAST Report scheme](https://docs.gitlab.com/ee/development/integrations/secure.html#report), also, the generated file will have a prefix `gl-sast-` as [recommendend by Gitlab docs](https://docs.gitlab.com/ee/development/integrations/secure.html#output-file) and looks like:

```json
{
    "schema": "https://gitlab.com/gitlab-org/security-products/security-report-schemas/-/raw/v14.1.0/dist/sast-report-format.json",
    "version": "14.1.0",
    "scan": {
        "start_time": "2021-05-26T17:22:13",
        "end_time": "2021-05-26T17:22:13",
        "status": "success",
        "type": "sast",
        "scanner": {
            "id": "keeping-infrastructure-as-code-secure",
            "name": "Keeping Infrastructure as Code Secure",
            "url": "https://www.kics.io/",
            "version": "development",
            "vendor": {
                "name": "Checkmarx"
            }
        }
    },
    "vulnerabilities": [
        {
            "id": "32e763ac363dfee1ea972d951fb3de00f5f7a8d3f9f57b93e55e2d51957794a6",
            "category": "sast",
            "severity": "High",
            "cve": "32e763ac363dfee1ea972d951fb3de00f5f7a8d3f9f57b93e55e2d51957794a6",
            "scanner": {
                "id": "keeping_infrastructure_as_code_secure",
                "name": "Keeping Infrastructure as Code Secure"
            },
            "name": "Container Is Privileged",
            "message": "Do not allow container to be privileged.",
            "links": [
                {
                    "url": "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod#privileged"
                }
            ],
            "location": {
                "file": "assets/queries/terraform/kubernetes/container_is_privileged/test/positive.tf",
                "start_line": 8,
                "end_line": 8
            },
            "identifiers": [
                {
                    "type": "kics",
                    "name": "Keeping Infrastructure as Code Secure",
                    "url": "https://docs.kics.io/latest/queries/terraform-queries",
                    "value": "87065ef8-de9b-40d8-9753-f4a4303e27a4"
                }
            ]
        },
        {
            "id": "32e763ac363dfee1ea972d951fb3de00f5f7a8d3f9f57b93e55e2d51957794a6",
            "category": "sast",
            "severity": "High",
            "cve": "32e763ac363dfee1ea972d951fb3de00f5f7a8d3f9f57b93e55e2d51957794a6",
            "scanner": {
                "id": "keeping_infrastructure_as_code_secure",
                "name": "Keeping Infrastructure as Code Secure"
            },
            "name": "Container Is Privileged",
            "message": "Do not allow container to be privileged.",
            "links": [
                {
                    "url": "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod#privileged"
                }
            ],
            "location": {
                "file": "assets/queries/terraform/kubernetes/container_is_privileged/test/positive.tf",
                "start_line": 8,
                "end_line": 8
            },
            "identifiers": [
                {
                    "type": "kics",
                    "name": "Keeping Infrastructure as Code Secure",
                    "url": "https://docs.kics.io/latest/queries/terraform-queries",
                    "value": "87065ef8-de9b-40d8-9753-f4a4303e27a4"
                }
            ]
        },
        {
            "id": "3d4f14f3ac2ebc0d2cb1710eec4f61fae359fe78ab244cb716485cb6c90846f6",
            "category": "sast",
            "severity": "High",
            "cve": "3d4f14f3ac2ebc0d2cb1710eec4f61fae359fe78ab244cb716485cb6c90846f6",
            "scanner": {
                "id": "keeping_infrastructure_as_code_secure",
                "name": "Keeping Infrastructure as Code Secure"
            },
            "name": "Container Is Privileged",
            "message": "Do not allow container to be privileged.",
            "links": [
                {
                    "url": "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod#privileged"
                }
            ],
            "location": {
                "file": "assets/queries/terraform/kubernetes/container_is_privileged/test/positive.tf",
                "start_line": 108,
                "end_line": 108
            },
            "identifiers": [
                {
                    "type": "kics",
                    "name": "Keeping Infrastructure as Code Secure",
                    "url": "https://docs.kics.io/latest/queries/terraform-queries",
                    "value": "87065ef8-de9b-40d8-9753-f4a4303e27a4"
                }
            ]
        }
    ]
}
```

## JUnit

You can export JUnit report by using `--report-formats "junit"`.
JUnit reports follow [JUnit XML specification by junit-team](https://github.com/junit-team/junit5/blob/main/platform-tests/src/test/resources/jenkins-junit.xsd), also, the generated file will have a prefix `junit-` and looks like:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="KICS vdevelopment" time="11.5808455s" failures="25">
	<testsuite name="[Terraform]" failures="11" tests="11">
		<testcase name="[Authentication Without MFA]: Users should authenticate with MFA (Multi-factor Authentication)">
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/iam_policy_grants_full_permissions/test/positive.tf&#39; file in line 20, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/iam_user_policy_without_mfa/test/negative.tf&#39; file in line 43, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/authentication_without_mfa/test/positive2.tf&#39; file in line 19, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/root_account_has_active_access_keys/test/negative.tf&#39; file in line 16, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/iam_user_policy_without_mfa/test/negative.tf&#39; file in line 18, &#39;policy.Statement.Principal.AWS&#39; contains &#39;:mfa/&#39; or &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is set to true, but &#39;policy.Statement.Principal.AWS&#39; doesn&#39;t contain &#39;:mfa/&#39; or &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is set to false."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/iam_policies_attached_to_user/test/positive2.tf&#39; file in line 20, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/iam_policy_grants_full_permissions/test/negative.tf&#39; file in line 20, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/iam_user_policy_without_mfa/test/positive.tf&#39; file in line 18, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/root_account_has_active_access_keys/test/positive1.tf&#39; file in line 16, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/root_account_has_active_access_keys/test/positive2.tf&#39; file in line 16, The attributes &#39;policy.Statement.Condition&#39;, &#39;policy.Statement.Condition.BoolIfExists&#39;, and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; are defined and not null, but The attribute(s) &#39;policy.Statement.Condition&#39; or/and &#39;policy.Statement.Condition.BoolIfExists&#39; or/and &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is/are undefined or null."></failure>
			<failure type="Authentication Without MFA" message="A problem was found on &#39;assets/queries/terraform/aws/authentication_without_mfa/test/positive1.tf&#39; file in line 23, &#39;policy.Statement.Principal.AWS&#39; contains &#39;:mfa/&#39; or &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is set to true, but &#39;policy.Statement.Principal.AWS&#39; doesn&#39;t contain &#39;:mfa/&#39; or &#39;policy.Statement.Condition.BoolIfExists.aws:MultiFactorAuthPresent&#39; is set to false."></failure>
		</testcase>
	</testsuite>
	<testsuite name="[CloudFormation]" failures="14" tests="14">
		<testcase name="[CloudWatch Metrics Disabled]: Checks if CloudWatch Metrics is Enabled">
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/cloudwatch_metrics_disabled/test/positive4.json&#39; file in line 5, Resources.Prod.Properties.MethodSettings should be defined, but Resources.Prod.Properties.MethodSettings is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/positive6.json&#39; file in line 13, Resources.GreetingApiProdStage2.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage2.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/negative1.yaml&#39; file in line 12, Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/positive2.yaml&#39; file in line 12, Resources.GreetingApiProdStage1.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage1.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/cloudwatch_metrics_disabled/test/positive1.yaml&#39; file in line 18, Resources.Prod.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.Prod.Properties.MethodSettings[0].MetricsEnabled is set to false."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/cloudwatch_metrics_disabled/test/positive3.yaml&#39; file in line 6, Resources.Prod.Properties.MethodSettings should be defined, but Resources.Prod.Properties.MethodSettings is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/cloudwatch_metrics_disabled/test/positive2.json&#39; file in line 25, Resources.Prod.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.Prod.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/cloudwatch_metrics_disabled/test/positive1.yaml&#39; file in line 20, Resources.Prod.Properties.MethodSettings[1].MetricsEnabled should be set to true, but Resources.Prod.Properties.MethodSettings[1].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/negative2.json&#39; file in line 17, Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/positive4.json&#39; file in line 35, Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/positive5.json&#39; file in line 16, Resources.GreetingApiProdStage1.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage1.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/positive1.yaml&#39; file in line 12, Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/api_gateway_deployment_without_access_log_setting/test/positive3.yaml&#39; file in line 12, Resources.GreetingApiProdStage2.Properties.MethodSettings[0].MetricsEnabled should be set to true, but Resources.GreetingApiProdStage2.Properties.MethodSettings[0].MetricsEnabled is undefined."></failure>
			<failure type="CloudWatch Metrics Disabled" message="A problem was found on &#39;assets/queries/cloudFormation/cloudwatch_metrics_disabled/test/positive2.json&#39; file in line 32, Resources.Prod.Properties.MethodSettings[1].MetricsEnabled should be set to true, but Resources.Prod.Properties.MethodSettings[1].MetricsEnabled is set to false."></failure>
		</testcase>
	</testsuite>
</testsuites>
```

Also, you can check our [Jenkins integration section](integrations_jenkins.md) to check how to integrate this report with Jenkins JUnit plugin.

## SonarQube

You can export sonarqube report by using `--report-formats "sonarqube"`.
SonarQube reports, follow [SonarQube Import Format](https://docs.sonarqube.org/latest/analysis/generic-issue/), also, the generated file will have a prefix `sonarqube-` and looks like:

```json
{
    "issues": [
        {
            "engineId": "KICS 1.4.7",
            "ruleId": "0afa6ab8-a047-48cf-be07-93a2f8c34cf7",
            "severity": "MAJOR",
            "type": "VULNERABILITY",
            "primaryLocation": {
                "message": "All Application Load Balancers (ALB) must be protected with Web Application Firewall (WAF) service",
                "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/negative2.tf",
                "textRange": {
                    "startLine": 1
                }
            },
            "secondaryLocations": [
                {
                    "message": "All Application Load Balancers (ALB) must be protected with Web Application Firewall (WAF) service",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive4.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "All Application Load Balancers (ALB) must be protected with Web Application Firewall (WAF) service",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/negative1.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "All Application Load Balancers (ALB) must be protected with Web Application Firewall (WAF) service",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive1.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "All Application Load Balancers (ALB) must be protected with Web Application Firewall (WAF) service",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive2.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "All Application Load Balancers (ALB) must be protected with Web Application Firewall (WAF) service",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive3.tf",
                    "textRange": {
                        "startLine": 1
                    }
                }
            ]
        },
        {
            "engineId": "KICS development",
            "ruleId": "6e3fd2ed-5c83-4c68-9679-7700d224d379",
            "severity": "MAJOR",
            "type": "CODE_SMELL",
            "primaryLocation": {
                "message": "It's considered a best practice when using Application Load Balancers to drop invalid header fields",
                "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive5.tf",
                "textRange": {
                    "startLine": 1
                }
            },
            "secondaryLocations": [
                {
                    "message": "It's considered a best practice when using Application Load Balancers to drop invalid header fields",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive6.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "It's considered a best practice when using Application Load Balancers to drop invalid header fields",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/negative3.tf",
                    "textRange": {
                        "startLine": 1
                    }
                }
            ]
        },
        {
            "engineId": "KICS development",
            "ruleId": "afecd1f1-6378-4f7e-bb3b-60c35801fdd4",
            "severity": "MINOR",
            "type": "CODE_SMELL",
            "primaryLocation": {
                "message": "Application Load Balancer should have deletion protection enabled",
                "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive2.tf",
                "textRange": {
                    "startLine": 1
                }
            },
            "secondaryLocations": [
                {
                    "message": "Application Load Balancer should have deletion protection enabled",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive1.tf",
                    "textRange": {
                        "startLine": 7
                    }
                },
                {
                    "message": "Application Load Balancer should have deletion protection enabled",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive6.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "Application Load Balancer should have deletion protection enabled",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive5.tf",
                    "textRange": {
                        "startLine": 9
                    }
                },
                {
                    "message": "Application Load Balancer should have deletion protection enabled",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive4.tf",
                    "textRange": {
                        "startLine": 1
                    }
                },
                {
                    "message": "Application Load Balancer should have deletion protection enabled",
                    "filePath": "assets/queries/terraform/aws/alb_deletion_protection_disabled/test/positive3.tf",
                    "textRange": {
                        "startLine": 7
                    }
                }
            ]
        }
    ]
}
```

## HTML

You can export html report by using `--report-formats "html"`.
HTML reports are sorted by severity (from high to info), the results will have query information, a list of files which vulnerability was found and a code snippet where the problem was detected as you can see in following example:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/html_report.png" width="850">

## PDF

You can export a pdf report by using `--report-formats "pdf"`.
PDF reports are sorted by severity (from high to info), the results will have query information and a list of files alongside the line where the result was found.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/pdf-report.png" width="850">

# Exit Status Code

## Results Status Code

| Code | Description                |
| ---- | -------------------------- |
| `0`  | No Results were Found      |
| `50` | Found any `HIGH` Results   |
| `40` | Found any `MEDIUM` Results |
| `30` | Found any `LOW` Results    |
| `20` | Found any `INFO` Results   |

## Error Status Code

| Code  | Description      |
| ----- | ---------------- |
| `126` | Engine Error     |
| `130` | Signal-Interrupt |

## CycloneDX

Now, the CycloneDX report is only available in XML format since the vulnerability schema extension is not currently available in JSON. The guidelines used to build the CycloneDX report were the [bom schema 1.3](http://cyclonedx.org/schema/bom/1.3) and [vulnerability schema 1.0](https://github.com/CycloneDX/specification/blob/master/schema/ext/vulnerability-1.0.xsd).

You can export CycloneDX report by using `--report-formats "cyclonedx"`. The generated report file will have a prefix `cyclonedx-` and looks like the following example:

```
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.3" serialNumber="urn:uuid:9f9c80f3-5795-476d-974f-85e6cf1daa65" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1">
	<metadata>
		<timestamp>2021-12-03T15:39:49Z</timestamp>
		<tools>
			<tool>
				<vendor>Checkmarx</vendor>
				<name>KICS</name>
				<version>development</version>
			</tool>
		</tools>
	</metadata>
	<components>
		<component type="file" bom-ref="pkg:generic/assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-68b4caecf5d5">
			<name>assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf</name>
			<version>0.0.0-68b4caecf5d5</version>
			<hashes>
				<hash alg="SHA-256">68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29</hash>
			</hashes>
			<purl>pkg:generic/assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-68b4caecf5d5</purl>
			<v:vulnerabilities>
				<v:vulnerability ref="pkg:generic/assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-68b4caecf5d5e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10">
					<v:id>e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10</v:id>
					<v:source>
						<name>KICS</name>
						<url>https://kics.io/</url>
					</v:source>
					<v:ratings>
						<v:rating>
							<v:severity>None</v:severity>
							<v:method>Other</v:method>
						</v:rating>
					</v:ratings>
					<v:description>[Terraform].[Resource Not Using Tags]: AWS services resource tags are an essential part of managing components</v:description>
					<v:recommendations>
						<v:recommendation>
							<Recommendation>In line 1, a result was found. &#39;aws_guardduty_detector[{{negative1}}].tags is undefined or null&#39;, but &#39;aws_guardduty_detector[{{negative1}}].tags is defined and not null&#39;</Recommendation>
						</v:recommendation>
					</v:recommendations>
				</v:vulnerability>
			</v:vulnerabilities>
		</component>
	</components>
</bom>
```

## ASFF

You can export ASFF (AWS Security Finding Format) report by using `--report-formats "asff"`. The generated report file will have a prefix `asff-`.

For default, the ASFF report uses a default AWS account ID ("AWS_ACCOUNT_ID") and a default AWS region ("AWS_REGION"). To set these values, you need to define AWS_ACCOUNT_ID and AWS_REGION in your environment variables.

```
[
	{
		"AwsAccountId": "AWS_ACCOUNT_ID",
		"Compliance": {
			"Status": "FAILED"
		},
		"CreatedAt": "2022-01-14T13:50:30Z",
		"Description": "CloudTrail Log Files should have validation enabled",
		"GeneratorId": "4d8681a2-3d30-4c89-8070-08acd142748e",
		"Id": "AWS_REGION/AWS_ACCOUNT_ID/1dc18f740a5c4173264949fb366d3c3871d7d457c4db91f6d73a76caa9873000",
		"ProductArn": "arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default",
		"Remediation": {
			"Recommendation": {
				"Text": "In line 2 of file assets\\queries\\ansible\\aws\\cloudtrail_log_file_validation_disabled\\test\\positive.yaml, a result was found. cloudtrail.enable_log_file_validation and cloudtrail.log_file_validation_enabled are undefined, but cloudtrail.enable_log_file_validation or cloudtrail.log_file_validation_enabled is defined"
			}
		},
		"Resources": [
			{
				"Id": "4d8681a2-3d30-4c89-8070-08acd142748e",
				"Type": "Other"
			}
		],
		"SchemaVersion": "2018-10-08",
		"Severity": {
			"Original": "LOW",
			"Label": "LOW"
		},
		"Title": "CloudTrail Log File Validation Disabled",
		"Types": [
			"Software and Configuration Checks/Vulnerabilities/KICS"
		],
		"UpdatedAt": "2022-01-14T13:50:30Z"
	}
]
```

## CSV

You can export CSV report by using `--report-formats "csv"`.

CSV reports follow the [CSV structure](https://www.loc.gov/preservation/digital/formats/fdd/fdd000323.shtml#:~:text=CSV%20is%20a%20simple%20format,characters%20indicating%20a%20line%20break.).

| query_name                                     | query_id                             | query_uri                                                                                             | severity | platform       | cloud_provider | category                | description_id | description                                                                    | cis_description_id | cis_description_title | cis_description_text | file_name                                                                                                   | similarity_id                                                    | line | issue_type     | search_key                                                      | search_line | search_value | expected_value                                                                          | actual_value                                                                           |
| ---------------------------------------------- | ------------------------------------ | ----------------------------------------------------------------------------------------------------- | -------- | -------------- | -------------- | ----------------------- | -------------- | ------------------------------------------------------------------------------ | ------------------ | --------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | ---- | -------------- | --------------------------------------------------------------- | ----------- | ------------ | --------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| EC2 Sensitive Port Is Publicly Exposed         | 494b03d3-bf40-4464-8524-7c56ad0700ed | https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html | HIGH     | CloudFormation | AWS            | Networking and Firewall | 680b7e89       | The EC2 instance has a sensitive port connection exposed to the entire network |                    |                       |                      | ../../assets/queries/cloudFormation/aws/security_groups_with_unrestricted_access_to_ssh/test/positive2.json | 9730156b201b5098479a7b624d01931303a2f27c3991c7a786aeb2c10912894a | 27   | IncorrectValue | Resources.InstanceSecurityGroup.SecurityGroupIngress            | 0           | TCP,22       | SSH (TCP:22) should not be allowed in EC2 security group for instance Ec2Instance       | SSH (TCP:22) is allowed in EC2 security group for instance Ec2Instance                 |
| EC2 Sensitive Port Is Publicly Exposed         | 494b03d3-bf40-4464-8524-7c56ad0700ed | https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html | HIGH     | CloudFormation | AWS            | Networking and Firewall | 680b7e89       | The EC2 instance has a sensitive port connection exposed to the entire network |                    |                       |                      | ../../assets/queries/cloudFormation/aws/security_groups_with_unrestricted_access_to_ssh/test/positive1.yaml | a93a3f7320a60045c04cd950500a1c3cff5bc9a4aae7f1e0cde73033386e1242 | 15   | IncorrectValue | Resources.InstanceSecurityGroup.SecurityGroupIngress            | 0           | TCP,22       | SSH (TCP:22) should not be allowed in EC2 security group for instance Ec2Instance       | SSH (TCP:22) is allowed in EC2 security group for instance Ec2Instance                 |
| Security Group With Unrestricted Access To SSH | 6e856af2-62d7-4ba2-adc1-73b62cef9cc1 | https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group.html | HIGH     | CloudFormation | AWS            | Networking and Firewall | d515d6dc       | Security Groups allows all traffic for SSH (port:22)                           |                    |                       |                      | ../../assets/queries/cloudFormation/aws/security_groups_with_unrestricted_access_to_ssh/test/positive1.yaml | ca8ec85623eed6a5cb3d3b8c1b69d145778e28517d2adf5fb856a57f9870c430 | 15   | IncorrectValue | Resources.InstanceSecurityGroup.Properties.SecurityGroupIngress | 0           |              | None of the Resources.InstanceSecurityGroup.Properties.SecurityGroupIngress has port 22 | One of the Resources.InstanceSecurityGroup.Properties.SecurityGroupIngress has port 22 |
