package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

getForProvider(apiVersion, kind, name, docs) = forProvider {
	doc := docs[_]
	[_, resource] := walk(doc)
	startswith(resource.apiVersion, apiVersion)
	resource.kind == kind
	resource.metadata.name == name
    forProvider := resource.spec.forProvider
}

existsInternetGateway(dbSubnetGroupName) {
    DBSGforProvider := getForProvider("database.aws.crossplane.io", "DBSubnetGroup", dbSubnetGroupName, input.document)
    subnetIds := DBSGforProvider.subnetIds

    count(subnetIds) > 0
    subnetId := subnetIds[s]

    EC2SforProvider := getForProvider("ec2.aws.crossplane.io", "Subnet", subnetId, input.document)

    vpcId := EC2SforProvider.vpcId

    IGdocs := input.document[_]
    [_, IGresource] := walk(IGdocs)
	startswith(IGresource.apiVersion, "network.aws.crossplane.io")
    IGresource.kind == "InternetGateway"
    
    IGforProvider := IGresource.spec.forProvider
	
    common_lib.valid_key(IGforProvider, "vpcId")
	vpcId == IGforProvider.vpcId
} 

CxPolicy[result] {
    docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "database.aws.crossplane.io")
    resource.kind == "RDSInstance"
    
    forProvider := resource.spec.forProvider

    not common_lib.valid_key(forProvider, "publiclyAccessible")
    
    dbSubnetGroupName := forProvider.dbSubnetGroupName
    
    existsInternetGateway(dbSubnetGroupName) == true

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.dbSubnetGroupName", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyActualValue": "dbSubnetGroupName' subnets are part of a VPC that has an Internet gateway attached to it",
		"keyExpectedValue": "dbSubnetGroupName' subnets not being part of a VPC that has an Internet gateway attached to it",
	}
}

CxPolicy[result] {
    docs := input.document[i]
	[path, resource] := walk(docs)
	startswith(resource.apiVersion, "database.aws.crossplane.io")
    resource.kind == "RDSInstance"
    
    forProvider := resource.spec.forProvider
    forProvider.publiclyAccessible == true

    result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": cp_lib.getResourceName(resource),
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.publiclyAccessible", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "publiclyAccessible should be set to false",
		"keyActualValue": "publiclyAccessible is set to true",
	}
}