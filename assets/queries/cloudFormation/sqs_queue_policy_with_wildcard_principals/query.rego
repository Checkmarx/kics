package Cx

CxPolicy [ result ] {
	document := input.document[i]

	some queuePolicyName
	document.Resources[queuePolicyName].Type == "AWS::SQS::QueuePolicy"
	queuePolicy := document.Resources[queuePolicyName]

  some stmt
  resultData := isUnsafeStatement(queuePolicy.Properties.PolicyDocument.Statement[stmt])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PolicyDocument.Statement.%s", [queuePolicyName, resultData[1]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement[*].Principal should not have wildcards when Effect=Allow and Action contains one of [SQS:AddPermission, SQS:CreateQueue, SQS:DeleteQueue, SQS:RemovePermission, SQS:TagQueue, SQS:UnTagQueue]", [queuePolicyName]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PolicyDocument.Statement[%s].Principal has wildcards, Effect is Allow and Action contains %s", [queuePolicyName, stmt, resultData[0]])
              }
}

isUnsafeStatement(stmt) = result{
	stmt.Effect == "Allow"
    action := hasDangerousAction(stmt.Action)
    object.get(stmt, "Condition", "undefined") == "undefined"
    result := [action, hasWildcardPrincipal(stmt.Principal)]
}

hasWildcardPrincipal(p) = result{
	is_string(p)
    hasStarOrStarAfterColon(p)
    result := p
}

hasWildcardPrincipal(p) = result{
	is_array(p)
    some v
    hasStarOrStarAfterColon(p[v])
    result := p[v]
}

hasWildcardPrincipal(p) = result{
	is_object(p)
    some k
    is_array(p[k])
    some v
    hasStarOrStarAfterColon(p[k][v])
    result :=sprintf("%s.%s", [k, p[k][v]])
}

hasStarOrStarAfterColon(str){
	regex.match("^(\\w*:)*\\*$", str)
}

hasDangerousAction(action) = result{
	is_string(action)
    isDangerousAction(action)
    result := action
}

hasDangerousAction(actions) = result{
	is_array(actions)
    some a
    isDangerousAction(actions[a])
    result := actions[a]
}

isDangerousAction("SQS:AddPermission")
isDangerousAction("SQS:CreateQueue")
isDangerousAction("SQS:DeleteQueue")
isDangerousAction("SQS:RemovePermission")
isDangerousAction("SQS:TagQueue")
isDangerousAction("SQS:UnTagQueue")