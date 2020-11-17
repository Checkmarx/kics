package Cx

CxPolicy [ result ] {
  ctMultiRegion := input.document[i].resource.aws_cloudtrail[name]
  not ctMultiRegion.is_multi_region_trail
  not ctMultiRegion.is_multi_region_trail == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "Cloud Trail Multi Region needs to be enabled",
                "keyActualValue": 	"Cloud Trail Multi Region is disabled",
              }
}

CxPolicy [ result ] {
  ctMultiRegion := input.document[i].resource.aws_cloudtrail[name]
  ctMultiRegion.is_multi_region_trail == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s].is_multi_region_trail", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "Cloud Trail Multi Region is true",
                "keyActualValue": 	"Cloud Trail Multi Region is false",
              }
} 