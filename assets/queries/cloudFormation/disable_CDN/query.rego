package Cx

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudFront::Distribution"
  properties := input.document[i].Resources[name].Properties[j]
  distributionConfig := properties.Enabled
  expectedvalue := "false"
  distributionConfig == expectedvalue
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.DistributionConfig", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled should be true", [name,name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.DistributionConfig.Enabled is configured as false", [name])
            }
}
CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudFront::Distribution"
  properties := input.document[i].Resources[name].Properties[j]
  object.get(properties, "Origins", "undefined") == "undefined"
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.DistributionConfig", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled should contain an Origin object", [name,name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.DistributionConfig does not contain Origins object configured", [name])
            }
}