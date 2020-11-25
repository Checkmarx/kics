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
	require.Equal(t, []string{"", ".dockerfile"}, p.SupportedExtensions())
}

func TestParser_Parse(t *testing.T) {
	p := &Parser{}
	sample := `FROM foo
COPY . /
RUN echo hello`
	doc, err := p.Parse("Dockerfile", []byte(sample))
	require.NoError(t, err)
	require.Len(t, doc, 1)
}
