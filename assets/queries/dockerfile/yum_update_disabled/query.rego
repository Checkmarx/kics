package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  cmd := ["yum update", "yum update-to", "yum upgrade", "yum upgrade-to"]
  some x
  contains(resource.Value[j], cmd[x])
  
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey":        sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} doesn't enables yum update", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} does enable yum update", [name, resource.Original]),
              }
}