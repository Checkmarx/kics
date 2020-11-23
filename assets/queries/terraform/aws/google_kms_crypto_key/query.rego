package Cx

CxPolicy [ result ] {
  cryptoKey := input.document[i].resource.google_kms_crypto_key[name]
  rotationP := substring(cryptoKey.rotation_period,0,count(cryptoKey.rotation_period)-1) 
  to_number(rotationP) < 7776000

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resource.google_kms_crypto_key[%s].rotation_period", [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'key.rotation_period' >= 7776000",
                "keyActualValue": 	"'key.rotation_period' < 7776000"
              }
}

CxPolicy [ result ] {
  cryptoKey := input.document[i].resource.google_kms_crypto_key[name]

  not cryptoKey.rotation_period

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resource.google_kms_crypto_key[%s].rotation_period", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": "'key.rotation_period' >= 7776000",
                "keyActualValue": 	"'key.rotation_period' is undefined"
              }
} 