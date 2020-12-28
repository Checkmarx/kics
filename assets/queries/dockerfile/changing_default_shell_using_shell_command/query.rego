package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "shell"
  
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		    "IncorrectValue", 
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} uses the RUN command to change the default shell", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} uses the SHELL command to change the default shell", [name, resource.Original]),
              }
}