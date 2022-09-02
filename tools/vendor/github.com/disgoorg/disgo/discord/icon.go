package discord

import (
	"encoding/base64"
	"fmt"
	"io"

	"github.com/disgoorg/disgo/json"
)

type IconType string

const (
	IconTypeJPEG    IconType = "image/jpeg"
	IconTypePNG     IconType = "image/png"
	IconTypeWEBP    IconType = "image/webp"
	IconTypeGIF     IconType = "image/gif"
	IconTypeUnknown          = IconTypeJPEG
)

func (t IconType) GetMIME() string {
	return string(t)
}

func (t IconType) GetHeader() string {
	return "data:" + string(t) + ";base64"
}

var _ json.Marshaler = (*Icon)(nil)
var _ fmt.Stringer = (*Icon)(nil)

func NewIcon(iconType IconType, reader io.Reader) (*Icon, error) {
	data, err := io.ReadAll(reader)
	if err != nil {
		return nil, err
	}
	return NewIconRaw(iconType, data), nil
}

func NewIconRaw(iconType IconType, src []byte) *Icon {
	data := make([]byte, base64.StdEncoding.EncodedLen(len(src)))
	base64.StdEncoding.Encode(data, src)
	return &Icon{Type: iconType, Data: data}
}

type Icon struct {
	Type IconType
	Data []byte
}

func (i Icon) MarshalJSON() ([]byte, error) {
	return json.Marshal(i.String())
}

func (i Icon) String() string {
	if len(i.Data) == 0 {
		return ""
	}
	return i.Type.GetHeader() + "," + string(i.Data)
}
