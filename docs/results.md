# Results

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

## Descriptions (deprecated from May 1st, 2023)

After the scanning process is done, If an internet connection is available, KICS will try to fetch CIS Proprietary vulnerability descriptions from a HTTP endpoint, this can be disabled with `--disable-full-descriptions`. If used in offline mode or no internet connection is available, KICS should use the default descriptions.

In case of using KICS behind a corporate proxy, proxy configurations can be set with environment variables such as `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`

Note: From May 1st, 2023, even If an internet connection is available, KICS will receive an empty list as response and will use the default descriptions.

## JSON

The JSON report is the default report to be generate, if no arg is passed to `report-formats` flag, also you can explicitly use it with `--report-formats "json"`.
JSON reports are sorted by severity (from high to info) and should looks like as following:

```json
{
	"kics_version": "development",
	"files_scanned": 2,
	"lines_scanned": 59,
	"files_parsed": 2,
	"lines_parsed": 59,
	"lines_ignored": 0,
	"files_failed_to_scan": 0,
	"queries_total": 291,
	"queries_failed_to_execute": 0,
	"queries_failed_to_compute_similarity_id": 0,
	"scan_id": "console",
	"severity_counters": {
		"CRITICAL": 0,
		"HIGH": 10,
		"INFO": 0,
		"LOW": 0,
		"MEDIUM": 0,
		"TRACE": 0
	},
	"total_counter": 10,
	"total_bom_resources": 0,
	"start": "2024-02-14T10:27:20.947552Z",
	"end": "2024-02-14T10:28:03.7510399Z",
	"paths": [
		".\\assets\\queries\\ansible\\aws\\alb_listening_on_http\\"
	],
	"queries": [
		{
			"query_name": "ALB Listening on HTTP",
			"query_id": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
			"query_url": "https://docs.ansible.com/ansible/latest/collections/community/aws/elb_application_lb_module.html",
			"severity": "HIGH",
			"platform": "Ansible",
			"cwe": "22",
			"cloud_provider": "AWS",
			"category": "Networking and Firewall",
			"experimental": false,
			"description": "AWS Application Load Balancer (alb) should not listen on HTTP",
			"description_id": "3a7576e5",
			"files": [
				{
					"file_name": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
					"similarity_id": "02e577bf2456c31f64f2855f8345fa051c0fe2159e1f116bd392e02af5f4a4f9",
					"line": 29,
					"resource_type": "community.aws.elb_application_lb",
					"resource_name": "my_elb_application2",
					"issue_type": "MissingAttribute",
					"search_key": "name={{my_elb_application2}}.{{community.aws.elb_application_lb}}.listeners",
					"search_line": -1,
					"search_value": "",
					"expected_value": "'aws_elb_application_lb' Protocol should be 'HTTP'",
					"actual_value": "'aws_elb_application_lb' Protocol is missing"
				},
				{
					"file_name": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
					"similarity_id": "a00c90f900058bb60c8eeeaf5236416079e5085fe0465b69aa51b5aa5b7442fe",
					"line": 11,
					"resource_type": "community.aws.elb_application_lb",
					"resource_name": "my_elb_application",
					"issue_type": "IncorrectValue",
					"search_key": "name={{my_elb_application}}.{{community.aws.elb_application_lb}}.listeners.Protocol=HTTP",
					"search_line": -1,
					"search_value": "",
					"expected_value": "'aws_elb_application_lb' Protocol should be 'HTTP'",
					"actual_value": "'aws_elb_application_lb' Protocol it's not 'HTTP'"
				}
			]
		}
	]
}
```
**Overview of key-value pairs:**  									
**kics_version**: The version of KICS used for the scan.   			
**files_scanned**: The number of files scanned during the scan.   
**lines_scanned**: The total number of lines scanned during the scan.   
**files_parsed**: The number of files successfully parsed during the scan.    
**lines_parsed**: The total number of lines successfully parsed during the scan.    
**lines_ignored**: The number of lines ignored during the scan.    
**files_failed_to_scan**: The number of files that failed to be scanned.    
**queries_total**: The total number of queries executed during the scan.    
**queries_failed_to_execute**: The number of queries that failed to execute.    
**queries_failed_to_compute_similarity_id**: The number of queries that failed to compute similarity ID.   
**scan_id**: An identifier for the scan.   
**severity_counters**: A breakdown of the severity of the issues found during the scan.   
**total_counter**: The total number of issues found during the scan.   
**total_bom_resources**: The total number of Bill of Materials (BOM) resources found during the scan.   
**start**: The start timestamp of the scan.   
**end**: The end timestamp of the scan.    
**paths**: The paths scanned during the scan.    
**queries**: Information about individual queries executed during the scan, including their names, IDs, URLs, severities, platforms, CWEs, cloud providers, categories, experimental flags, descriptions, and details about the files where issues were found.   

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
                    "version": "development",
                    "fullName": "Keeping Infrastructure as Code Secure",
                    "informationUri": "https://www.kics.io/",
                    "rules": [
                        {
                            "id": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
                            "name": "ALB Listening on HTTP",
                            "shortDescription": {
                                "text": "ALB Listening on HTTP"
                            },
                            "fullDescription": {
                                "text": "AWS Application Load Balancer (alb) should not listen on HTTP"
                            },
                            "defaultConfiguration": {
                                "level": "error"
                            },
                            "helpUri": "https://docs.ansible.com/ansible/latest/collections/community/aws/elb_application_lb_module.html",
                            "relationships": [
                                {
                                    "target": {
                                        "id": "CAT009",
                                        "index": 9,
                                        "toolComponent": {
                                            "name": "Categories",
                                            "guid": "58cdcc6f-fe41-4724-bfb3-131a93df4c3f"
                                        }
                                    }
                                },
                                {
                                    "target": {
                                        "id": "22",
                                        "guid": "526eea66-dc1e-4417-9bc9-cf68292dc54d",
                                        "toolComponent": {
                                            "name": "CWE",
                                            "guid": "1489b0c4-d7ce-4d31-af66-6382a01202e3"
                                        }
                                    }
                                }
                            ]
                        },
                        // More rules may exist before the rest.
                    ]
                }
            },
            "results": [
                {
                    "ruleId": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
                    "ruleIndex": 0,
                    "kind": "fail",
                    "message": {
                        "text": "'aws_elb_application_lb' Protocol is missing",
                        "properties": {
                            "platform": "Ansible"
                        }
                    },
                    "locations": [
                        {
                            "physicalLocation": {
                                "artifactLocation": {
                                    "uri": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml"
                                },
                                "region": {
                                    "startLine": 29
                                }
                            }
                        }
                    ]
                },
                // Additional results may exist before the rest.
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
                            "name": "Undefined Category",
                            "id": "CAT000",
                            "shortDescription": {
                                "text": "Category is not defined"
                            },
                            "fullDescription": {
                                "text": "Category is not defined"
                            }
                        },
                        {
                            "name": "Backup",
                            "id": "CAT003",
                            "shortDescription": {
                                "text": "Survivability and Recovery"
                            },
                            "fullDescription": {
                                "text": "Survivability and Recovery"
                            }
                        },
                        {
                            "name": "Structure and Semantics",
                            "id": "CAT014",
                            "shortDescription": {
                                "text": "Malformed document structure or inadequate semantics"
                            },
                            "fullDescription": {
                                "text": "Malformed document structure or inadequate semantics"
                            }
                        },
                        {
                            "name": "Availability",
                            "id": "CAT002",
                            "shortDescription": {
                                "text": "Reliability and Scalability"
                            },
                            "fullDescription": {
                                "text": "Reliability and Scalability"
                            }
                        },
                        {
                            "name": "Insecure Configurations",
                            "id": "CAT007",
                            "shortDescription": {
                                "text": "Configurations which expose the application unnecessarily"
                            },
                            "fullDescription": {
                                "text": "Configurations which expose the application unnecessarily"
                            }
                        },
                        {
                            "name": "Resource Management",
                            "id": "CAT011",
                            "shortDescription": {
                                "text": "Resource and privilege limit configuration"
                            },
                            "fullDescription": {
                                "text": "Resource and privilege limit configuration"
                            }
                        },
                        {
                            "name": "Supply-Chain",
                            "id": "CAT013",
                            "shortDescription": {
                                "text": "Dependency version management"
                            },
                            "fullDescription": {
                                "text": "Dependency version management"
                            }
                        },
                        {
                            "name": "Bill Of Materials",
                            "id": "CAT015",
                            "shortDescription": {
                                "text": "List of resources provisioned"
                            },
                            "fullDescription": {
                                "text": "List of resources provisioned"
                            }
                        },
                        {
                            "name": "Access Control",
                            "id": "CAT001",
                            "shortDescription": {
                                "text": "Service permission and identity management"
                            },
                            "fullDescription": {
                                "text": "Service permission and identity management"
                            }
                        },
                        {
                            "name": "Networking and Firewall",
                            "id": "CAT009",
                            "shortDescription": {
                                "text": "Network port exposure and firewall configuration"
                            },
                            "fullDescription": {
                                "text": "Network port exposure and firewall configuration"
                            }
                        },
                        {
                            "name": "Observability",
                            "id": "CAT010",
                            "shortDescription": {
                                "text": "Logging and Monitoring"
                            },
                            "fullDescription": {
                                "text": "Logging and Monitoring"
                            }
                        },
                        {
                            "name": "Encryption",
                            "id": "CAT006",
                            "shortDescription": {
                                "text": "Data Security and Encryption configuration"
                            },
                            "fullDescription": {
                                "text": "Data Security and Encryption configuration"
                            }
                        },
                        {
                            "name": "Build Process",
                            "id": "CAT005",
                            "shortDescription": {
                                "text": "Insecure configurations when building/deploying"
                            },
                            "fullDescription": {
                                "text": "Insecure configurations when building/deploying"
                            }
                        },
                        {
                            "name": "Insecure Defaults",
                            "id": "CAT008",
                            "shortDescription": {
                                "text": "Configurations that are insecure by default"
                            },
                            "fullDescription": {
                                "text": "Configurations that are insecure by default"
                            }
                        },
                        {
                            "name": "Secret Management",
                            "id": "CAT012",
                            "shortDescription": {
                                "text": "Secret and Key management"
                            },
                            "fullDescription": {
                                "text": "Secret and Key management"
                            }
                        },
                        {
                            "name": "Best Practices",
                            "id": "CAT004",
                            "shortDescription": {
                                "text": "Metadata management"
                            },
                            "fullDescription": {
                                "text": "Metadata management"
                            }
                        }
                    ]
                },
                {
                    "guid": "1489b0c4-d7ce-4d31-af66-6382a01202e3",
                    "name": "CWE",
                    "fullDescription": {
                        "text": "The MITRE Common Weakness Enumeration"
                    },
                    "shortDescription": {
                        "text": "The MITRE Common Weakness Enumeration"
                    },
                    "downloadUri": "https://cwe.mitre.org/data/xml/cwec_v4.13.xml.zip",
                    "informationUri": "https://cwe.mitre.org/data/published/cwe_v4.13.pdf",
                    "isComprehensive": true,
                    "language": "en",
                    "minimumRequiredLocalizedDataSemanticVersion": "4.13",
                    "organization": "MITRE",
                    "releaseDateUtc": "2023-10-26",
                    "taxa": [
                        {
                            "guid": "526eea66-dc1e-4417-9bc9-cf68292dc54d",
                            "id": "22",
                            "shortDescription": {
                                "text": "The product uses external input to construct a pathname that is intended to identify a file or directory that is located underneath a restricted parent directory, but the product does not properly neutralize special elements within the pathname that can cause the pathname to resolve to a location that is outside of the restricted directory."
                            },
                            "fullDescription": {
                                "text": "Many file operations are intended to take place within a restricted directory. By using special elements such as .. and / separators, attackers can escape outside of the restricted location to access files or directories that are elsewhere on the system. One of the most common special elements is the ../ sequence, which in most modern operating systems is interpreted as the parent directory of the current location. This is referred to as relative path traversal. Path traversal also covers the use of absolute pathnames such as /usr/local/bin, which may also be useful in accessing unexpected files. This is referred to as absolute path traversal. In many programming languages, the injection of a null byte (the 0 or NUL) may allow an attacker to truncate a generated filename to widen the scope of attack. For example, the product may add .txt to any pathname, thus limiting the attacker to text files, but a null injection may effectively remove this restriction."
                            },
                            "helpUri": "https://cwe.mitre.org/data/definitions/22.html"
                        }
                    ]
                },
                // Additional taxonomies may exist before the rest.
            ]
        }
    ]
}
```
**Overview of key-value pairs:**     
**$schema**: Specifies the URI of the JSON schema file that defines the SARIF format. It ensures that the SARIF file conforms to the specified schema.   
**version**: Indicates the version of the SARIF format being used. In this case, it's version 2.1.0.   
**runs**: Contains an array of runs. Each run represents the execution of a tool on a specific set of files.   
**tool**: Describes the tool that produced the SARIF file. It includes information such as the tool name, version, full name, and URLs for more information about the tool.   
**driver**: Describes the driver component of the tool. It includes information such as the tool name, version, full name, and URLs for more information about the tool.   
**rules**: Contains an array of rules defined by the tool. Each rule represents a specific check or analysis that the tool performs.   
**id**: A unique identifier for the rule.   
**name**: The name of the rule.   
**shortDescription**: A short description of the rule.   
**fullDescription**: A full description of the rule.   
**defaultConfiguration**: Specifies the default configuration for the rule. In this case, it indicates the default severity level.   
**helpUri**: URL pointing to additional help or documentation for the rule.   
**relationships**: Describes the relationships of the rule with other entities such as taxonomies or external standards.   
**target**: Specifies the target of the relationship, which can be a category (in this case) or a Common Weakness Enumeration (CWE) entry.   
**results**: Contains an array of results produced by the tool's analysis. Each result represents an issue or finding identified during the analysis.   
**ruleId**: Specifies the ID of the rule associated with the result.   
**ruleIndex**: Specifies the index of the rule associated with the result.   
**kind**: Indicates the kind of result, such as "fail", "warning", or "note".   
**message**: Contains information about the result message, including text and properties.   
**locations**: Contains an array of locations associated with the result, specifying where the issue was found in the source code.   
**physicalLocation**: Describes a physical location in the source code where the issue was found.   
**artifactLocation**: Specifies the location of the artifact (file) containing the issue.   
**uri**: The URI of the artifact (file) containing the issue.   
**region**: Describes a region within the artifact where the issue was found, such as start line number.   
**taxonomies**: Contains an array of taxonomies used to classify issues.   
**guid**: A unique identifier for the taxonomy.   
**name**: The name of the taxonomy.   
**fullDescription**: A full description of the taxonomy.   
**shortDescription**: A short description of the taxonomy.   
**taxa**: Contains an array of taxonomic categories within the taxonomy.   

## Gitlab SAST

You can export html report by using `--report-formats "glsast"`.
Gitlab SAST reports are sorted by severity (from high to info), following [Gitlab SAST Report scheme](https://docs.gitlab.com/ee/development/integrations/secure.html#report), also, the generated file will have a prefix `gl-sast-` as [recommendend by Gitlab docs](https://docs.gitlab.com/ee/development/integrations/secure.html#output-file) and looks like:

```json
{
	"schema": "https://gitlab.com/gitlab-org/security-products/security-report-schemas/-/raw/v15.0.6/dist/sast-report-format.json",
	"version": "15.0.6",
	"scan": {
		"analyzer": {
			"id": "keeping-infrastructure-as-code-secure",
			"name": "Keeping Infrastructure as Code Secure",
			"version": "development",
			"vendor": {
				"name": "Checkmarx"
			}
		},
		"start_time": "2024-02-14T10:27:20",
		"end_time": "2024-02-14T10:28:03",
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
			"id": "02e577bf2456c31f64f2855f8345fa051c0fe2159e1f116bd392e02af5f4a4f9",
			"severity": "High",
			"name": "ALB Listening on HTTP",
            "cwe": "22",
			"links": [
				{
					"url": "https://docs.ansible.com/ansible/latest/collections/community/aws/elb_application_lb_module.html"
				}
			],
			"location": {
				"file": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
				"start_line": 29,
				"end_line": 29
			},
			"identifiers": [
				{
					"type": "kics",
					"name": "Keeping Infrastructure as Code Secure",
					"url": "https://docs.kics.io/latest/queries/ansible-queries",
					"value": "f81d63d2-c5d7-43a4-a5b5-66717a41c895"
				}
			]
		},
		{
			"id": "a00c90f900058bb60c8eeeaf5236416079e5085fe0465b69aa51b5aa5b7442fe",
			"severity": "High",
			"name": "ALB Listening on HTTP",
            "cwe": "22",
			"links": [
				{
					"url": "https://docs.ansible.com/ansible/latest/collections/community/aws/elb_application_lb_module.html"
				}
			],
			"location": {
				"file": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
				"start_line": 11,
				"end_line": 11
			},
			"identifiers": [
				{
					"type": "kics",
					"name": "Keeping Infrastructure as Code Secure",
					"url": "https://docs.kics.io/latest/queries/ansible-queries",
					"value": "f81d63d2-c5d7-43a4-a5b5-66717a41c895"
				}
			]
		},
    ]
}  
```
**Overview of key-value pairs:**   
**schema**: Specifies the URI of the JSON schema file that defines the Gitlab SAST report format. It ensures that the report conforms to the specified schema.    
**version**: Indicates the version of the Gitlab SAST report format being used.   
**scan**: Contains information about the scan performed by the SAST tool.   
**analyzer**: Provides details about the SAST tool used for analysis.   
**id**: A unique identifier for the analyzer.   
**name**: The name of the analyzer.   
**version**: The version of the analyzer.   
**vendor**: Information about the vendor of the analyzer.   
**name**: The name of the vendor.   
**start_time**: The start timestamp of the scan.   
**end_time**: The end timestamp of the scan.   
**status**: Indicates the status of the scan, whether it was successful or not.   
**type**: Specifies the type of scan, in this case, SAST (Static Application Security Testing).   
**scanner**: Provides details about the scanner used for the SAST analysis.   
**id**: A unique identifier for the scanner.   
**name**: The name of the scanner.   
**url**: URL pointing to more information about the scanner.   
**version**: The version of the scanner.   
**vendor**: Information about the vendor of the scanner.   
**name**: The name of the vendor.   
**vulnerabilities**: Contains an array of vulnerabilities found during the scan.   
**id**: A unique identifier for the vulnerability.   
**severity**: The severity level of the vulnerability.   
**name**: The name or description of the vulnerability.   
**links**: URLs pointing to additional information or resources related to the vulnerability.   
**location**: Provides information about where the vulnerability was found.   
**file**: The path to the file containing the vulnerability.   
**start_line**: The line number where the vulnerability starts.   
**end_line**: The line number where the vulnerability ends.   
**identifiers**: Provides additional identifiers for the vulnerability.   
**type**: The type of identifier (e.g., kics).   
**name**: The name or description of the identifier.   
**url**: URL pointing to more information about the identifier. 


## JUnit

You can export JUnit report by using `--report-formats "junit"`.
JUnit reports follow [JUnit XML specification by junit-team](https://github.com/junit-team/junit5/blob/main/platform-tests/src/test/resources/jenkins-junit.xsd), also, the generated file will have a prefix `junit-` and looks like:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="KICS development" time="37.8629413s" failures="10">
	<testsuite name="Ansible" failures="2" tests="2">
		<testcase cwe="22" name="ALB Listening on HTTP: assets\queries\ansible\aws\alb_listening_on_http\test\positive.yaml file in line 11" classname="Ansible">
			<failure type="AWS Application Load Balancer (alb) should not listen on HTTP" message="[Severity: HIGH, Query description: AWS Application Load Balancer (alb) should not listen on HTTP] Problem found on &#39;assets\queries\ansible\aws\alb_listening_on_http\test\positive.yaml&#39; file in line 11. Expected value: &#39;aws_elb_application_lb&#39; Protocol should be &#39;HTTP&#39;. Actual value: &#39;aws_elb_application_lb&#39; Protocol it&#39;s not &#39;HTTP&#39;."></failure>
		</testcase>
		<testcase cwe="22" name="ALB Listening on HTTP: assets\queries\ansible\aws\alb_listening_on_http\test\positive.yaml file in line 29" classname="Ansible">
			<failure type="AWS Application Load Balancer (alb) should not listen on HTTP" message="[Severity: HIGH, Query description: AWS Application Load Balancer (alb) should not listen on HTTP] Problem found on &#39;assets\queries\ansible\aws\alb_listening_on_http\test\positive.yaml&#39; file in line 29. Expected value: &#39;aws_elb_application_lb&#39; Protocol should be &#39;HTTP&#39;. Actual value: &#39;aws_elb_application_lb&#39; Protocol is missing."></failure>
		</testcase>
	</testsuite>
```

