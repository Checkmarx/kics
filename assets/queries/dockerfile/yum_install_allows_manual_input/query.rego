package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  cmd := ["yum install","yum groupinstall", "yum localinstall"]
  flag := ["-y", "--assumeyes"]
  
  some x
  contains(resource.Value[j], cmd[x])
  not contains(resource.Value[j], flag[x])

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey":        sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} avoids manual input", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} doesn't avoid manual input", [name, resource.Original]),
              }
}