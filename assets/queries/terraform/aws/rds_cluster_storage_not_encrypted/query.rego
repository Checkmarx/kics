package Cx

CxPolicy [ result ] {
  cluster := input.document[i].resource.aws_rds_cluster[name]
  cluster.kms_key_id == false

 

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("aws_rds_cluster[%s].kms_key_id", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "aws_rds_cluster.kms_key_id is true",
                "keyActualValue":   "aws_rds_cluster.kms_key_id is false"
              }
}

CxPolicy [ result ] {
  cluster := input.document[i].resource.aws_rds_cluster[name]
  object.get(cluster, "kms_key_id", "undefined") == "undefined"
  engineModeProvisioned(cluster.engine_mode)

 

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("aws_rds_cluster[%s]", [name]),
                "issueType":        "IncorrectValue",
                "keyExpectedValue": "aws_rds_cluster.kms_key_id is undefined and aws_rds_cluster.engine_mode not null or ''",
                "keyActualValue":   "aws_rds_cluster.kms_key_id is undefined and aws_rds_cluster.engine_mode is null or ''"
              }
}

 
engineModeProvisioned(p) {
    p == null
}
engineModeProvisioned(p) {
    p == ""
}