**Overview of key-value pairs:**   
**<?xml?\>**: This is the XML declaration indicating the version of XML being used and the character encoding.   
**<testsuites\>**: This is the opening tag for the <testsuites\> element, which represents a collection of test suites. Here are the key-value pairs:   
**name**: The name of the test suite.   
**time**: The total time taken for executing all the tests in the test suite.   
**failures**: The total number of test failures encountered in the test suite.   
**<testsuite\>**: This is the opening tag for a specific test suite within the overall collection. Here are the key-value pairs:   
**name**: The name of the test suite.   
**failures**: The total number of test failures encountered in this specific test suite.   
**tests**: The total number of tests executed in this specific test suite.   
**<testcase\>**: This is the opening tag for a specific test case within the test suite. Here are the key-value pairs:   
**name**: The name of the test case, which describes the scenario being tested.   
**classname**: The name of the class to which this test case belongs.   
**<failure\>**: This is the <failure\> tag indicating that the test case has failed. Here are the key-value pairs:   
**type**: The type of failure or error encountered.   
**message**: A descriptive message explaining the failure or error in detail.      
**</testcase\>**: This is the closing tag for the <testcase\> element, marking the end of the specific test case.   
**</testsuite\>**: This is the closing tag for the <testsuite\> element, marking the end of the specific test suite.   
**</testsuites\>**: This is the closing tag for the <testsuites\> element, marking the end of the overall collection of test suites.   

