package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "shell"
  
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		    "IncorrectValue", 
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} doesn't changes the default shell", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} changes the default shell", [name, resource.Original]),
              }
}