package docker

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindDOCKER, p.GetKind())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"Dockerfile", ".dockerfile"}, p.SupportedExtensions())
}

// TestParser_SupportedExtensions tests the functions [SupportedTypes()] and all the methods called by them
func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{"dockerfile"}, p.SupportedTypes())
}

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
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

		FROM ubuntu:xenial2
		RUN echo hi > /etc/hi.conf
		CMD ["echo"]
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
			require.Len(t, doc[0]["command"], 1)
			require.Contains(t, doc[0]["command"], "openjdk:11-jdk")
			docJDk := doc[0]["command"].(map[string]interface{})["openjdk:11-jdk"]
			require.Len(t, docJDk, 7)
			require.Contains(t, docJDk.([]interface{})[5].(map[string]interface{})["Value"].([]interface{})[0], "${JAR_FILE}")
		case 1:
			require.NoError(t, err)
			require.Len(t, doc, 1)
			require.Len(t, doc[0]["command"], 2)
			require.Contains(t, doc[0]["command"], "ubuntu:xenial")
			require.Contains(t, doc[0]["command"], "ubuntu:xenial2")
			docXec := doc[0]["command"].(map[string]interface{})["ubuntu:xenial"]
			docXec2 := doc[0]["command"].(map[string]interface{})["ubuntu:xenial2"]
			require.Len(t, docXec, 6)
			require.Len(t, docXec2, 3)
			require.Contains(t, docXec.([]interface{})[3].(map[string]interface{})["Flags"].([]interface{})[0], "--retries=5")
			require.Contains(t, docXec.([]interface{})[4].(map[string]interface{})["SubCmd"], "add")
		case 2:
			require.NoError(t, err)
			require.Len(t, doc, 1)
			require.Len(t, doc[0]["command"], 1)
			require.Contains(t, doc[0]["command"], "golang:alpine")
			docGoALP := doc[0]["command"].(map[string]interface{})["golang:alpine"]
			require.Len(t, docGoALP, 5)
			require.Contains(t, docGoALP.([]interface{})[4].(map[string]interface{})["Value"].([]interface{})[0], "${GIT_USER}")
		}
	}
}
