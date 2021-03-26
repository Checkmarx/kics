package docker

import (
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/require"
)

// TestDetectDockerLine tests the functions [DetectDockerLine()] and all the methods called by them
func TestDetectDockerLine(t *testing.T) { //nolint
	testCases := []struct {
		expected  model.VulnerabilityLines
		searchKey string
		file      *model.FileMetadata
	}{
		{
			expected: model.VulnerabilityLines{
				Line: 10,
				VulnLine: model.VulnLines{
					Positions: []int{9, 10, 11},
					Lines: []string{
						"RUN apk update",
						"RUN apk update && apk upgrade && apk add kubectl=1.20.0-r0 \\",
						"\t&& rm -rf /var/cache/apk/*",
					},
				},
			},
			searchKey: "FROM={{alpine:3.9}}.RUN={{apk update && apk upgrade && apk add kubectl=1.20.0-r0 	\u0026\u0026 rm -rf /var/cache/apk/*}}",
			file: &model.FileMetadata{
				ScanID: "Test2",
				ID:     "Test2",
				Kind:   model.KindDOCKER,
				OriginalData: `FROM alpine:3.7
RUN apk update \
	&& apk upgrade \
	&& apk add kubectl=1.20.0-r0 \
	&& rm -rf /var/cache/apk/*
ENTRYPOINT ["kubectl"]

FROM alpine:3.9
RUN apk update
RUN apk update && apk upgrade && apk add kubectl=1.20.0-r0 \
	&& rm -rf /var/cache/apk/*
ENTRYPOINT ["kubectl"]
`,
			},
		},
		{
			expected: model.VulnerabilityLines{
				Line: 17,
				VulnLine: model.VulnLines{
					Positions: []int{16, 17, 18},
					Lines: []string{
						"ARG JAR_FILE",
						"ADD ${JAR_FILE} apps.jar",
						"",
					},
				},
			},
			searchKey: "FROM=openjdk:11-jdk.{{ADD ${JAR_FILE} apps.jar}}",
			file: &model.FileMetadata{
				ScanID: "Test3",
				ID:     "Test3",
				Kind:   model.KindDOCKER,
				OriginalData: `FROM openjdk:10-jdk
VOLUME /tmp
ADD http://source.file/package.file.tar.gz /temp
RUN tar -xjf /temp/package.file.tar.gz \
	&& make -C /tmp/package.file \
	&& rm /tmp/ package.file.tar.gz
ARG JAR_FILE
ADD ${JAR_FILE} app.jar

FROM openjdk:11-jdk
VOLUME /tmp
ADD http://source.file/package.file.tar.gz /temp
RUN tar -xjf /temp/package.file.tar.gz \
	&& make -C /tmp/package.file \
	&& rm /tmp/ package.file.tar.gz
ARG JAR_FILE
ADD ${JAR_FILE} apps.jar
`,
			},
		},
		{
			expected: model.VulnerabilityLines{
				Line: 6,
				VulnLine: model.VulnLines{
					Positions: []int{5, 6, 7},
					Lines: []string{
						`	&& apk add kubectl=1.20.0-r0 \`,
						"	&& rm -rf /var/cache/apk/*",
						`ENTRYPOINT ["kubectl"]`,
					},
				},
			},
			searchKey: "FROM={{alpine:3.7}}.ENTRYPOINT[kubectl]",
			file: &model.FileMetadata{
				ScanID: "Test",
				ID:     "Test",
				Kind:   model.KindDOCKER,
				OriginalData: `FROM alpine:3.7
RUN apk update \
	&& apk upgrade \
	&& apk add kubectl=1.20.0-r0 \
	&& rm -rf /var/cache/apk/*
ENTRYPOINT ["kubectl"]`,
			},
		},
	}

	for i, testCase := range testCases {
		detector := DetectKindLine{}
		t.Run(fmt.Sprintf("detectDockerLine-%d", i), func(t *testing.T) {
			v := detector.DetectLine(testCase.file, testCase.searchKey, &zerolog.Logger{}, 3)
			require.Equal(t, testCase.expected, v)
		})
	}
}
