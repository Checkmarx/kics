package generic.serverlessfw

import data.generic.common as common_lib

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
