package Cx

CxPolicy [ result ] {
  access_key := input.document[i].resource.aws_iam_access_key[name]
  
  lower(object.get(access_key,"status","Active")) == "active"
  
  access_key.user != "root"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_access_key[%s].user", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue":	sprintf("'aws_iam_access_key[%s].user' is 'root' for an active access key", [name]),
                "keyActualValue": 	sprintf("'aws_iam_access_key[%s].user' is '%s' for an active access key",[name, access_key.user])
              }
}