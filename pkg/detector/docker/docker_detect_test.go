package docker

import (
	"fmt"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/require"
)

var OriginalData1 = `FROM alpine:3.7
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
`
var OriginalData2 = `FROM openjdk:10-jdk
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
`

var OriginalData3 = `FROM alpine:3.7
RUN apk update \
	&& apk upgrade \
	&& apk add kubectl=1.20.0-r0 \
	&& rm -rf /var/cache/apk/*
ENTRYPOINT ["kubectl"]`

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
				VulnLines: &[]model.CodeLine{
					{
						Position: 9,
						Line:     "RUN apk update",
					},
					{
						Position: 10,
						Line:     "RUN apk update && apk upgrade && apk add kubectl=1.20.0-r0 \\",
					},
					{
						Position: 11,
						Line:     "\t&& rm -rf /var/cache/apk/*",
					},
				},
			},
			searchKey: "FROM={{alpine:3.9}}.RUN={{apk update && apk upgrade && apk add kubectl=1.20.0-r0 	\u0026\u0026 rm -rf /var/cache/apk/*}}",
			file: &model.FileMetadata{
				ScanID:            "Test2",
				ID:                "Test2",
				Kind:              model.KindDOCKER,
				OriginalData:      OriginalData1,
				LinesOriginalData: utils.SplitLines(OriginalData1),
			},
		},
		{
			expected: model.VulnerabilityLines{
				Line: 17,
				VulnLines: &[]model.CodeLine{
					{
						Position: 16,
						Line:     "ARG JAR_FILE",
					},
					{
						Position: 17,
						Line:     "ADD ${JAR_FILE} apps.jar",
					},
					{
						Position: 18,
						Line:     "",
					},
				},
			},
			searchKey: "FROM=openjdk:11-jdk.{{ADD ${JAR_FILE} apps.jar}}",
			file: &model.FileMetadata{
				ScanID:            "Test3",
				ID:                "Test3",
				Kind:              model.KindDOCKER,
				OriginalData:      OriginalData2,
				LinesOriginalData: utils.SplitLines(OriginalData2),
			},
		},
		{
			expected: model.VulnerabilityLines{
				Line: 6,
				VulnLines: &[]model.CodeLine{
					{
						Position: 4,
						Line:     `	&& apk add kubectl=1.20.0-r0 \`,
					},
					{
						Position: 5,
						Line:     "	&& rm -rf /var/cache/apk/*",
					},
					{
						Position: 6,
						Line:     `ENTRYPOINT ["kubectl"]`,
					},
				},
			},
			searchKey: "FROM={{alpine:3.7}}.ENTRYPOINT[kubectl]",
			file: &model.FileMetadata{
				ScanID:            "Test",
				ID:                "Test",
				Kind:              model.KindDOCKER,
				OriginalData:      OriginalData3,
				LinesOriginalData: utils.SplitLines(OriginalData3),
			},
		},
	}

	for i, testCase := range testCases {
		detector := DetectKindLine{}
		t.Run(fmt.Sprintf("detectDockerLine-%d", i), func(t *testing.T) {
			v := detector.DetectLine(testCase.file, testCase.searchKey, 3, &zerolog.Logger{})
			require.Equal(t, testCase.expected, v)
		})
	}
}

// TestDetectDockerLineConcurrentAccess reproduces the data race triggered when multiple
// queries run in parallel (as the Inspector's worker pool does) and call DetectLine for the
// same file at the same time. DetectLine's prepareDockerFileLines/multiLineSpliter mutate the
// slice behind file.LinesOriginalData in place and that pointer is shared across every query
// that scans the same file, so concurrent calls race on it and can panic with
// "runtime error: slice bounds out of range [:-1]".
func TestDetectDockerLineConcurrentAccess(t *testing.T) {
	file := &model.FileMetadata{
		ScanID:            "TestConcurrent",
		ID:                "TestConcurrent",
		Kind:              model.KindDOCKER,
		OriginalData:      OriginalData1,
		LinesOriginalData: utils.SplitLines(OriginalData1),
	}

	searchKeys := []string{
		"FROM={{alpine:3.9}}.RUN={{apk update && apk upgrade && apk add kubectl=1.20.0-r0 	&& rm -rf /var/cache/apk/*}}",
		"FROM={{alpine:3.7}}.ENTRYPOINT[kubectl]",
		"FROM={{alpine:3.9}}.ENTRYPOINT[kubectl]",
	}

	var wg sync.WaitGroup
	for g := 0; g < 50; g++ {
		searchKey := searchKeys[g%len(searchKeys)]
		wg.Add(1)
		go func() {
			defer wg.Done()
			detector := DetectKindLine{}
			detector.DetectLine(file, searchKey, 3, &zerolog.Logger{})
		}()
	}
	wg.Wait()
}
