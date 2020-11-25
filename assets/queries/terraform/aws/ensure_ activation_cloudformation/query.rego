package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  stack := resource.aws_cloudformation_stack_set_instance.example[name]
  object.get(stack, "retain_stack", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudformation_stack_set_instance[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is defined ", [name]),
                "keyActualValue": 	sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is undefined", [name])
              }
}


CxPolicy [ result ] {
  resource := input.document[i].resource
  stack := resource.aws_cloudformation_stack_set_instance.example[name]
  stack.retain_stack == false
  
	  result := {
				  "documentId":       input.document[i].id,
				  "searchKey": 	      sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack", [name]),
				  "issueType":		  "IncorrectValue",
				  "keyExpectedValue": sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is true ", [name]),
				  "keyActualValue":   sprintf("aws_cloudformation_stack_set_instance[%s].retain_stack is false", [name])
				}
  }