package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EMR::SecurityConfiguration"

	properties := resource.Properties
	properties.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration.EnableEbsEncryption == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration.EnableEbsEncryption", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration.EnableEbsEncryption should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration.EnableEbsEncryption is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EMR::SecurityConfiguration"

	properties := resource.Properties
	properties.SecurityConfiguration.EncryptionConfiguration.EnableInTransitEncryption == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.EnableInTransitEncryption", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.EnableInTransitEncryption should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.EnableInTransitEncryption is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EMR::SecurityConfiguration"

	properties := resource.Properties
	properties.SecurityConfiguration.EncryptionConfiguration.EnableAtRestEncryption == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.EnableAtRestEncryption", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.EnableAtRestEncryption should be true", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.EnableAtRestEncryption is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EMR::SecurityConfiguration"

	properties := resource.Properties
	encryptionConfiguration := properties.SecurityConfiguration
	not common_lib.valid_key(encryptionConfiguration, "EncryptionConfiguration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityConfiguration", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.SecurityConfiguration.EncryptionConfiguration must be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.SecurityConfiguration.EncryptionConfiguration is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EMR::SecurityConfiguration"

	properties := resource.Properties
	localDiskEncryptionConfiguration := properties.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration
	not common_lib.valid_key(localDiskEncryptionConfiguration, "EncryptionKeyProviderType")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration.EncryptionKeyProviderType must be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.SecurityConfiguration.EncryptionConfiguration.AtRestEncryptionConfiguration.LocalDiskEncryptionConfiguration.EncryptionKeyProviderType is undefined", [key]),
	}
}
