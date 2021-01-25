package Cx

	#search for harcoded secrets by looking for their values with a special chars and length
CxPolicy [ result ] {
        #get all string values from json
    allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
 	allStrings = {"key":split(allValues[idd], ":")[0], "value":split(allValues[idd], ":")[1]}

     	#remove trailling quotation marks
    correctStrings = {
    					"key" : substring(allStrings["key"], 1, count(allStrings["key"])-2 ),
    					"value":substring(allStrings["value"], 1, count(allStrings["value"])-3 )
    				}

        #remove short strings
    count(correctStrings.value) > 30

        #remove string with non-keys characters
    count(regex.find_n("^[^\\s/:@,.-]+$", correctStrings.value, -1)) > 0

    result := {
                "documentId":       input.document[id].id,
                "searchKey":        sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
                "issueType":        "RedundantAttribute",
                "keyExpectedValue": "Hardcoded secret key should not appear in source",
                "keyActualValue":   correctStrings.value
              }
}

	#search for harcoded secret keys under known names
CxPolicy [ result ] {
        #get all string values from json
    allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
 	allStrings = {"key":split(allValues[idd], ":")[0], "value":split(allValues[idd], ":")[1]}

     	#remove trailling quotation marks
    correctStrings = {
    					"key" : substring(allStrings["key"], 1, count(allStrings["key"])-2 ),
    					"value":substring(allStrings["value"], 1, count(allStrings["value"])-3 )
    				}

        #remove short strings
    count(correctStrings.value) > 8

        #remove string with non-keys characters
    count(regex.find_n("^[^\\s$]+$", correctStrings.value, -1)) > 0

    	#look for a known names
    isUnderSekretKey(correctStrings.key)

        #remove string with non-keys characters
    count(regex.find_n("^[^\\s/:@,.-]+$", correctStrings.value, -1)) > 0

    result := {
                "documentId":       input.document[id].id,
                "searchKey":        sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
                "issueType":        "RedundantAttribute",
                "keyExpectedValue": "Hardcoded secret key should not appear in source",
                "keyActualValue":   correctStrings.value
              }
}

	#search for harcoded secrets with known prefixes
CxPolicy [ result ] {
        #get all string values from json
    allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
 	allStrings = {"key":split(allValues[idd], ":")[0], "value":split(allValues[idd], ":")[1]}

     	#remove trailling quotation marks
    correctStrings = {
    					"key" : substring(allStrings["key"], 1, count(allStrings["key"])-2 ),
    					"value":substring(allStrings["value"], 1, count(allStrings["value"])-3 )
    				}

        #look for a known prefix
   contains(correctStrings.value, "PRIVATE KEY")

    result := {
                "documentId":       input.document[id].id,
                "searchKey":        sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
                "issueType":        "RedundantAttribute",
                "keyExpectedValue": "Hardcoded secret key should not appear in source",
                "keyActualValue":   correctStrings.value
              }
}


	#search for non-default passwords with upper, lower chars and digits
CxPolicy [ result ] {
	    #get all string values from json
    allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
 	allStrings = {"key":split(allValues[idd], ":")[0], "value":split(allValues[idd], ":")[1]}

     	#remove trailling quotation marks
    correctStrings = {
    					"key" : substring(allStrings["key"], 1, count(allStrings["key"])-2 ),
    					"value":substring(allStrings["value"], 1, count(allStrings["value"])-3 )
                    }

    	#remove short strings
    count(correctStrings.value) > 6
    count(correctStrings.value) < 20

    	#password should contain alpha and numeric and not contain spaces
    count(regex.find_n("[a-z]+", correctStrings.value, -1)) > 0
    count(regex.find_n("[A-Z]+", correctStrings.value, -1)) > 0
    count(regex.find_n("[0-9]+", correctStrings.value, -1)) > 0
	count(regex.find_n("^[^\\s]+$", correctStrings.value, -1)) > 0

    result := {
                "documentId":       input.document[id].id,
                "searchKey":        sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
                "issueType":        "RedundantAttribute",
                "keyExpectedValue": "Hardcoded passwords should not appear in source",
                "keyActualValue":   correctStrings.value
              }
}


	#search for non-default passwords under known names
