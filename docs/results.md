# Results
KICS can export results in multiple formats which can be seen on the following list:
- JSON
- SARIF
- HTML

To export in one of this formats, the flag output-path can be used with the file path and extension, for example:

```bash
./kics scan -p <path-of-your-project-to-scan> -o ./results.json
```

This comand will generate a JSON report on the current directory

KICS also can export multiple format in a single scan, to do this the flags output-path and report-formats should be combined,
where the output-path will be the directory containing all report files and report-formats all extensions wanted, like following example:

```bash
./kics scan -p <path-of-your-project-to-scan> -o ./output --report-formats "json,sarif,html"
```

The last command will execute the scan and save JSON and SARIF reports on output folder.

# Report examples

## JSON

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

## HTML

HTML reports are sorted by severity (from high to info), the results will have query information, a list of files which vulnerability was found and a code snippet where the problem was detected as you can see in following example:

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/html_report.png" width="850">

# Exit Status Code

## Results Status Code

| Code      | Description                                   |
| --------------| ------------------------------------------|
| `0`           | No Results were Found                     |
| `50`          | Found only    `HIGH` Results              |
| `40`          | Found only    `MEDIUM` Results            |
| `30`          | Found only    `LOW` Results               |
| `20`          | Found only    `INFO` Results              |
| `59`          | Found Results with all severities         |
| `57`          | Found `HIGH`, `MEDIUM` and `LOW` Results  |
| `56`          | Found `HIGH`, `MEDIUM` and `INFO` ResultS |
| `55`          | Found `HIGH`, `INFO` and `LOW` Results    |
| `54`          | Found `HIGH`, and `MEDIUM` Results        |
| `53`          | Found `HIGH`, and `LOW` Results           |
| `52`          | Found `HIGH`, and `INFO` Results          |
| `45`          | Found `MEDIUM`, `INFO` and `LOW` Results  |
| `43`          | Found `MEDIUM`, and `LOW` Results         |
| `42`          | Found `MEDIUM`, and `INFO` Results        |
| `32`          | Found `LOW`, and `INFO` Results           |

## Error Status Code

| Code      | Description                                   |
| --------------| ------------------------------------------|
| `126`         | Engine Error                              |
| `130`         | Signal-Interrupt                          |
| `110`         | Failed to detect line                     |
