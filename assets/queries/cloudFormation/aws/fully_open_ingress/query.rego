package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as commonLib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	resource.Type == "AWS::ECS::Service"

	clusterList := [j | doc.Resources[j].Type == "AWS::ECS::Cluster"]

	count(clusterList) > 0

	securityGroupList := [j | doc.Resources[j].Type == "AWS::EC2::SecurityGroup"]

	count(securityGroupList) > 0

	doc.Resources[k].Type == "AWS::EC2::SecurityGroupIngress"
	doc.Resources[k].Properties.CidrIp == "0.0.0.0/0"
	doc.Resources[k].Properties.ToPort == 0
	commonLib.inArray(securityGroupList, doc.Resources[k].Properties.GroupId)

	result := {
		"documentId": input.document[i].id,
		"resourceType": doc.Resources[k].Type,
		"resourceName": cf_lib.get_resource_name(doc.Resources[k], k),
		"searchKey": sprintf("Resources.%s.Properties.CidrIp", [k]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource name '%s' of type '%s' should not accept ingress connections from all IPv4 adresses and to all available ports", [
			k,
			doc.Resources[k].Type,
		]),
		"keyActualValue": sprintf("Resource name '%s' of type '%s' should not accept ingress connections from CIDR %s to all available ports", [
			k,
			doc.Resources[k].Type,
			doc.Resources[k].Properties.CidrIp,
		]),
	}
}
