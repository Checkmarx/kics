package converter

import (
	"github.com/emicklei/proto"
)

// JSONProto is a JSON representation of a proto file
type JSONProto struct {
	Syntax      string             `json:"syntax"`
	PackageName string             `json:"package"`
	Messages    map[string]Message `json:"messages"`
	Enum        map[string]Enum    `json:"enum"`
	Services    map[string]Service `json:"services"`
	Imports     map[string]Import  `json:"imports"`
	Options     []Option           `json:"options"`
}

// Service is a JSON representation of a proto service
type Service struct {
	RPC     map[string]RPC    `json:"rpc,omitempty"`
	Options map[string]Option `json:"options,omitempty"`
}

// Message is a JSON representation of a proto message
type Message struct {
	Field        map[string]*Field  `json:"field,omitempty"`
	Reserved     []*Reserved        `json:"reserved,omitempty"`
	OneOf        map[string]OneOf   `json:"oneof,omitempty"`
	Enum         map[string]Enum    `json:"enum,omitempty"`
	Map          map[string]*Map    `json:"map,omitempty"`
	InnerMessage map[string]Message `json:"inner_message,omitempty"`
	Options      map[string]Option  `json:"options,omitempty"`
}

// Map is a JSON representation of a proto map
type Map struct {
	*Field  `json:"field,omitempty"`
	KeyType string `json:"key_type,omitempty"`
}

// OneOf is a JSON representation of a proto oneof
type OneOf struct {
	Field   map[string]*Field `json:"fields,omitempty"`
	Options map[string]Option `json:"options,omitempty"`
}

// Enum is a JSON representation of a proto enum
type Enum struct {
	Reserved  []*Reserved          `json:"reserved,omitempty"`
	EnumField map[string]EnumValue `json:"field,omitempty"`
	Options   map[string]Option    `json:"options,omitempty"`
}

// EnumValue is a JSON representation of a proto enum value
type EnumValue struct {
	Value   int    `json:"value,omitempty"`
	Options Option `json:"options,omitempty"`
}

// Import is a JSON representation of a proto import
type Import struct {
	Kind string `json:"kind,omitempty"`
}

// Reserved is a JSON representation of a proto reserved
type Reserved struct {
	Ranges     []proto.Range `json:"ranges,omitempty"`
	FieldNames []string      `json:"fieldNames,omitempty"`
}

// Field is a JSON representation of a proto field
type Field struct {
	Type     string   `json:"type,omitempty"`
	Sequence int      `json:"sequence,omitempty"`
	Repeated bool     `json:"repeated,omitempty"`
	Required bool     `json:"required,omitempty"`
	Optional bool     `json:"optional,omitempty"`
	Options  []Option `json:"options,omitempty"`
}

// RPC is a JSON representation of a proto service RPC
type RPC struct {
	RequestType    string   `json:"requestType,omitempty"`
	StreamsRequest bool     `json:"streamsRequest,omitempty"`
	ReturnsType    string   `json:"returnsType,omitempty"`
	StreamsReturns bool     `json:"streamsReturns,omitempty"`
	Options        []Option `json:"options,omitempty"`
}

// Option is a JSON representation of a proto option
type Option struct {
	Name                string           `json:"name,omitempty"`
	Constant            OptionLiteral    `json:"constant,omitempty"`
	IsEmbedded          bool             `json:"isEmbedded,omitempty"`
	AggregatedConstants []*OptionLiteral `json:"aggregatedConstants,omitempty"`
}

// OptionLiteral is a JSON representation of a proto option literal
type OptionLiteral struct {
	Name       string                   `json:"name,omitempty"`
	Source     string                   `json:"source,omitempty"`
	IsString   bool                     `json:"isString,omitempty"`
	QuoteRune  rune                     `json:"quoteRune,omitempty"`
	Array      []OptionLiteral          `json:"array,omitempty"`
	Map        map[string]OptionLiteral `json:"map,omitempty"`
	OrderedMap []OptionLiteral          `json:"orderedMap,omitempty"`
}

