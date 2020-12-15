package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudTrail::Trail"
  not object.get(resource.Properties, "IsMultiRegionTrail", "undefined") == "undefined"
  not checkRegion(resource)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.IsMultiRegionTrail", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is true", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is false", [name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudTrail::Trail"
  object.get(resource.Properties, "IsMultiRegionTrail", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.IsMultiRegionTrail' exists", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.IsMultiRegionTrail' is missing", [name])
              }
}

checkRegion(cltr) {
	cltr.Properties.IsMultiRegionTrail == true
}