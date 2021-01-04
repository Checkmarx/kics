package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::DynamoDB::Table"
  properties := resource.Properties
  billingMode := properties.BillingMode
  not containsBilling(["PROVISIONED", "PAY_PER_REQUEST"], billingMode) 


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.BillingMode",[name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.BillingMode is not 'PROVISIONED' or 'PAY_PER_REQUEST'",[name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.BillingMode is 'PROVISIONED' or 'PAY_PER_REQUEST'",[name])
              }
}

containsBilling(array, elem) = true {
  lower(array[_]) == lower(elem)
} else = false { true }
