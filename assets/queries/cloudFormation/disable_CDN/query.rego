package Cx

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  properties := input.document[i].Resources[name].Properties[j]
  distributionConfig := properties.Enabled
  expectedvalue := "false"
  distributionConfig == expectedvalue
  object.get(properties, "Origins", "undefined") == "undefined"
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.DistributionConfig", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Enabled should be true and Resources.%s.Properties should contain an Origin object", [name,name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.DistributionConfig.Enabled is configured as false and in Resources.%s.Properties there is no Origins object configured", [name])
            }
}