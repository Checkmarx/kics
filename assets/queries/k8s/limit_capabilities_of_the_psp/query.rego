package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec
   requiredDropCapabilities := object.get(spec, "requiredDropCapabilities", "undefined") != "undefined"
   not requiredDropCapabilities 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "spec",
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": "spec.requiredDropCapabilities is defined",
                "keyActualValue": 	"spec.requiredDropCapabilities is undefined"
              }
}