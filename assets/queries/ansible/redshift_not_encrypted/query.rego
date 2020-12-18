package Cx

CxPolicy [ result ] {
  document := input.document[i]
  entries = document.temp
  some x
  redshiftCluster := entries[x]["community.aws.redshift"]
  clusterName := entries[x].name

  object.get(redshiftCluster, "encrypted", "undefined") == "undefined"

    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name=%s.community.aws.redshift", [clusterName]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": "community.aws.redshift.encrypted should be set to true",
                "keyActualValue":   "community.aws.redshift.encrypted is undefined"
              }
}

CxPolicy [ result ] {
  document := input.document[i]
  entries = document.temp
  some x
  redshiftCluster := entries[x]["community.aws.redshift"]
  clusterName := entries[x].name
  redshiftCluster.encrypted != true

  result := {
              "documentId":       input.document[i].id,
              "searchKey":        sprintf("name=%s.community.aws.redshift.encrypted", [clusterName]),
              "issueType":        "MissingAttribute",
              "keyExpectedValue": "community.aws.redshift.encrypted should be set to true",
              "keyActualValue":   "community.aws.redshift.encrypted is set to false"
            }
}
