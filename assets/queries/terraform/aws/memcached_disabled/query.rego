package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_elasticache_cluster[name]
  resource.engine == "redis"

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("resource.aws_elasticache_cluster[%s].engine", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("resource.aws_elasticache_cluster[%s].engine enables Memcached", [name]),
                "keyActualValue": 	sprintf("resource.aws_elasticache_cluster[%s].engine doesn't enable Memcached", [name])
              }
}