package docker

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindDOCKER, p.GetKind())
}

func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"Dockerfile", ".dockerfile"}, p.SupportedExtensions())
}

func TestParser_Parse(t *testing.T) {
	p := &Parser{}
	sample := []string{
		`
		FROM openjdk:11-jdk
		VOLUME /tmp
		ADD http://source.file/package.file.tar.gz /temp
		RUN tar --xjf /temp/package.file.tar.gz \
  			&& make -C /tmp/package.file \
  			&& rm /tmp/ package.file.tar.gz
		ARG JAR_FILE
		ADD ${JAR_FILE} app.jar
		ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
		`,
		`
		FROM ubuntu:xenial
		RUN echo hi > /etc/hi.conf
		CMD ["echo"]
		HEALTHCHECK --retries=5 CMD echo hi
		ONBUILD ADD foo bar
		ONBUILD RUN ["cat", "bar"]
		`,
		`
		FROM golang:alpine
		ENV CGO_ENABLED=0
		WORKDIR /app
		COPY . .
		RUN apk add --no-cache git \
     		&& git config \
      		--global \
      		url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
      		"https://github.com"
		`,
	}

	for idx, sampleFile := range sample {
		doc, err := p.Parse("Dockerfile", []byte(sampleFile))
		switch idx {
		case 0:
			require.NoError(t, err)
			require.Len(t, doc, 1)
			require.Len(t, doc[0]["command"], 3)
			require.Contains(t, doc[0]["command"].([]interface{})[1].(map[string]interface{})["Cmd"], "copy")
			require.Contains(t, doc[0]["command"].([]interface{})[2].(map[string]interface{})["Value"].([]interface{})[0], "echo hello")
		case 1:
			require.NoError(t, err)
			require.Len(t, doc, 1)
			require.Len(t, doc[0]["command"], 6)
			require.Contains(t, doc[0]["command"].([]interface{})[3].(map[string]interface{})["Cmd"], "healthcheck")
			require.Contains(t, doc[0]["command"].([]interface{})[4].(map[string]interface{})["SubCmd"], "add")
			require.Contains(t, doc[0]["command"].([]interface{})[3].(map[string]interface{})["Value"].([]interface{})[1], "echo hi")
		case 2:
			require.NoError(t, err)
			require.Len(t, doc, 1)
			require.Len(t, doc[0]["command"], 5)
			require.Contains(t, doc[0]["command"].([]interface{})[4].(map[string]interface{})["Value"].([]interface{})[0], "https://github.com")
			require.Contains(t, doc[0]["command"].([]interface{})[4].(map[string]interface{})["Cmd"], "run")
			require.Contains(t, doc[0]["command"].([]interface{})[1].(map[string]interface{})["Value"].([]interface{})[0], "CGO_ENABLED")
		}
	}
}
