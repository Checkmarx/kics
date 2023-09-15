package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	allowed := ["rds-ca-2019", "rds-ca-rsa2048-g1", "rds-ca-rsa4096-g1", "rds-ca-ecc384-g1"]
    not common_lib.inArray(allowed, resource.ca_cert_identifier)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].ca_cert_identifier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_instance.ca_cert_identifier' should be one provided by Amazon RDS.",
		"keyActualValue": sprintf("'aws_db_instance.ca_cert_identifier' is '%s'", [resource.ca_cert_identifier]),
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "ca_cert_identifier"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "ca_cert_identifier")
	allowed := ["rds-ca-2019", "rds-ca-rsa2048-g1", "rds-ca-rsa4096-g1", "rds-ca-ecc384-g1"]
    not common_lib.inArray(allowed, module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].ca_cert_identifier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ca_cert_identifier' should be one provided by Amazon RDS.",
		"keyActualValue": sprintf("'ca_cert_identifier' is '%s'", [module.ca_cert_identifier]),
		"searchLine": common_lib.build_search_line(["module", name, "ca_cert_identifier"], []),
	}
}
