package Cx

CxPolicy [ result ] {
  resource := input.document[i]
  resource.Type == "AWS::SageMaker::NotebookInstance"
  properties := resource.Properties
  object.get(properties, "KmsKeyId", "undefined") == "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "Properties.KmsKeyId",
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": "Properties.KmsKeyId' is defined",
                "keyActualValue": 	"Properties.KmsKeyId' is undefined"
              }
}