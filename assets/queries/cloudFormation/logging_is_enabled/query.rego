package Cx

CxPolicy [ result ] {
    resource := input.document[i].Resources[name]
    resource.Type == "AWS::CloudFront::Distribution"
    
    loggingEnabled := resource.Properties.DistributionConfig.Logging.Enabled
    loggingEnabled == false
    
    bucketCorrect := resource.Properties.DistributionConfig.Logging.Bucket
    endswith(bucketCorrect,".s3.amazonaws.com")
    
    result := {
        "documentId":         input.document[i].id,
        "searchKey":         sprintf("Resources.%s.Properties.DistributionConfig.Logging.Enabled", [name]),
        "issueType":        "IncorrectValue",  
        "keyExpectedValue": sprintf("Resources.%s.Properties.DistributionConfig.Logging should be enabled",[name]),
        "keyActualValue":   sprintf("Resources.%s.Properties.DistributionConfig.Logging is disabled",[name])
    }
}