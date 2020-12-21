package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  contains(resource.Value[j], "yum install")
  not contains(resource.Value[j], "-y")

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey":        sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} uses -y to avoid manual input", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} doesn't uses -y to avoid manual input", [name, resource.Original]),
              }
}