CxPolicy [ result ] {
	    #get all string values from json
    allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
 	allStrings = {"key":split(allValues[idd], ":")[0], "value":split(allValues[idd], ":")[1]}

     	#remove trailling quotation marks
    correctStrings = {
    					"key" : substring(allStrings["key"], 1, count(allStrings["key"])-2 ),
    					"value":substring(allStrings["value"], 1, count(allStrings["value"])-3 )
                    }

    	#remove short strings
    count(correctStrings.value) > 4
    count(correctStrings.value) < 30

    	#password should contain alpha and numeric and not contain spaces
    count(regex.find_n("[a-zA-Z0-9]+", correctStrings.value, -1)) > 0

    isUnderPasswordKey(correctStrings.key)

    result := {
                "documentId":       input.document[id].id,
                "searchKey":        sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
                "issueType":        "RedundantAttribute",
                "keyExpectedValue": "Hardcoded passwords should not appear in source",
                "keyActualValue":   correctStrings.value
              }
}


	#search for default passwords
CxPolicy [ result ] {
		    #get all string values from json
    allValues = regex.find_n("\"[^\"]+\"\\s*:\\s*\"[^\"$]+\"[]\n\r,}]", json.marshal(input.document[id][name]), -1)
 	allStrings = {"key":split(allValues[idd], ":")[0], "value":split(allValues[idd], ":")[1]}


    	#remove trailling quotation marks
    correctStrings = {
    					"key" : substring(allStrings["key"], 1, count(allStrings["key"])-2 ),
    					"value":substring(allStrings["value"], 1, count(allStrings["value"])-3 )
                    }

	isDefaultPassword(correctStrings.value)
    isUnderPasswordKey(correctStrings.key)

    result := {
                "documentId":       input.document[id].id,
                "searchKey":        sprintf("%s=%s", [correctStrings.key, correctStrings.value]),
                "issueType":        "RedundantAttribute",
                "keyExpectedValue": "Hardcoded passwords should not appear in source",
                "keyActualValue":   correctStrings.value
              }
}

isUnderPasswordKey(p) = res {
	ar = {"pas", "psw", "pwd"}
    res := contains(lower(p), ar[_])
}

isUnderSekretKey(p) = res {
	ar = {"secret", "encrypt", "credential"}
    res := contains(lower(p), ar[_])
}


isDefaultPassword(p) = res {
	ar = {
            "root",
            "!@",
            "wubao",
            "password",
            "123456",
            "admin",
            "12345",
            "1234",
            "p@ssw0rd",
            "123",
            "1",
            "jiamima",
            "test",
            "root123",
            "!",
            "!q@w",
            "!qaz@wsx",
            "idc!@",
            "admin!@",
            "",
            "alpine",
            "qwerty",
            "12345678",
            "111111",
            "123456789",
            "1q2w3e4r",
            "123123",
            "default",
            "1234567",
            "qwe123",
            "1qaz2wsx",
            "1234567890",
            "abcd1234",
            "000000",
            "user",
            "toor",
            "qwer1234",
            "1q2w3e",
            "asdf1234",
            "redhat",
            "1234qwer",
            "cisco",
            "12qwaszx",
            "test123",
            "1q2w3e4r5t",
            "admin123",
            "changeme",
            "1qazxsw2",
            "123qweasd",
            "q1w2e3r4",
            "letmein",
            "server",
            "root1234",
            "master",
            "abc123",
            "rootroot",
            "a",
            "system",
            "pass",
            "1qaz2wsx3edc",
            "p@$$w0rd",
            "112233",
            "welcome",
            "!QAZ2wsx",
            "linux",
            "123321",
            "manager",
            "1qazXSW@",
            "q1w2e3r4t5",
            "oracle",
            "asd123",
            "admin123456",
            "ubnt",
            "123qwe",
            "qazwsxedc",
            "administrator",
            "superuser",
            "zaq12wsx",
            "121212",
            "654321",
            "ubuntu",
            "0000",
            "zxcvbnm",
            "root@123",
            "1111",
            "vmware",
            "q1w2e3",
            "qwerty123",
            "cisco123",
            "11111111",
            "pa55w0rd",
            "asdfgh",
            "11111",
            "123abc",
            "asdf",
            "centos",
            "888888",
            "54321",
            "password123"
		}
    res := ar[p]
}
