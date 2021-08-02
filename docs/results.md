# Results
KICS can export results in multiple formats which can be seen on the following list:
- JSON (json)
- SARIF (sarif)
- Gitlab SAST (glsast)
- HTML (html)
- PDF (pdf)

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

# Gitlab SAST
You can export html report by using `--report-formats "glsast"`.
Gitlab SAST reports are sorted by severity (from high to info), following [Gitlab SAST Report scheme](https://docs.gitlab.com/ee/development/integrations/secure.html#report), also, the generated file will have a prefix `gl-sast-` as [recommendend by Gitlab docs](https://docs.gitlab.com/ee/development/integrations/secure.html#output-file) and looks like:

```json
{
	"schema": "https://gitlab.com/gitlab-org/security-products/security-report-schemas/-/raw/v13.1.0/dist/sast-report-format.json",
	"version": "13.1.0",
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

| Code          | Description                               |
| --------------| ------------------------------------------|
| `0`           | No Results were Found                     |
| `50`          | Found any `HIGH` Results                  |
| `40`          | Found any `MEDIUM` Results                |
| `30`          | Found any `LOW` Results                   |
| `20`          | Found any `INFO` Results                  |

## Error Status Code

| Code      | Description                                   |
| --------------| ------------------------------------------|
| `126`         | Engine Error                              |
| `130`         | Signal-Interrupt                          |
