package Cx

CxPolicy [ result ] {
  spec := input.document[i].spec
  kind := input.document[i].kind
  kind == "CronJob"
  object.get(spec, "startingDeadlineSeconds", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "spec",
                "issueType":		"MissingAttribute",
                "keyExpectedValue":  "spec.startingDeadlineSeconds is defined",
                "keyActualValue": 	 "spec.startingDeadlineSeconds is not defined"
              }
}