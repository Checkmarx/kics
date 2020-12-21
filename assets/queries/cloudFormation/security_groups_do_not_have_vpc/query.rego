package Cx

CxPolicy [ result ] {
  document := input.document
  resources := document[i].Resources[name]
  not_exists_vpc := check_not_exists_vpc(resources)
  not_exists_vpc
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.VpcId.Ref", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.VpcId.Ref is defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.VpcId.Ref is undefined", [name])
              }
}

check_not_exists_vpc(resource) {
  resource.Type == "AWS::EC2::SecurityGroup"
  security_group := resource.Properties
  security_group.GroupName != "default"
  exists_vpc := object.get(security_group, "VpcId", "undefined") != "undefined"
  not exists_vpc
}