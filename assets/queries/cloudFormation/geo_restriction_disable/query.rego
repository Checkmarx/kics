package Cx

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  restrictionType := input.document[i].Resources[name].Properties[j].Restrictions.GeoRestriction.RestrictionType
  check_action(restrictionType)
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.Restrictions.GeoRestriction.RestrictionType", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.Restrictions.GeoRestriction.RestrictionType should be enable with whitelist or blacklist", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.Restrictions.GeoRestriction.RestrictionTypeallows is configured with none. Therefore, Geo Restriction is not enable and it should be", [name])
              } 
}
check_action(action){
	is_string(action)
    not contains(lower(action), "whitelist")
    not contains(lower(action), "blacklist")
}