Also, you can check our [Jenkins integration section](integrations_jenkins.md) to check how to integrate this report with Jenkins JUnit plugin.

## SonarQube

You can export sonarqube report by using `--report-formats "sonarqube"`.
SonarQube reports, follow [SonarQube Import Format](https://docs.sonarqube.org/latest/analysis/generic-issue/), also, the generated file will have a prefix `sonarqube-` and looks like:

```json
{
	"issues": [
		{
			"engineId": "KICS development",
			"ruleId": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
			"severity": "CRITICAL",
			"cwe": "22",
			"type": "VULNERABILITY",
			"primaryLocation": {
				"message": "AWS Application Load Balancer (alb) should not listen on HTTP",
				"filePath": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
				"textRange": {
					"startLine": 11
				}
			},
			"secondaryLocations": [
				{
					"message": "AWS Application Load Balancer (alb) should not listen on HTTP",
					"filePath": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
					"textRange": {
						"startLine": 29
					}
				}
			]
		},
    ]
}
```
**Overview of key-value pairs:**   
**engineId**: This key identifies the engine or tool that detected the issue.   
**ruleId**: This key represents the unique identifier of the rule associated with the issue. It helps categorize and classify the issue based on predefined rules.   
**severity**: This key indicates the severity level of the issue.   
**type**: This key specifies the type of issue detected.   
**primaryLocation**: This key provides information about the primary location of the issue within the codebase. It includes details such as the error message, file path, and starting line number where the issue occurs.   
**message**: Describes the issue in detail.   
**filePath**: Specifies the path to the file containing the code where the issue was detected.   
**textRange**: Indicates the range of lines in the file where the issue occurs.   
**secondaryLocations**: This key provides additional information about the issue, such as other locations in the codebase where similar problems may exist.   


## HTML

You can export html report by using `--report-formats "html"`.
HTML reports are sorted by severity (from high to info), the results will have query information, a list of files which vulnerability was found and a code snippet where the problem was detected as you can see in following example:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/fc93fd1fa4ed3572b0732c787be61d4c82fff2e5/docs/img/html_report.png" width="850">

## PDF

You can export a pdf report by using `--report-formats "pdf"`.
PDF reports are sorted by severity (from high to info), the results will have query information and a list of files alongside the line where the result was found.

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/pdf_report.png" width="850">

## CycloneDX

Now, the CycloneDX report is only available in XML format since the vulnerability schema extension is not currently available in JSON. The guidelines used to build the CycloneDX report were the [bom schema 1.5](http://cyclonedx.org/schema/bom/1.5) and [vulnerability schema 1.0](https://github.com/CycloneDX/specification/blob/master/schema/ext/vulnerability-1.0.xsd).                                                                                               
**Note:** As of the latest update, the CycloneDX version utilized in the report is 1.5. However, it's important to clarify that no additional features or fields introduced in version 1.5 are currently utilized. The functionality remains consistent with the version 1.3 for KICS. Future updates will leverage the new features introduced in CycloneDX version 1.5.


You can export CycloneDX report by using `--report-formats "cyclonedx"`. The generated report file will have a prefix `cyclonedx-` and looks like the following example:

```
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.5" serialNumber="urn:uuid:031053e5-97fa-4776-bd4b-d8705b37748c" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1">
	<metadata>
		<timestamp>2024-02-14T12:21:17Z</timestamp>
		<tools>
			<tool>
				<vendor>Checkmarx</vendor>
				<name>KICS</name>
				<version>development</version>
			</tool>
		</tools>
	</metadata>
	<components>
		<component type="file" bom-ref="pkg:generic/assets/queries/ansible/aws/alb_listening_on_http/test/positive.yaml@0.0.0-eb8600d258a3">
			<name>assets/queries/ansible/aws/alb_listening_on_http/test/positive.yaml</name>
			<version>0.0.0-eb8600d258a3</version>
			<hashes>
				<hash alg="SHA-256">eb8600d258a39b160a0b1175422e4ea23274f007b0c66b3107fe3de73c4a7e89</hash>
			</hashes>
			<purl>pkg:generic/assets/queries/ansible/aws/alb_listening_on_http/test/positive.yaml@0.0.0-eb8600d258a3</purl>
			<v:vulnerabilities>
				<v:vulnerability ref="pkg:generic/assets/queries/ansible/aws/alb_listening_on_http/test/positive.yaml@0.0.0-eb8600d258a3f81d63d2-c5d7-43a4-a5b5-66717a41c895">
					<v:id>f81d63d2-c5d7-43a4-a5b5-66717a41c895</v:id>
					<v:cwe>22</v:cwe>
					<v:source>
						<name>KICS</name>
						<url>https://kics.io/</url>
					</v:source>
					<v:ratings>
						<v:rating>
							<v:severity>High</v:severity>
							<v:method>Other</v:method>
						</v:rating>
					</v:ratings>
					<v:description>[Ansible].[ALB Listening on HTTP]: AWS Application Load Balancer (alb) should not listen on HTTP</v:description>
					<v:recommendations>
						<v:recommendation>
							<Recommendation>Problem found in line 11. Expected value: &#39;aws_elb_application_lb&#39; Protocol should be &#39;HTTP&#39;. Actual value: &#39;aws_elb_application_lb&#39; Protocol it&#39;s not &#39;HTTP&#39;.</Recommendation>
						</v:recommendation>
					</v:recommendations>
				</v:vulnerability>
				<v:vulnerability ref="pkg:generic/assets/queries/ansible/aws/alb_listening_on_http/test/positive.yaml@0.0.0-eb8600d258a3f81d63d2-c5d7-43a4-a5b5-66717a41c895">
					<v:id>f81d63d2-c5d7-43a4-a5b5-66717a41c895</v:id>
					<v:cwe>22</v:cwe>
					<v:source>
						<name>KICS</name>
						<url>https://kics.io/</url>
					</v:source>
					<v:ratings>
						<v:rating>
							<v:severity>High</v:severity>
							<v:method>Other</v:method>
						</v:rating>
					</v:ratings>
					<v:description>[Ansible].[ALB Listening on HTTP]: AWS Application Load Balancer (alb) should not listen on HTTP</v:description>
					<v:recommendations>
						<v:recommendation>
							<Recommendation>Problem found in line 29. Expected value: &#39;aws_elb_application_lb&#39; Protocol should be &#39;HTTP&#39;. Actual value: &#39;aws_elb_application_lb&#39; Protocol is missing.</Recommendation>
						</v:recommendation>
					</v:recommendations>
                </v:vulnerability>
			</v:vulnerabilities>
		</component>
	</components>
</bom>
```

**Overview of key-value pairs:**   
**metadata**: This section provides metadata about the CycloneDX report, including the timestamp when the report was generated and details about the tools used to create the report.   
**timestamp**: Indicates the date and time when the report was generated. For example, "2024-02-14T12:21:17Z" specifies February 14th, 2024, at 12:21:17 UTC.   
**tools**: Specifies the tools involved in generating the CycloneDX report.   
**vendor**: Indicates the name of the tool's vendor.   
**name**: Specifies the name of the tool used.   
**version**: Specifies the version of the tool used.   
**components**: This section provides information about the components (such as files) included in the report.   
**component**: Represents a specific component (file) included in the report.   
**type**: Specifies the type of the component.   
**bom-ref**: Provides a reference to the Bill of Materials (BOM) entry for the component.   
**name**: Specifies the name of the component, a path for example.   
**version**: Specifies the version of the component.   
**hashes**: Provides hash values for the component to ensure integrity and detect changes.   
**purl**: Specifies the Package URL (purl) for the component.   
**v:vulnerabilities**: This section provides information about vulnerabilities associated with the component.   
**v:vulnerability**: Represents a specific vulnerability associated with the component.   
**ref**: Provides a reference to the vulnerability.   
**v:id**: Specifies the ID of the vulnerability.   
**v:cwe**: Specifies the Common Weakness Enumeration (CWE) ID associated with the vulnerability.   
**v:source**: Provides information about the source of the vulnerability.   
**v:ratings**: Provides ratings for the vulnerability, including severity and method.   
**v:description**: Describes the vulnerability in detail.   
**v:recommendations**: Provides recommendations for addressing the vulnerability.   
**v:recommendation**: Specifies a recommendation for addressing the vulnerability.   
**Recommendation**: Provides the recommendation text.   

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
		"CreatedAt": "2024-02-14T12:21:17Z",
		"Description": "AWS Application Load Balancer (alb) should not listen on HTTP",
		"GeneratorId": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
		"Id": "AWS_REGION/AWS_ACCOUNT_ID/a00c90f900058bb60c8eeeaf5236416079e5085fe0465b69aa51b5aa5b7442fe",
		"ProductArn": "arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default",
		"Remediation": {
			"Recommendation": {
				"Text": "Problem found on 'assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml' file in line 11. Expected value: 'aws_elb_application_lb' Protocol should be 'HTTP'. Actual value: 'aws_elb_application_lb' Protocol it's not 'HTTP'."
			}
		},
		"Resources": [
			{
				"Id": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
				"Type": "Other"
			}
		],
		"SchemaVersion": "2018-10-08",
		"Severity": {
			"Original": "HIGH",
			"Label": "HIGH"
		},
		"Title": "ALB Listening on HTTP",
		"Types": [
			"Software and Configuration Checks/Vulnerabilities/KICS"
		],
		"UpdatedAt": "2024-02-14T12:21:17Z",
		"CWE": "22"
	},
	{
		"AwsAccountId": "AWS_ACCOUNT_ID",
		"Compliance": {
			"Status": "FAILED"
		},
		"CreatedAt": "2024-02-14T12:21:17Z",
		"Description": "AWS Application Load Balancer (alb) should not listen on HTTP",
		"GeneratorId": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
		"Id": "AWS_REGION/AWS_ACCOUNT_ID/02e577bf2456c31f64f2855f8345fa051c0fe2159e1f116bd392e02af5f4a4f9",
		"ProductArn": "arn:aws:securityhub:AWS_REGION:AWS_ACCOUNT_ID:product/AWS_ACCOUNT_ID/default",
		"Remediation": {
			"Recommendation": {
				"Text": "Problem found on 'assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml' file in line 29. Expected value: 'aws_elb_application_lb' Protocol should be 'HTTP'. Actual value: 'aws_elb_application_lb' Protocol is missing."
			}
		},
		"Resources": [
			{
				"Id": "f81d63d2-c5d7-43a4-a5b5-66717a41c895",
				"Type": "Other"
			}
		],
		"SchemaVersion": "2018-10-08",
		"Severity": {
			"Original": "HIGH",
			"Label": "HIGH"
		},
		"Title": "ALB Listening on HTTP",
		"Types": [
			"Software and Configuration Checks/Vulnerabilities/KICS"
		],
		"UpdatedAt": "2024-02-14T12:21:17Z",
		"CWE": "22"
	},
]
```

**Overview of key-value pairs:**   
**AwsAccountId**: Specifies the AWS account ID associated with the security finding.   
**Compliance**: Provides information about compliance status related to the security finding.   
**Status**: Indicates the compliance status.   
**CreatedAt**: Specifies the timestamp when the security finding was created, in UTC format.   
**Description**: Describes the security finding in detail.   
**GeneratorId**: Specifies the ID of the generator or tool that produced the security finding.   
**Id**: Uniquely identifies the security finding. It typically includes the AWS region, AWS account ID, and a unique identifier for the finding.   
**ProductArn**: Represents the Amazon Resource Name (ARN) of the product associated with the security finding.   
**Remediation**: Provides remediation information for addressing the security finding.   
**Recommendation**: Contains recommendations for remediation, including specific actions to take.   
**Resources**: Describes the affected AWS resources related to the security finding.   
**Id**: Specifies the ID of the affected resource.   
**Type**: Indicates the type of the affected resource.   
**SchemaVersion**: Specifies the version of the ASFF schema used in the report.   
**Severity**: Provides information about the severity of the security finding.   
**Original**: Specifies the original severity level of the finding.   
**Label**: Provides a labeled severity level.   
**Title**: Provides a title or summary of the security finding.   
**Types**: Specifies the types of vulnerabilities or security checks associated with the finding.   
**UpdatedAt**: Specifies the timestamp when the security finding was last updated, in UTC format.   
**CWE**: Specifies the Common Weakness Enumeration (CWE) ID associated with the finding, which helps categorize the type of vulnerability.   

## CSV

You can export CSV report by using `--report-formats "csv"`.

CSV reports follow the [CSV structure](https://www.loc.gov/preservation/digital/formats/fdd/fdd000323.shtml#:~:text=CSV%20is%20a%20simple%20format,characters%20indicating%20a%20line%20break.).

| query_name           | query_id                            | query_uri                                                                                             | severity | platform | cwe | cloud_provider | category              | description_id | description                                                      | cis_description_id | cis_description_title | cis_description_text | file_name                                                                                             | similarity_id                                          | line | issue_type      | search_key                                                                                    | search_line | search_value | expected_value                                                                    | actual_value                                                                    |
|----------------------|-------------------------------------|-------------------------------------------------------------------------------------------------------|----------|----------|-----|-----------------|-----------------------|-----------------|------------------------------------------------------------------|---------------------|-----------------------|----------------------|-------------------------------------------------------------------------------------------------------|----------------------------------------------------------|------|-----------------|----------------------------------------------------------------------------------------------|-------------|--------------|-----------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| ALB Listening on HTTP | f81d63d2-c5d7-43a4-a5b5-66717a41c895 | https://docs.ansible.com/ansible/latest/collections/community/aws/elb_application_lb_module.html | HIGH     | Ansible  | 22  | AWS             | Networking and Firewall | 3a7576e5       | AWS Application Load Balancer (alb) should not listen on HTTP |                     |                       |                      | assets\queries\ansible\aws\alb_listening_on_http\test\positive.yaml                                  | a00c90f900058bb60c8eeeaf5236416079e5085fe0465b69aa51b5aa5b7442fe | 11   | IncorrectValue | name={{my_elb_application}}.{{community.aws.elb_application_lb}}.listeners.Protocol=HTTP | -1          |              | 'aws_elb_application_lb' Protocol should be 'HTTP'                                | 'aws_elb_application_lb' Protocol it's not 'HTTP'                                 |
| ALB Listening on HTTP | f81d63d2-c5d7-43a4-a5b5-66717a41c895 | https://docs.ansible.com/ansible/latest/collections/community/aws/elb_application_lb_module.html | HIGH     | Ansible  | 22  | AWS             | Networking and Firewall | 3a7576e5       | AWS Application Load Balancer (alb) should not listen on HTTP |                     |                       |                      | assets\queries\ansible\aws\alb_listening_on_http\test\positive.yaml                                  | 02e577bf2456c31f64f2855f8345fa051c0fe2159e1f116bd392e02af5f4a4f9 | 29   | MissingAttribute | name={{my_elb_application2}}.{{community.aws.elb_application_lb}}.listeners         | -1          |              | 'aws_elb_application_lb' Protocol should be 'HTTP'                                | 'aws_elb_application_lb' Protocol is missing                                   |


**Brief Explanation of CSV Columns:**   
**query_name**: Specifies the name of the query.   
**query_id**: Unique identifier for the query.   
**query_uri**: URI link to documentation or reference material related to the query.   
**severity**: Indicates the severity level of the vulnerability.   
**platform**: Specifies the platform or technology stack targeted by the query.   
**cwe**: Common Weakness Enumeration (CWE) ID associated with the vulnerability.   
**cloud_provider**: Specifies the cloud provider related to the vulnerability.   
**category**: Describes the category or type of vulnerability.   
**description_id**: Unique identifier for the vulnerability description.   
**description**: Detailed description of the vulnerability.   
**cis_description_id**: Unique identifier for the CIS (Center for Internet Security) description.   
**cis_description_title**: Title of the CIS description.   
**cis_description_text**: Text of the CIS description.   
**file_name**: Specifies the file name or path where the vulnerability was detected.   
**similarity_id**: Unique identifier for similarity comparison.   
**line**: Line number in the file where the vulnerability was detected.   
**issue_type**: Type of issue or vulnerability detected.   
**search_key**: Key used to search for the vulnerability.   
**search_line**: Line number where the search was conducted.   
**search_value**: Value searched for in the file.   
**expected_value**: Expected value for the vulnerability.   
**actual_value**: Actual value found in the file.

## Code Climate

You can export code climate report by using `--report-formats "codeclimate"`. The generated report file will have a prefix `codeclimate-`.

Code climate report follow the [Code Climate Spec](https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md).

```json
[
	{
		"type": "issue",
		"check_name": "ALB Listening on HTTP",
		"cwe": "22",
		"description": "AWS Application Load Balancer (alb) should not listen on HTTP",
		"categories": [
			"Security"
		],
		"location": {
			"path": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
			"lines": {
				"begin": 11
			}
		},
		"severity": "critical",
		"fingerprint": "a00c90f900058bb60c8eeeaf5236416079e5085fe0465b69aa51b5aa5b7442fe"
	},
	{
		"type": "issue",
		"check_name": "ALB Listening on HTTP",
		"cwe": "22",
		"description": "AWS Application Load Balancer (alb) should not listen on HTTP",
		"categories": [
			"Security"
		],
		"location": {
			"path": "assets\\queries\\ansible\\aws\\alb_listening_on_http\\test\\positive.yaml",
			"lines": {
				"begin": 29
			}
		},
		"severity": "critical",
		"fingerprint": "02e577bf2456c31f64f2855f8345fa051c0fe2159e1f116bd392e02af5f4a4f9"
	}
]
```

**Overview of key-value pairs:**   
**type**: Specifies the type of issue reported.   
**check_name**: Describes the name or identifier of the check performed.   
**cwe**: Common Weakness Enumeration (CWE) ID associated with the issue.   
**description**: Provides a detailed description of the issue detected.   
**categories**: Indicates the categories or classifications of the issue.   
**location**: Gives information about the path and lines where the issue occurred.   
**path**: Specifies the file path where the issue was detected.   
**lines**: Provides information about the lines affected by the issue, including the beginning line number.   
**severity**: Indicates the severity level of the issue.   
**fingerprint**: Unique identifier or fingerprint for the issue, used for tracking and reference purposes.   

## CLI Report

KICS displays the results in CLI. For detailed information, you can use `-v --log-level DEBUG`.

![image](https://user-images.githubusercontent.com/74001161/161743565-f98cb076-e708-4754-8f9a-f1dbed82837b.png)

# Exit Status Code

## Results Status Code

| Code | Description                 |
| ---- | ----------------------------|
| `0`  | No Results were Found       |
| `60` | Found any `CRITICAL` Results|
| `50` | Found any `HIGH` Results    |
| `40` | Found any `MEDIUM` Results  |
| `30` | Found any `LOW` Results     |
| `20` | Found any `INFO` Results    |

## Error Status Code

| Code  | Description      |
| ----- | ---------------- |
| `70`  | Remediation Error|
| `126` | Engine Error     |
| `130` | Signal-Interrupt |
