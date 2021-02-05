## Results

KICS results are output in clear and simple JSON format. Example:
```json
{
	"files_scanned": 4,
	"files_failed_to_scan": 1,
	"queries_total": 227,
	"queries_failed_to_execute": 0,
	"queries": [
		{
			"query_name": "Container Allow Privilege Escalation Is True",
			"query_id": "c878abb4-cca5-4724-92b9-289be68bd47c",
			"severity": "MEDIUM",
			"files": [
				{
					"file_name": "assets/queries/terraform/kubernetes_pod/container_allow_privilege_escalation_is_true/test/positive.tf",
					"line": 11,
					"issue_type": "IncorrectValue",
					"search_key": "kubernetes_pod[test3].spec.container.allow_privilege_escalation",
					"expected_value": "Attribute 'allow_privilege_escalation' is undefined or false",
					"actual_value": "Attribute 'allow_privilege_escalation' is true",
					"value": null
				}
			]
		}
	]
}
```
