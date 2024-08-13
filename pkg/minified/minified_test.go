/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package minified

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_IsMinified(t *testing.T) {
	giantMinifiedJson, _ := os.ReadFile("../../test/fixtures/test_minified/giantminified.json")
	tests := []struct {
		name     string
		nameFile string
		args     []byte
		want     bool
	}{
		{
			name:     "Mini minified file json",
			nameFile: "test.json",
			want:     true,
			args:     []byte("{\"swagger\":\"2.0\",\"info\":{\"version\":\"v1\",\"title\":\"CCBCC.LAUNCHPAD.WebApi\"},\"host\":\"apiapp-dev-lpd.azurewebsites.net\",\"schemes\":[\"https\"],\"paths\":{\"/api/BlobFileDownload\":{\"get\":{\"tags\":[\"BlobFileDownload\"],\"operationId\":\"BlobFileDownload_GetBlobFileDownload\",\"consumes\":[],\"produces\":[\"application/json\",\"text/json\",\"application/xml\",\"text/xml\"],\"responses\":{\"200\":{\"description\":\"OK\",\"schema\":{\"type\":\"object\"}}}}},\"/api/BlobFileDownload/{id}\":{\"get\":{\"tags\":[\"BlobFileDownload\"],\"operationId\":\"BlobFileDownload_Get\",\"consumes\":[],\"produces\":[\"application/json\",\"text/json\",\"application/xml\",\"text/xml\"],\"parameters\":[{\"name\":\"id\",\"in\":\"path\",\"required\":true,\"type\":\"integer\",\"format\":\"int32\"}],\"responses\":{\"200\":{\"description\":\"OK\",\"schema\":{\"type\":\"object\"}}}}}},\"definitions\":{}}"),
		},
		{
			name:     "Huge minified file json",
			nameFile: "test.json",
			want:     true,
			args:     giantMinifiedJson,
		},
		{
			name:     "File not json",
			nameFile: "test.tf",
			want:     false,
			args:     []byte(""),
		},
		{
			name:     "Json not minified",
			nameFile: "test.json",
			want:     false,
			args:     []byte("{\n    \"glossary\": {\n        \"title\": \"example glossary\",\n\t\t\"GlossDiv\": {\n            \"title\": \"S\",\n\t\t\t\"GlossList\": {\n                \"GlossEntry\": {\n                    \"ID\": \"SGML\",\n\t\t\t\t\t\"SortAs\": \"SGML\",\n\t\t\t\t\t\"GlossTerm\": \"Standard Generalized Markup Language\",\n\t\t\t\t\t\"Acronym\": \"SGML\",\n\t\t\t\t\t\"Abbrev\": \"ISO 8879:1986\",\n\t\t\t\t\t\"GlossDef\": {\n                        \"para\": \"A meta-markup language, used to create markup languages such as DocBook.\",\n\t\t\t\t\t\t\"GlossSeeAlso\": [\"GML\", \"XML\"]\n                    },\n\t\t\t\t\t\"GlossSee\": \"markup\"\n                }\n            }\n        }\n    }\n}"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := IsMinified(tt.nameFile, tt.args)
			if tt.want {
				assert.True(t, result, tt.name)
			} else {
				assert.False(t, result, tt.name)
			}
		})
	}
}
