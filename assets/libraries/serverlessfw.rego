package generic.serverlessfw

import data.generic.common as common_lib

get_provider_name(doc)=name{
	provider := doc.provider
	name := provider.name
} else = name {
	name = "AWS"
}


resourceTypeMapping(resourceType, provider)= resourceTypeVal{
    resourceTypeVal :=resourcesMap[provider][resourceType]
}

resourcesMap = {
    "aws": {
        "function": "AWS::Lambda",
        "api": "AWS::ApiGateway",
        "iam": "AWS::IAM"        
    },
    "azure":{
        "function": "Azure:Function",
        "api": "Azure:APIManagement",
        "iam": "Azure:Role"
    },
    "google":{
        "function": "Google:Cloudfunctions",
        "api": "Google:ApiGateway",
        "iam": "Google:IAM"
    },
    "aliyun":{
        "function": "Aliyun:FunctionCompute",
        "api": "Aliyun:ApiGateway",
        "iam": "Aliyun:RAM"
    }
}

get_service_name(document) = name{
    name := document.service.name
} else = name {
    is_string(document.service)
    name := document.service
}


get_resource_accessibility(nameRef, type, key) = info {
	document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	policyDoc := policy.Properties.PolicyDocument
	common_lib.any_principal(policyDoc)
	common_lib.is_allow_effect(policyDoc)

	info := {"accessibility": "public", "policy": policyDoc}
} else = info {
    document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	policyDoc := policy.Properties.PolicyDocument
	common_lib.any_principal(policyDoc)
	common_lib.is_allow_effect(policyDoc)

	info := {"accessibility": "public", "policy": policyDoc}
} else = info {
    document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
    document := input.document
	policy := document[_].resources.Resources[_]
	policy.Type == type

	keys := policy.Properties[key]

	get_name(keys[_]) == nameRef

	info := {"accessibility": "hasPolicy", "policy": policy.Properties.PolicyDocument}
} else = info {
	info := {"accessibility": "unknown", "policy": ""}
}

get_name(targetName) = name {
	common_lib.valid_key(targetName, "Ref")
	name := targetName.Ref
} else = name {
	not common_lib.valid_key(targetName, "Ref")
	name := targetName
}

get_encryption(resource) = encryption {
	resource.encrypted == true
    encryption := "encrypted"
} else = encryption {
    fields := {"kmsMasterKeyId", "encryptionInfo", "encryptionOptions", "bucketEncryption"}
    common_lib.valid_key(resource, fields[_])
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}
