package Cx

CxPolicy [ result ] {
  route := input.document[i].resource.aws_route53_record[name]
  isRecordsEmpty(route.records)
  
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("aws_route53_record[%s].records", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "aws_route53_record.records is defined",
                "keyActualValue":   "aws_route53_record.records is undefined"
              }
}

isRecordsEmpty(r) {
	r == null
}
isRecordsEmpty(r) {
	r != null
    count(r) <= 0
}