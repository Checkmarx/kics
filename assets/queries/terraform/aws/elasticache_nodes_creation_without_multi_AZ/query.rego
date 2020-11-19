package Cx

CxPolicy [ result ] {
  cluster := input.document[i].resource.aws_elasticache_cluster[name]
  cluster.engine == "memcached"
  to_number(cluster.num_cache_nodes) > 1

  result := not_multi_az(cluster,name)
}

not_multi_az(cluster,name) = result {

  not cluster.az_mode

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticache_cluster[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'az_mode' is set and must be 'cross-az' in multi nodes cluster",
                "keyActualValue": 	"'az_mode' is undefined"
              }

}

not_multi_az(cluster,name) = result {

  cluster.az_mode != "cross-az"

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_elasticache_cluster[%s].az_mode", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'az_mode' is 'cross-az' in multi nodes cluster",
                "keyActualValue": 	sprintf("'az_mode' is '%s'",[cluster.az_mode])
              }

}