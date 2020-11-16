package Cx

CxPolicy [ result ] {
  ctMultiRegion := input.document[i].resource.aws_cloudtrail[name].is_multi_region_trail
  enabled := ctMultiRegion.is_multi_region_trail

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s].name", [name]),
                "issueType":		"Cloud Trail Multi Region disabled",
                "keyExpectedValue": "Cloud Trail Multi Region needs to be enabled",
                "keyActualValue": 	"Cloud Trail Multi Region is disabled",
                "enabled" : enabled
              }
}

CxPolicy [ result ] {
  ctMultiRegion := input.document[i].resource.aws_cloudtrail[name]
  enabled := false

  not ctMultiRegion.is_multi_region_trail

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s].name", [name]),
                "issueType":		"Cloud Trail Multi Region disabled",
                "keyExpectedValue": "Cloud Trail Multi Region needs to be enabled",
                "keyActualValue": 	"Cloud Trail Multi Region is disabled",
                "enabled" : enabled
              }
}