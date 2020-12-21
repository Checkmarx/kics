package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  contains(resource.Value[j], "yum update")
  
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey":        sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} doesn't enables yum update", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} does enables yum update", [name, resource.Original]),
              }
}