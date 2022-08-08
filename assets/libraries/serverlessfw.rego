package generic.serverlessfw

import data.generic.common as common_lib

is_serverless_file(resource){
    common_lib.valid_key(resource, "service")
    common_lib.valid_key(resource, "provider")
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
        "function": "Azure:FunctionApp",
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
