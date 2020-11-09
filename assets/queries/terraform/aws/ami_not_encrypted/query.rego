package Cx

CxPolicy [ result ] {
  ami := input.file[i].resource.aws_ami[name]
  ami.ebs_block_device
  not ami.ebs_block_device.encrypted
  
   result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_ami[%s].ebs_block_device", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' is 'true'",
                "keyActualValue": 	"One of 'rule.ebs_block_device.encrypted' is not 'true'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
  ami := input.file[i].resource.aws_ami[name]
  not ami.ebs_block_device
 
   result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_ami[%s]", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'rule.ebs_block_device.encrypted' is 'true'",
                "keyActualValue": 	"One of 'rule.ebs_block_device' is undefined",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
  
}