package Cx

CxPolicy [ result ] {
  org_policy := input.document[i].resource.aws_organizations_policy[name]

  org_policy.type == "SERVICE_CONTROL_POLICY"
  
  result := check_all_features(org_policy,name)

}

CxPolicy [ result ] {
  org_policy := input.document[i].resource.aws_organizations_policy[name]

  not org_policy.type # default is SERVICE_CONTROL_POLICY
  
  result := check_all_features(org_policy,name)

}

check_all_features(resource,id) = result {

  content := json.unmarshal(resource.content)

  is_statement_array := is_array(content.Statement)

  statements := content.Statement
  
  some j
    	statement := statements[j]
  		not policy_check(statement,"*","Allow","*")

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_organizations_policy[%s].content", [id]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "Statements allow all policy actions in all resources",
                "keyActualValue": 	"Some or all statements don't allow all policy actions in all resources"
              }
}

check_all_features(resource,id) = result {

  content := json.unmarshal(resource.content)

  is_statement_string := is_object(content.Statement)

  not policy_check(content.Statement,"*","Allow","*")

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_organizations_policy[%s].content", [id]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "Statements allow all policy actions in all resources",
                "keyActualValue": 	"Some or all statements don't allow all policy actions in all resources"
              }
}

policy_check(statement,action,effect,resource) = true {
  statement.Effect == effect
  is_action_array := is_array(statement.Action)
  statement.Action[_] == action
  is_resource_array := is_array(statement.Resource)
  statement.Resource[_] == resource
}

policy_check(statement,action,effect,resource) = true {
  statement.Effect == effect
  is_action_array := is_array(statement.Action)
  statement.Action[_] == action
  is_resource_string := is_string(statement.Resource)
  statement.Resource == resource
}

policy_check(statement,action,effect,resource) = true {
  statement.Effect == effect
  is_action_string := is_string(statement.Action)
  statement.Action == action
  is_resource_array := is_array(statement.Resource)
  statement.Resource[_] == resource
}

policy_check(statement,action,effect,resource) = true {
  statement.Effect == effect
  is_action_string := is_string(statement.Action)
  statement.Action == action
  is_resource_string := is_string(statement.Resource)
  statement.Resource == resource
}