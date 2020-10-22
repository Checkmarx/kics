package json

import (
	"encoding/json"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

type Parser struct {
}

func (p *Parser) Parse(_ string, fileContent []byte) ([]model.Document, error) {
	r := model.Document{}
	err := json.Unmarshal(fileContent, &r)

	return []model.Document{r}, errors.Wrap(err, "failed to unmarshall json content")
}

func (p *Parser) SupportedExtensions() []string {
	return []string{".json"}
}

func (p *Parser) GetKind() model.FileKind {
	return model.KindJSON
}
