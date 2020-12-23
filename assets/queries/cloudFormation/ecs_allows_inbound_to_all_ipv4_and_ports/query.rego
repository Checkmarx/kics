package Cx

CxPolicy[result] {
  doc := input.document[i]
  resource := doc.Resources[name]
  resource.Type == "AWS::ECS::Service"
  
  clusterList := [ cluster |
  	doc.Resources[j].Type == "AWS::ECS::Cluster";
  	cluster := j
  ]
  count(clusterList) > 0
  
  securityGroupList := [ secGroup |
  	doc.Resources[j].Type == "AWS::EC2::SecurityGroup";
  	secGroup := j
  ]
  count(securityGroupList) > 0
    
  doc.Resources[k].Type == "AWS::EC2::SecurityGroupIngress";
  doc.Resources[k].Properties.CidrIp == "0.0.0.0/0";
  doc.Resources[k].Properties.ToPort == 0;
  array_contains(securityGroupList, doc.Resources[k].Properties.GroupId)
  
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.Properties.CidrIp", [k]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of type '%s' should not accept ingress connections from all IPv4 adresses and to all available ports", [
    	k,
    	doc.Resources[k].Type
    ]),
    "keyActualValue": sprintf("Resource name '%s' of type '%s' should not accept ingress connections from CIDR %s to all available ports", [
    	k,
      doc.Resources[k].Type,
      doc.Resources[k].Properties.CidrIp
    ])
  }
}

array_contains(arr, elm) {
	arr[_] == elm
}
