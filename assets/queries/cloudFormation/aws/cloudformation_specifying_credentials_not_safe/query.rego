package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Instance"
	metadata := resource.Metadata[mdata]
	mdata == "AWS::CloudFormation::Authentication"
	creds := metadata[accessCreds]
	creds.type == "S3"
	common_lib.valid_key(creds, "accessKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Metadata.%s.%s.accessKeyId", [name, mdata, accessCreds]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Metadata.%s.%s.accessKeyId should not exist", [name, mdata, accessCreds]),
		"keyActualValue": sprintf("Resources.%s.Metadata.%s.%s.accessKeyId exists", [name, mdata, accessCreds]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Instance"
	metadata := resource.Metadata[mdata]
	mdata == "AWS::CloudFormation::Authentication"
	creds := metadata[accessCreds]
	creds.type == "S3"
	common_lib.valid_key(creds, "secretKey")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Metadata.%s.%s.secretKey", [name, mdata, accessCreds]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Metadata.%s.%s.secretKey should not exist", [name, mdata, accessCreds]),
		"keyActualValue": sprintf("Resources.%s.Metadata.%s.%s.secretKey exists", [name, mdata, accessCreds]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::Instance"
	metadata := resource.Metadata[mdata]
	mdata == "AWS::CloudFormation::Authentication"
	creds := metadata[accessCreds]
	creds.type == "basic"
	common_lib.valid_key(creds, "password")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Metadata.%s.%s.password", [name, mdata, accessCreds]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Metadata.%s.%s.password should not exist", [name, mdata, accessCreds]),
		"keyActualValue": sprintf("Resources.%s.Metadata.%s.%s.password exists", [name, mdata, accessCreds]),
	}
}
