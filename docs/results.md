## Results

KICS results are output in clear and simple JSON format. Example:
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
					"file_name": "assets/queries/terraform/kubernetes_pod/container_allow_privilege_escalation_is_true/test/positive.tf",
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
