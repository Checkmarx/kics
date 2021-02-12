package Cx

isSSH(currentFromPort, currentToPort) = allow {
	currentFromPort <= 22
	currentToPort >= 22
	allow = true
}

isPrivate(cidr) = allow {
	privateIPs = ["192.120.0.0/16", "75.132.0.0/16", "79.32.0.0/8", "73.16.0.0/12"]

	cidrLength := count(cidr)

	privLen := count({x | cidr[x]; cidr[x] == privateIPs[j]})
    varLen := count({b | cidr[b]; contains(cidr[b],"$")}) # check if all CIDR blocks are stored in variables, which cannot be evaluated in the static scanning

    privLen + varLen == cidrLength
    
	allow = true
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	ingress := getIngressList(resource.ingress)
	currentFromPort := ingress[j].from_port
	currentToPort := ingress[j].to_port
	cidr := ingress[j].cidr_blocks

	isSSH(currentFromPort, currentToPort)

	not isPrivate(cidr)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s] SSH' (Port:22) is not public", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] SSH' (Port:22) is public", [name]),
	}
}

getIngressList(ingress) = list {
    is_array(ingress)
    list := ingress
} else = list {
    is_object(ingress)
    list := [ingress]
} else = null