// newJSONProto creates a new JSONProto struct with default values for all fields
func newJSONProto() *JSONProto {
	return &JSONProto{
		Messages:    make(map[string]Message),
		Services:    make(map[string]Service),
		Imports:     make(map[string]Import),
		Options:     make([]Option, 0),
		Enum:        make(map[string]Enum),
		Syntax:      "",
		PackageName: "",
	}
}

// Convert converts a proto file to a JSONProto struct
func Convert(nodes *proto.Proto) *JSONProto {
	jproto := newJSONProto()
	for _, elem := range nodes.Elements {
		switch element := elem.(type) {
		case *proto.Message:
			jproto.Messages[element.Name] = jproto.convertMessage(element)

		case *proto.Service:
			jproto.convertService(element)

		case *proto.Package:
			jproto.PackageName = element.Name

		case *proto.Import:
			jproto.Imports[element.Filename] = Import{
				Kind: element.Kind,
			}

		case *proto.Option:
			jproto.Options = append(jproto.Options, jproto.convertSingleOption(element))

		case *proto.Enum:
			jproto.Enum[element.Name] = jproto.convertEnum(element)

		case *proto.Syntax:
			jproto.Syntax = element.Value
		}
	}

	return jproto
}

// convertMessage converts a proto message to a JSON message
func (j *JSONProto) convertMessage(n *proto.Message) Message {
	message := Message{
		Field:        make(map[string]*Field),
		Reserved:     make([]*Reserved, 0),
		OneOf:        make(map[string]OneOf),
		Enum:         make(map[string]Enum),
		Map:          make(map[string]*Map),
		InnerMessage: make(map[string]Message),
		Options:      make(map[string]Option),
	}

	for _, field := range n.Elements {
		switch field := field.(type) {
		case *proto.NormalField:
			message.Field[field.Name] = &Field{
				Type:     field.Type,
				Sequence: field.Sequence,
				Repeated: field.Repeated,
				Required: field.Required,
				Options:  j.convertOption(field.Options),
			}
		case *proto.Reserved:
			message.Reserved = append(message.Reserved, j.convertReserved(field))
		case *proto.Oneof:
			message.OneOf[field.Name] = j.convertOneOf(field)
		case *proto.Enum:
			message.Enum[field.Name] = j.convertEnum(field)
		case *proto.MapField:
			message.Map[field.Name] = &Map{
				Field: &Field{
					Type:     field.Type,
					Sequence: field.Sequence,
				},
				KeyType: field.KeyType,
			}
		case *proto.Message:
			message.InnerMessage[field.Name] = j.convertMessage(field)
		case *proto.Option:
			message.Options[field.Name] = j.convertSingleOption(field)
		}
		continue
	}

	return message
}

// convertEnum converts a proto enum to a JSON enum
func (j *JSONProto) convertEnum(n *proto.Enum) Enum {
	enum := Enum{
		Reserved:  make([]*Reserved, 0),
		EnumField: make(map[string]EnumValue),
		Options:   make(map[string]Option),
	}
	for _, elem := range n.Elements {
		switch elem := elem.(type) {
		case *proto.EnumField:
			enum.EnumField[elem.Name] = EnumValue{
				Value:   elem.Integer,
				Options: j.convertSingleOption(elem.ValueOption),
			}
		case *proto.Reserved:
			enum.Reserved = append(enum.Reserved, j.convertReserved(elem))
		case *proto.Option:
			enum.Options[elem.Name] = j.convertSingleOption(elem)
		}
		continue
	}
	return enum
}

// convertOneOf converts a proto oneof to a JSON oneof
func (j *JSONProto) convertOneOf(n *proto.Oneof) OneOf {
	oneof := OneOf{
		Field:   make(map[string]*Field),
		Options: make(map[string]Option),
	}
	for _, elem := range n.Elements {
		switch elem := elem.(type) {
		case *proto.OneOfField:
			oneof.Field[elem.Name] = &Field{
				Type:     elem.Type,
				Sequence: elem.Sequence,
				Options:  j.convertOption(elem.Options),
			}
		case *proto.Option:
			oneof.Options[elem.Name] = j.convertSingleOption(elem)
		}
		continue
	}
	return oneof
}

