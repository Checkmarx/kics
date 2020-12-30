package Cx

CxPolicy [ result ] {
  document := input.document[i]
  tasks := getTasks(document)
  task := tasks[t]
  group := task["amazon.aws.ec2_group"]
  groupName := task.name

  searchKey := getCidrBlock(group)

  splitted := regex.split("{{|}}", searchKey)
  errorPath := substring(splitted[0], 0, count(splitted[0])-1)
  errorValue := splitted[1]

  result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("name={{%s}}.{{amazon.aws.ec2_group}}.%s", [groupName, searchKey]),
                "issueType":        "WrongValue",
                "keyExpectedValue": sprintf("amazon.aws.ec2_group.%s should not contain the value '%s'", [errorPath, errorValue]),
                "keyActualValue":   sprintf("amazon.aws.ec2_group.%s contains value '%s'", [errorPath, errorValue])
              }
}

getTasks(document) = result {
  result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
  count(result) != 0
} else = result {
  result := [body | playbook := document.playbooks[_]; body := playbook ]
  count(result) != 0
}

getCidrBlock(sg) = path {
	hasDefinedPorts(sg.rules[r])
  isUnsafeIp(sg.rules[r].cidr_ip)
  path:="rules.cidr_ip={{0.0.0.0/0}}"
} else = path {
	hasDefinedPorts(sg.rules[r])
	isUnsafeIp(sg.rules[r].cidr_ip[c])
  path:="rules.cidr_ip.{{0.0.0.0/0}}"
} else = path {
	hasDefinedPorts(sg.rules[r])
  isUnsafeIpv6(sg.rules[r].cidr_ipv6)
  path:="rules.cidr_ipv6={{::/0}}"
} else = path {
	hasDefinedPorts(sg.rules[r])
	isUnsafeIpv6(sg.rules[r].cidr_ipv6[c])
  path:="rules.cidr_ipv6.{{::/0}}"
}

hasDefinedPorts(rule){
	rule.from_port
  rule.to_port
} else {
	rule.ports
}

isUnsafeIp("0.0.0.0/0")
isUnsafeIpv6("::/0")
