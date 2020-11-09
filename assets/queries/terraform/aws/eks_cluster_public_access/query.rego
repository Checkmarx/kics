package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_eks_cluster[name]
    resource.vpc_config.endpoint_public_access = true

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_eks_cluster[%s].vpc_config.endpoint_public_access", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'vpc_config.endpoint_public_access' is equal 'false'",
                "keyActualValue": 	"'vpc_config.endpoint_public_access' is equal 'true'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
