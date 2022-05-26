package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# return every bucket as result if there are no policies defined
CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources
	some resource
	resources[resource].Type == "AWS::S3::Bucket"

	bucket := resources[resource].Properties

	not common_lib.valid_key(bucket,"BucketEncryption")

	result := {
		"documentId": document.id,
		"resourceType": resources[resource].Type,
		"resourceName": cf_lib.get_resource_name(resources[resource], resource),
		"searchKey": sprintf("Resources.%s.Properties", [resource]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BucketEncryption is set", [resource]),
		"keyActualValue": sprintf("Resources.%s.Properties.BucketEncryption is undefined", [resource]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources
	some resource
	resources[resource].Type == "AWS::S3::Bucket"

	bucket := resources[resource].Properties

    serverEncryption := bucket.BucketEncryption.ServerSideEncryptionConfiguration
	not hasServerEncryptionRules(serverEncryption)

	result := {
		"documentId": document.id,
		"resourceType": resources[resource].Type,
		"resourceName": cf_lib.get_resource_name(resources[resource], resource),
		"searchKey": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration", [resource]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration has at least one ServerSideEncryptionByDefault rule", [resource]),
		"keyActualValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration does not have a ServerSideEncryptionByDefault rule", [resource]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources
	some resource
	resources[resource].Type == "AWS::S3::Bucket"

	bucket := resources[resource].Properties

    serverEncryption := bucket.BucketEncryption.ServerSideEncryptionConfiguration
	hasServerEncryptionRules(serverEncryption)

    some j
    serverRule := serverEncryption[j].ServerSideEncryptionByDefault

    checkMasterKey(serverRule)
    not serverRule.SSEAlgorithm == "AES256"

	result := {
		"documentId": document.id,
		"resourceType": resources[resource].Type,
		"resourceName": cf_lib.get_resource_name(resources[resource], resource),
		"searchKey": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration.ServerSideEncryptionByDefault.SSEAlgorithm", [resource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration.ServerSideEncryptionByDefault.SSEAlgorithm is 'AES256'", [resource]),
		"keyActualValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration.ServerSideEncryptionByDefault.SSEAlgorithm is '%s'", [resource,serverRule.SSEAlgorithm]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resources := document.Resources
	some resource
	resources[resource].Type == "AWS::S3::Bucket"

	bucket := resources[resource].Properties

    serverEncryption := bucket.BucketEncryption.ServerSideEncryptionConfiguration
	hasServerEncryptionRules(serverEncryption)

    some j
    serverRule := serverEncryption[j].ServerSideEncryptionByDefault

    not checkMasterKey(serverRule)
    serverRule.SSEAlgorithm == "AES256"

	result := {
		"documentId": document.id,
		"resourceType": resources[resource].Type,
		"resourceName": cf_lib.get_resource_name(resources[resource], resource),
		"searchKey": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration.ServerSideEncryptionByDefault.KMSMasterKeyID", [resource]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration.ServerSideEncryptionByDefault.KMSMasterKeyID is undefined", [resource]),
		"keyActualValue": sprintf("Resources.%s.Properties.BucketEncryption.ServerSideEncryptionConfiguration.ServerSideEncryptionByDefault.KMSMasterKeyID is set", [resource]),
	}
}

hasServerEncryptionRules(list) {
    some i
    common_lib.valid_key(list[i],"ServerSideEncryptionByDefault")
}

checkMasterKey(assed) {
	not common_lib.valid_key(assed, "KMSMasterKeyID")
}

checkMasterKey(assed) {
	assed.KMSMasterKeyID == ""
}

checkMasterKey(assed) {
	assed.KMSMasterKeyID == null
}
