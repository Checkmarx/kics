package Cx

CxPolicy [ result ] {
   document := input.document
   resources := document[i].Resources[name]
   not_exists_vpc := check_exists_vpc(resources)
   not_exists_vpc
   
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.VpcId.Ref", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.VpcId.Ref is defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.VpcId.Ref is undefined", [name])
              }
}

CxPolicy [ result ] {
   document := input.document
   resources := document[i].Resources[name]
   default_name := check_group_name(resources)
   default_name
     
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.GroupName", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.GroupName should not be defined as default", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.GroupName is defined as default", [name])
              }
}

check_exists_vpc(resource) {
    resource.Type == "AWS::EC2::SecurityGroup"
    security_group := resource.Properties
    exists_vpc := object.get(security_group, "VpcId", "undefined") != "undefined"
    not exists_vpc
}

check_group_name(resource) {
    resource.Type == "AWS::EC2::SecurityGroup"
    security_group := resource.Properties
    security_group.GroupName == "default"
}