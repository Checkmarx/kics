package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudfront_distribution[name]
  resource.viewer_certificate.cloudfront_default_certificate == false
  not checkMinPortocolVersion(resource.viewer_certificate.minimum_protocol_version)
	
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue":   sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version is TLSv1.1 or TLSv1.2", [name]),
                "keyActualValue": 	  sprintf("resource.aws_cloudfront_distribution[%s].viewer_certificate.minimum_protocol_version isn't TLSv1.1 or TLSv1.2", [name])
              }
}

checkMinPortocolVersion(version)
{
	version == "TLSv1.1"
}

checkMinPortocolVersion(version)
{
	version == "TLSv1.2"
}