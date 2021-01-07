package Cx

CxPolicy [result ]  {

  resources := input.document[i].Resources
  resource := resources[j]
  resource.Type == "AWS::EC2::Instance"

  networkInterface := resource.Properties.NetworkInterfaces[n]
  networkInterface.AssociatePublicIpAddress
  subnetName := networkInterface.SubnetId

  resources[subnetName]

  some k
  	resources[k].Type == "AWS::EC2::SubnetRouteTableAssociation"
    resources[k].Properties.SubnetId == subnetName
    routeTable := resources[k].Properties.RouteTableId

  some l
  	resources[l].Type = "AWS::EC2::Route"
    resources[l].Properties.RouteTableId == routeTable

  HasPublicDestinationCidr(resources[l])

  result := {
              "documentId": 		input.document[i].id,
              "searchKey": 	    sprintf("Resources.%s", [subnetName]),
              "issueType":		"IncorrectValue",
              "keyExpectedValue": sprintf("Resources.%s is a private subnet",[subnetName]),
              "keyActualValue": 	sprintf("Resources.%s has a route for unrestricted internet traffic",[subnetName])
            }
}

HasPublicDestinationCidr(resource) {
	resource.Properties.DestinationIpv6CidrBlock == "::/0"
}

HasPublicDestinationCidr(resource) {
	resource.Properties.DestinationCidrBlock == "0.0.0.0/0"
}
