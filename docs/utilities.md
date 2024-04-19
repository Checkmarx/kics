# Utilities


## Lines scanned and lines parsed

KICS presents the number of lines scanned and the number of lines parsed. Both are presented in LOG messages and the JSON report. Note that the number of the lines includes empty ones.

Lines scanned are the lines of the files that were scanned, in the first instance, before the "parser step". The lines parsed are the lines of the files that KICS parsed.


##### Example in which KICS scans and parses the file

![image](https://user-images.githubusercontent.com/74001161/161734278-b834bdb3-2696-4331-b045-bf3ec6e7fedf.png)


##### Example in which KICS scans and not parses the file

![image](https://user-images.githubusercontent.com/74001161/161734076-f6cfcf33-6096-4712-80b5-02d367ae73e0.png)



## Resource type and resource name

KICS presents the resource type and the resource name fields in the JSON result of each query. These fields are available for the following platforms: Ansible, Azure Resource Manager, CloudFormation, CrossPlane, Knative, Kubernetes, Google Deployment Manager, Pulumi, ServerlessFW and Terraform.

```
{
	"file_name": "assets/queries/azureResourceManager/account_admins_not_notified_by_email/test/positive3.json",
	"similarity_id": "4db29b15c254f0d6b2226a9bea87e1db9098ba24ceab992646536cd33061d03f",
	"line": 16,
	"resource_type": "Microsoft.Sql/servers/databases/securityAlertPolicies",
	"resource_name": "sample/server/default",
	"issue_type": "IncorrectValue",
	"search_key": "properties.template.resources.name={{sample/server/default}}.properties.emailAccountAdmins",
	"search_line": 0,
	"search_value": "",
	"expected_value": "securityAlertPolicies.properties.emailAccountAdmins is set to true",
}
```
