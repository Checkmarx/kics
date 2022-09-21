package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#default of versioning is false
CxPolicy[result] {

    bucket := input.document[i].resource.aws_s3_bucket[bucketName]
    not common_lib.valid_key(bucket, "versioning")  # version before TF AWS 4.0
    not tf_lib.has_target_resource(bucketName, "aws_s3_bucket_versioning")  # version after TF AWS 4.0
	
    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", bucketName),
        "searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'versioning' should be true",
        "keyActualValue": "'versioning' is undefined or null",
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
    }
}

CxPolicy[result] {

    module := input.document[i].module[name]
    keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")
    not common_lib.valid_key(module, keyToCheck)

    result := {
        "documentId": input.document[i].id,
        "resourceType": "n/a",
		"resourceName": "n/a",
        "searchKey": sprintf("module[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'versioning' should be true",
        "keyActualValue": "'versioning' is undefined or null",
        "searchLine": common_lib.build_search_line(["module", name], []),
        "remediation": sprintf("%s {\n\t\t enabled = true\n\t}",[keyToCheck]),
		"remediationType": "addition",
    }
}

#default of enabled is false
# version before TF AWS 4.0
CxPolicy[result] {

    bucket := input.document[i].resource.aws_s3_bucket[name]
    not common_lib.valid_key(bucket.versioning, "enabled")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", name),
        "searchKey": sprintf("aws_s3_bucket[%s].versioning", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'versioning.enabled' should be true",
        "keyActualValue": "'versioning.enabled' is undefined or null",
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning"], []),
        "remediation": "enabled = true",
		"remediationType": "addition",
    }
}

CxPolicy[result] {

    module := input.document[i].module[name]
    keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")
    not common_lib.valid_key(module[keyToCheck], "enabled")

    result := {
        "documentId": input.document[i].id,
        "resourceType": "n/a",
		"resourceName": "n/a",
        "searchKey": sprintf("module[%s].versioning", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": "'versioning.enabled' should be true",
        "keyActualValue": "'versioning.enabled' is undefined or null",
        "searchLine": common_lib.build_search_line(["module", name, "versioning"], []),
        "remediation": "enabled = true",
		"remediationType": "addition",
    }
}

# version before TF AWS 4.0
CxPolicy[result] {

    bucket := input.document[i].resource.aws_s3_bucket[name]
    bucket.versioning.enabled != true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", name),
        "searchKey": sprintf("aws_s3_bucket[%s].versioning.enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'versioning.enabled' should be true",
        "keyActualValue": "'versioning.enabled' is set to false",
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "versioning", "enabled"], []),
        "remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
    }
}

CxPolicy[result] {

    module := input.document[i].module[name]
    keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "versioning")
    module[keyToCheck].enabled != true

    result := {
        "documentId": input.document[i].id,
        "resourceType": "n/a",
		"resourceName": "n/a",
        "searchKey": sprintf("module[%s].versioning.enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'versioning.enabled' should be true",
        "keyActualValue": "'versioning.enabled' is set to false",
        "searchLine": common_lib.build_search_line(["module", name, "versioning", "enabled"], []),
        "remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
    }
}

# version after TF AWS 4.0
CxPolicy[result] {

    input.document[_].resource.aws_s3_bucket[bucketName]
    bucket_versioning := input.document[i].resource.aws_s3_bucket_versioning[name]
    split(bucket_versioning.bucket, ".")[1] == bucketName
    bucket_versioning.versioning_configuration.status == "Suspended"

    result := {
        "documentId": input.document[i].id,
       "resourceType": "aws_s3_bucket_versioning",
		"resourceName": tf_lib.get_resource_name(bucket_versioning, name),
        "searchKey": sprintf("aws_s3_bucket_versioning[%s].versioning_configuration.status", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": "'versioning_configuration.status' should be set to 'Enabled'",
        "keyActualValue": "'versioning_configuration.status' is set to 'Suspended'",
        "searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_versioning", name, "versioning_configuration", "status"], []),
        "remediation": json.marshal({
			"before": "Suspended",
			"after": "Enabled"
		}),
		"remediationType": "replacement",
    }
}