// convertReserved converts a proto reserved to a JSON reserved
func (j *JSONProto) convertReserved(n *proto.Reserved) *Reserved {
	return &Reserved{
		Ranges:     n.Ranges,
		FieldNames: n.FieldNames,
	}
}

// convertService converts a proto service to a JSON service
func (j *JSONProto) convertService(n *proto.Service) {
	service := Service{
		RPC:     make(map[string]RPC),
		Options: make(map[string]Option),
	}

	for _, rpc := range n.Elements {
		switch rpc := rpc.(type) {
		case *proto.RPC:
			service.RPC[rpc.Name] = j.convertRPC(rpc)
		case *proto.Option:
			service.Options[rpc.Name] = j.convertSingleOption(rpc)
		}
	}

	j.Services[n.Name] = service
}

// convertOption converts a proto option to a JSON option
func (j *JSONProto) convertOption(n []*proto.Option) []Option {
	if n == nil {
		return []Option{}
	}

	options := make([]Option, 0)
	for _, option := range n {
		options = append(options, Option{
			Name:       option.Name,
			Constant:   j.convertOptionLiteral(&option.Constant),
			IsEmbedded: option.IsEmbedded,
		})
	}
	return options
}

// convertRPC converts a proto rpc to a JSON rpc
func (j *JSONProto) convertRPC(n *proto.RPC) RPC {
	return RPC{
		RequestType:    n.RequestType,
		StreamsRequest: n.StreamsRequest,
		ReturnsType:    n.ReturnsType,
		StreamsReturns: n.StreamsReturns,
		Options:        j.convertOption(n.Options),
	}
}

// convertOptionLiteral converts a proto option literal to a JSON option literal
func (j *JSONProto) convertOptionLiteral(n *proto.Literal) OptionLiteral {
	return OptionLiteral{
		IsString:   n.IsString,
		Source:     n.Source,
		Name:       "",
		QuoteRune:  n.QuoteRune,
		Array:      j.getArrayLiteral(n.Array),
		Map:        j.getMapLiteral(n.Map),
		OrderedMap: j.getLiteralMap(n.OrderedMap),
	}
}

// convertOptionNamedLiteral converts a proto option named literal to a JSON option named literal
func (j *JSONProto) convertOptionNamedLiteral(n *proto.NamedLiteral) OptionLiteral {
	return OptionLiteral{
		IsString:   n.IsString,
		Source:     n.Source,
		Name:       n.Name,
		QuoteRune:  n.QuoteRune,
		Array:      j.getArrayLiteral(n.Array),
		Map:        j.getMapLiteral(n.Map),
		OrderedMap: j.getLiteralMap(n.OrderedMap),
	}
}

// convertSingleOption converts a proto option to a JSON option
func (j *JSONProto) convertSingleOption(n *proto.Option) Option {
	if n == nil {
		return Option{}
	}
	return Option{
		Name:       n.Name,
		Constant:   j.convertOptionLiteral(&n.Constant),
		IsEmbedded: n.IsEmbedded,
	}
}

// getArrayLiteral converts a proto array literal to a JSON array literal
func (j *JSONProto) getArrayLiteral(n []*proto.Literal) []OptionLiteral {
	array := make([]OptionLiteral, 0)
	for _, elem := range n {
		array = append(array, j.convertOptionLiteral(elem))
	}
	return array
}

// getMapLiteral converts a proto map literal to a JSON map literal
func (j *JSONProto) getMapLiteral(n map[string]*proto.Literal) map[string]OptionLiteral {
	returnMap := make(map[string]OptionLiteral)
	for key, value := range n {
		returnMap[key] = j.convertOptionLiteral(value)
	}
	return returnMap
}

// getLiteralMap converts a proto literal map to a JSON literal map
func (j *JSONProto) getLiteralMap(n proto.LiteralMap) []OptionLiteral {
	array := make([]OptionLiteral, 0)
	for _, elem := range n {
		array = append(array, j.convertOptionNamedLiteral(elem))
	}
	return array
}
