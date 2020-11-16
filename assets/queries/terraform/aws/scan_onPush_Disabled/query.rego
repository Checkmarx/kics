package Cx

CxPolicy [ result ] {
  imageScan := input.document[i].resource.aws_ecr_repository[name].image_scanning_configuration
  not imageScan.scan_on_push

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s].name", [name]),
                "issueType":		"IncorrectValued",
                "keyExpectedValue": "Image Scanned",
                "keyActualValue": 	"Image not scanned",
                "enabled" : imageScan.scan_on_push
              }
}

CxPolicy [ result ] {
  imageScan := input.document[i].resource.aws_ecr_repository[name]
  not imageScan.image_scanning_configuration
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail[%s].name", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "image_scanning_configuration is available",
                "keyActualValue": 	"image_scanning_configuration is missing",
              }
}