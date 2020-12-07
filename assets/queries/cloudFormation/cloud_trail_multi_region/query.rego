package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudTrail::Trail"
  not checkRegion(resource)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is true", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is false", [name])
              }
}

checkRegion(cltr) {
	cltr.Properties.IsMultiRegionTrail == true
}