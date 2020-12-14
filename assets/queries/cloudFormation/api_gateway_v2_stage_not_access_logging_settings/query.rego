package Cx

CxPolicy [ result ] {
   document := input.document
   resource = document[i].Resources[name]
   resource.Type == "AWS::ApiGatewayV2::Stage"
   
   properties := resource.Properties
   exists_access_log := object.get(properties, "AccessLogSettings", "undefined") != "undefined"
   not exists_access_log
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.AccessLogSettings", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings is defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.AccessLogSettings is not defined", [name])
              }
}