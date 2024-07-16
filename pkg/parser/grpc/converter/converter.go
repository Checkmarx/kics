package converter

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/emicklei/proto"
)

// JSONProto is a JSON representation of a proto file
type JSONProto struct {
	Syntax           string                      `json:"syntax"`
	PackageName      string                      `json:"package"`
	Messages         map[string]interface{}      `json:"messages"`
	Enum             map[string]interface{}      `json:"enum"`
	Services         map[string]interface{}      `json:"services"`
	Imports          map[string]interface{}      `json:"imports"`
	Options          []Option                    `json:"options"`
	Lines            map[string]model.LineObject `json:"_kics_lines"`
	linesToIgnore    []int                       `json:"-"`
	linesNotToIgnore []int                       `json:"-"`
}

// Service is a JSON representation of a proto service
type Service struct {
	RPC     map[string]RPC              `json:"rpc,omitempty"`
	Options map[string]Option           `json:"options,omitempty"`
	Lines   map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Message is a JSON representation of a proto message
type Message struct {
	Field        map[string]*Field           `json:"field,omitempty"`
	Reserved     []*Reserved                 `json:"reserved,omitempty"`
	OneOf        map[string]OneOf            `json:"oneof,omitempty"`
	Enum         map[string]Enum             `json:"enum,omitempty"`
	Map          map[string]*Map             `json:"map,omitempty"`
	InnerMessage map[string]Message          `json:"inner_message,omitempty"`
	Options      map[string]Option           `json:"options,omitempty"`
	Lines        map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Map is a JSON representation of a proto map
type Map struct {
	*Field  `json:"field,omitempty"`
	KeyType string                      `json:"key_type,omitempty"`
	Lines   map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// OneOf is a JSON representation of a proto oneof
type OneOf struct {
	Field   map[string]*Field           `json:"fields,omitempty"`
	Options map[string]Option           `json:"options,omitempty"`
	Lines   map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Enum is a JSON representation of a proto enum
type Enum struct {
	Reserved  []*Reserved                 `json:"reserved,omitempty"`
	EnumField map[string]EnumValue        `json:"field,omitempty"`
	Options   map[string]Option           `json:"options,omitempty"`
	Lines     map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// EnumValue is a JSON representation of a proto enum value
type EnumValue struct {
	Value   int                         `json:"value,omitempty"`
	Options Option                      `json:"options,omitempty"`
	Lines   map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Import is a JSON representation of a proto import
type Import struct {
	Kind  string                      `json:"kind,omitempty"`
	Lines map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Reserved is a JSON representation of a proto reserved
type Reserved struct {
	Ranges     []proto.Range               `json:"ranges,omitempty"`
	FieldNames []string                    `json:"fieldNames,omitempty"`
	Lines      map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Field is a JSON representation of a proto field
type Field struct {
	Type     string                      `json:"type,omitempty"`
	Sequence int                         `json:"sequence,omitempty"`
	Repeated bool                        `json:"repeated,omitempty"`
	Required bool                        `json:"required,omitempty"`
	Optional bool                        `json:"optional,omitempty"`
	Options  []Option                    `json:"options,omitempty"`
	Lines    map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// RPC is a JSON representation of a proto service RPC
type RPC struct {
	RequestType    string                      `json:"requestType,omitempty"`
	StreamsRequest bool                        `json:"streamsRequest,omitempty"`
	ReturnsType    string                      `json:"returnsType,omitempty"`
	StreamsReturns bool                        `json:"streamsReturns,omitempty"`
	Options        []Option                    `json:"options,omitempty"`
	Lines          map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// Option is a JSON representation of a proto option
type Option struct {
	Name                string                      `json:"name,omitempty"`
	Constant            OptionLiteral               `json:"constant,omitempty"`
	IsEmbedded          bool                        `json:"isEmbedded,omitempty"`
	AggregatedConstants []*OptionLiteral            `json:"aggregatedConstants,omitempty"`
	Lines               map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// OptionLiteral is a JSON representation of a proto option literal
type OptionLiteral struct {
	Name       string                      `json:"name,omitempty"`
	Source     string                      `json:"source,omitempty"`
	IsString   bool                        `json:"isString,omitempty"`
	QuoteRune  rune                        `json:"quoteRune,omitempty"`
	Array      []OptionLiteral             `json:"array,omitempty"`
	Map        map[string]OptionLiteral    `json:"map,omitempty"`
	OrderedMap []OptionLiteral             `json:"orderedMap,omitempty"`
	Lines      map[string]model.LineObject `json:"_kics_lines,omitempty"`
}

// newJSONProto creates a new JSONProto struct with default values for all fields
func newJSONProto() *JSONProto {
	return &JSONProto{
		Messages:      make(map[string]interface{}),
		Services:      make(map[string]interface{}),
		Imports:       make(map[string]interface{}),
		Options:       make([]Option, 0),
		Enum:          make(map[string]interface{}),
		Syntax:        "",
		PackageName:   "",
		Lines:         make(map[string]model.LineObject),
		linesToIgnore: make([]int, 0),
	}
}

const kicsLinesKey = "_kics_"

// Convert converts a proto file to a JSONProto struct
func Convert(nodes *proto.Proto) (file *JSONProto, linesIgnore []int) {
	jproto := newJSONProto()
	// handle panic during conversion process
	defer func() {
		if r := recover(); r != nil {
			errMessage := "Recovered from panic during conversion of JSONProto " + file.PackageName
			utils.HandlePanic(r, errMessage)
		}
	}()
	messageLines := make(map[string]model.LineObject)
	enumLines := make(map[string]model.LineObject)
	serviceLines := make(map[string]model.LineObject)
	importLines := make(map[string]model.LineObject)

	defaultArr := make([]map[string]*model.LineObject, 0)

	for _, elem := range nodes.Elements {
		switch element := elem.(type) {
		case *proto.Message:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.Messages[element.Name] = jproto.convertMessage(element)
			messageLines[kicsLinesKey+element.Name] = model.LineObject{
				Line: element.Position.Line,
				Arr:  make([]map[string]*model.LineObject, 0),
			}
		case *proto.Service:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.convertService(element)
			serviceLines[kicsLinesKey+element.Name] = model.LineObject{
				Line: element.Position.Line,
				Arr:  make([]map[string]*model.LineObject, 0),
			}
		case *proto.Package:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.PackageName = element.Name
			jproto.Lines["_kics_package"] = model.LineObject{
				Line: element.Position.Line,
			}
		case *proto.Import:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.Imports[element.Filename] = Import{
				Kind: element.Kind,
			}
			importLines[kicsLinesKey+element.Filename] = model.LineObject{
				Line: element.Position.Line,
				Arr:  make([]map[string]*model.LineObject, 0),
			}
		case *proto.Option:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.Options = append(jproto.Options, jproto.convertSingleOption(element))
			defaultArr = append(defaultArr, map[string]*model.LineObject{
				element.Name: {
					Line: element.Position.Line,
				},
			})
		case *proto.Enum:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.Enum[element.Name] = jproto.convertEnum(element)
			enumLines[kicsLinesKey+element.Name] = model.LineObject{
				Line: element.Position.Line,
				Arr:  make([]map[string]*model.LineObject, 0),
			}
		case *proto.Syntax:
			jproto.processCommentProto(element.Comment, element.Position.Line, element)
			jproto.Syntax = element.Value
			jproto.Lines["_kics_syntax"] = model.LineObject{
				Line: element.Position.Line,
			}
		}
	}

	// set line information
	jproto.Messages["_kics_lines"] = messageLines
	jproto.Enum["_kics_lines"] = enumLines
	jproto.Services["_kics_lines"] = serviceLines
	jproto.Imports["_kics_lines"] = importLines

	jproto.Lines["kics__default"] = model.LineObject{
		Line: 0,
		Arr:  defaultArr,
	}

	return jproto, model.RemoveDuplicates(jproto.linesToIgnore)
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
		Lines:        make(map[string]model.LineObject),
	}

	defaultArr := make([]map[string]*model.LineObject, 0)

	for _, field := range n.Elements {
		switch field := field.(type) {
		case *proto.NormalField:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.Lines[kicsLinesKey+field.Name] = model.LineObject{
				Line: field.Position.Line,
			}
			message.Field[field.Name] = &Field{
				Type:     field.Type,
				Sequence: field.Sequence,
				Repeated: field.Repeated,
				Required: field.Required,
				Options:  j.convertOption(field.Options),
				Lines: map[string]model.LineObject{
					"_kics__default": {Line: field.Position.Line},
				},
			}
		case *proto.Reserved:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.Reserved = append(message.Reserved, j.convertReserved(field))
			defaultArr = append(defaultArr, map[string]*model.LineObject{
				"Reserved": {
					Line: field.Position.Line,
				},
			})
		case *proto.Oneof:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.OneOf[field.Name] = j.convertOneOf(field)
			message.Lines[kicsLinesKey+field.Name] = model.LineObject{
				Line: field.Position.Line,
			}
		case *proto.Enum:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.Enum[field.Name] = j.convertEnum(field)
			message.Lines[kicsLinesKey+field.Name] = model.LineObject{
				Line: field.Position.Line,
			}
		case *proto.MapField:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.Map[field.Name] = &Map{
				Field: &Field{
					Type:     field.Type,
					Sequence: field.Sequence,
					Lines: map[string]model.LineObject{
						"_kics__default": {Line: field.Position.Line},
					},
				},
				KeyType: field.KeyType,
			}
			message.Lines[kicsLinesKey+field.Name] = model.LineObject{
				Line: field.Position.Line,
			}
		case *proto.Message:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.InnerMessage[field.Name] = j.convertMessage(field)
			message.Lines[kicsLinesKey+field.Name] = model.LineObject{
				Line: field.Position.Line,
			}
		case *proto.Option:
			j.processCommentProto(field.Comment, field.Position.Line, field)
			message.Options[field.Name] = j.convertSingleOption(field)
			message.Lines[kicsLinesKey+field.Name] = model.LineObject{
				Line: field.Position.Line,
			}
		}
		continue
	}

	message.Lines["_kics__default"] = model.LineObject{
		Line: n.Position.Line,
		Arr:  defaultArr,
	}

	return message
}

// convertEnum converts a proto enum to a JSON enum
func (j *JSONProto) convertEnum(n *proto.Enum) Enum {
	enum := Enum{
		Reserved:  make([]*Reserved, 0),
		EnumField: make(map[string]EnumValue),
		Options:   make(map[string]Option),
		Lines:     make(map[string]model.LineObject),
	}

	defaultArr := make([]map[string]*model.LineObject, 0)

	for _, elem := range n.Elements {
		switch elem := elem.(type) {
		case *proto.EnumField:
			j.processCommentProto(elem.Comment, elem.Position.Line, elem)
			enum.EnumField[elem.Name] = EnumValue{
				Value:   elem.Integer,
				Options: j.convertSingleOption(elem.ValueOption),
				Lines: map[string]model.LineObject{
					"_kics__default": {Line: elem.Position.Line},
				},
			}
			enum.Lines[kicsLinesKey+elem.Name] = model.LineObject{
				Line: elem.Position.Line,
			}
		case *proto.Reserved:
			j.processCommentProto(elem.Comment, elem.Position.Line, elem)
			enum.Reserved = append(enum.Reserved, j.convertReserved(elem))
			defaultArr = append(defaultArr, map[string]*model.LineObject{
				"Reserved": {
					Line: elem.Position.Line,
				},
			})
		case *proto.Option:
			j.processCommentProto(elem.Comment, elem.Position.Line, elem)
			enum.Options[elem.Name] = j.convertSingleOption(elem)
			enum.Lines[kicsLinesKey+elem.Name] = model.LineObject{
				Line: elem.Position.Line,
			}
		}
		continue
	}

	enum.Lines["_kics__default"] = model.LineObject{
		Line: n.Position.Line,
		Arr:  defaultArr,
	}

	return enum
}

// convertOneOf converts a proto oneof to a JSON oneof
func (j *JSONProto) convertOneOf(n *proto.Oneof) OneOf {
	oneof := OneOf{
		Field:   make(map[string]*Field),
		Options: make(map[string]Option),
		Lines:   make(map[string]model.LineObject),
	}
	oneof.Lines["_kics__default"] = model.LineObject{
		Line: n.Position.Line,
		Arr:  make([]map[string]*model.LineObject, 0),
	}
	for _, elem := range n.Elements {
		switch elem := elem.(type) {
		case *proto.OneOfField:
			j.processCommentProto(elem.Comment, elem.Position.Line, elem)
			oneof.Field[elem.Name] = &Field{
				Type:     elem.Type,
				Sequence: elem.Sequence,
				Options:  j.convertOption(elem.Options),
				Lines: map[string]model.LineObject{
					"_kics__default": {Line: elem.Position.Line},
				},
			}
			oneof.Lines[kicsLinesKey+elem.Name] = model.LineObject{
				Line: elem.Position.Line,
			}
		case *proto.Option:
			j.processCommentProto(elem.Comment, elem.Position.Line, elem)
			oneof.Options[elem.Name] = j.convertSingleOption(elem)
			oneof.Lines[kicsLinesKey+elem.Name] = model.LineObject{
				Line: elem.Position.Line,
			}
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
		Lines: map[string]model.LineObject{
			"_kics__default": {Line: n.Position.Line},
		},
	}
}

// convertService converts a proto service to a JSON service
func (j *JSONProto) convertService(n *proto.Service) {
	service := Service{
		RPC:     make(map[string]RPC),
		Options: make(map[string]Option),
		Lines:   make(map[string]model.LineObject),
	}

	service.Lines["_kics__default"] = model.LineObject{
		Line: n.Position.Line,
		Arr:  make([]map[string]*model.LineObject, 0),
	}

	for _, rpc := range n.Elements {
		switch rpc := rpc.(type) {
		case *proto.RPC:
			j.processCommentProto(rpc.Comment, rpc.Position.Line, rpc)
			service.RPC[rpc.Name] = j.convertRPC(rpc)
			service.Lines[kicsLinesKey+rpc.Name] = model.LineObject{
				Line: rpc.Position.Line,
			}
		case *proto.Option:
			j.processCommentProto(rpc.Comment, rpc.Position.Line, rpc)
			service.Options[rpc.Name] = j.convertSingleOption(rpc)
			service.Lines[kicsLinesKey+rpc.Name] = model.LineObject{
				Line: rpc.Position.Line,
			}
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
		j.processCommentProto(option.Comment, option.Position.Line, option)
		options = append(options, Option{
			Name:       option.Name,
			Constant:   j.convertOptionLiteral(&option.Constant),
			IsEmbedded: option.IsEmbedded,
			Lines: map[string]model.LineObject{
				"_kics__default": {Line: option.Position.Line},
			},
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
		Lines: map[string]model.LineObject{
			"_kics__default": {Line: n.Position.Line},
		},
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
		Lines: map[string]model.LineObject{
			"_kics__default": {Line: n.Position.Line},
		},
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
		Lines: map[string]model.LineObject{
			"_kics__default": {Line: n.Position.Line},
		},
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
		Lines: map[string]model.LineObject{
			"_kics__default": {Line: n.Position.Line},
		},
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

// processCommentProto gathers lines to ignore based on comment commands
func (j *JSONProto) processCommentProto(comment *proto.Comment, lineStart int, element interface{}) {
	// if comment is nil, return
	if comment == nil {
		j.linesNotToIgnore = append(j.linesNotToIgnore, lineStart)
		return
	}

	rangeToIgnore := model.Range(comment.Position.Line, comment.Position.Line+(len(comment.Lines)-1))

	// ignore lines that are comments
	linesToIgnore := j.ignoreComment(rangeToIgnore)
	j.linesToIgnore = append(j.linesToIgnore, linesToIgnore...)

	var value model.CommentCommand
	for _, line := range comment.Lines {
		comment := strings.ToLower(line)
		if model.KICSCommentRgxp.MatchString(comment) {
			comment = model.KICSCommentRgxp.ReplaceAllString(comment, "")
			comment = strings.Trim(comment, "\n")
			commands := strings.Split(strings.Trim(comment, "\r"), " ")
			value = model.ProcessCommands(commands)
		}
		continue
	}

	lineEnd := getLastElementLine(element, lineStart)
	switch value {
	case model.IgnoreLine:
		j.linesToIgnore = append(j.linesToIgnore, lineStart)
	case model.IgnoreBlock:
		j.linesToIgnore = append(j.linesToIgnore, model.Range(lineStart, lineEnd)...)
	default:
		break
	}
}

// ignoreComment returns a slice of lines to ignore with inline comments removed
func (j *JSONProto) ignoreComment(values []int) []int {
	linesToIgnore := make([]int, 0)
	for _, value := range values {
		if isInSlice(value, j.linesNotToIgnore) {
			continue
		}
		linesToIgnore = append(linesToIgnore, value)
	}
	return linesToIgnore
}

// isInSlice checks if a value is in a slice
func isInSlice(value int, slice []int) bool {
	for _, v := range slice {
		if v == value {
			return true
		}
	}
	return false
}

// getLastElementLine returns the last line of an element block
func getLastElementLine(v interface{}, parentLine int) int {
	position := 0
	switch t := v.(type) {
	// case proto.Proto:
	// 	position = getLastElement(t.Elements[len(t.Elements)-1], t.Position.Line)
	case *proto.Message:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	case *proto.Service:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	case *proto.EnumField:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	case *proto.Enum:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	case *proto.Oneof:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	case *proto.RPC:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	case *proto.Group:
		if len(t.Elements) > 0 {
			position = getLastElementLine(t.Elements[len(t.Elements)-1], t.Position.Line)
		}
	default:
		position = setElementLine(v, parentLine)
	}
	return position
}

// setElementLine sets the last line of an element block
func setElementLine(v interface{}, parentLine int) int {
	position := 0
	switch t := v.(type) {
	case *proto.Syntax:
		position = t.Position.Line
	case *proto.Package:
		position = t.Position.Line
	case *proto.Import:
		position = t.Position.Line
	case *proto.NormalField:
		position = t.Position.Line
	case *proto.Comment:
		position = t.Position.Line
	case *proto.OneOfField:
		position = t.Position.Line
	case *proto.Reserved:
		position = t.Position.Line
	case *proto.MapField:
		position = t.Position.Line
	case *proto.Extensions:
		position = t.Position.Line
	default:
		position = parentLine
	}
	return position
}
