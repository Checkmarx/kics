package Cx

CxPolicy [ result ] {
  ctMultiRegion := input.document[i].resource.aws_cloudtrail[name]
  not ctMultiRegion.is_multi_region_trail
  not ctMultiRegion.is_multi_region_trail == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s]", [name]),
                "issueType":		"Cloud Trail Multi Region defaults to false",
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
                "issueType":		"Cloud Trail Multi Region disabled",
                "keyExpectedValue": "Cloud Trail Multi Region needs to be enabled",
                "keyActualValue": 	"Cloud Trail Multi Region is disabled",
              }
} 