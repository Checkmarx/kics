package Cx

CxPolicy [result] {
  document := input.document[i]
  prop1 := document.Resources[name1]
  prop2 := document.Resources[name2]

  name1 != name2

  prop1.Type == "AWS::EC2::NetworkAclEntry"
  prop2.Type == "AWS::EC2::NetworkAclEntry"
  
  from1 := prop1.Properties.PortRange.From
  to1 := prop1.Properties.PortRange.To
  
  from2 := prop2.Properties.PortRange.From
  to2 := prop2.Properties.PortRange.To
	
  overlap([from1, to1], [from2, to2])
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PortRange", [name1]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.PortRange should be configured with a different unused port range to avoid overlapping'",[name1]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.PortRange has port rage config that is overlapping with others resources and cause ineffective rules'", [name1])
              }
  
 }
overlap(pair1,pair2){
  	pair1[0] <= pair2[0]
    pair1[1] > pair2[1]
}
overlap(pair1,pair2){
  	pair1[0] > pair2[0]
    pair1[1] <= pair2[1]
}
overlap(pair1,pair2){
  	pair1[0] > pair2[0]
    pair1[0] <= pair2[1]
    pair1[1] > pair2[1]
}
overlap(pair1,pair2){
  	pair1[0] < pair2[0]
    pair1[1] >= pair2[0]
    pair1[1] < pair2[1]
}
overlap(pair1,pair2){
  	pair1[0] = pair2[0]
    pair1[1] = pair2[1]
}