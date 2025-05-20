package tag

import (
	"bytes"
	"errors"
	"fmt"
	"strconv"
	"strings"
	"text/scanner"
)

const (
	base      = 10
	bitSize64 = 64
)

// Tag contains the tag name reference and its attributes
type Tag struct {
	Name       string
	Attributes map[string]interface{}
}

// Parse tag from following structure
// name1:"expected=private,test=false" name2:"attr=1"
func Parse(s string, supportedNames []string) ([]Tag, error) {
	s = strings.TrimLeft(strings.TrimLeft(strings.TrimSpace(s), "/"), " ")
	var tags []Tag
	for _, si := range strings.Split(s, " ") {
		cleanSi := strings.TrimSpace(si)
		if cleanSi == "" {
			continue
		}

		for _, supportedName := range supportedNames {
			if !strings.HasPrefix(cleanSi, supportedName) {
				continue
			}

			tag, err := parseTag(cleanSi, supportedName)
			if err != nil {
				return nil, err
			}

			tags = append(tags, tag)
		}
	}

	return tags, nil
}

func parseTag(s, name string) (Tag, error) {
	t := Tag{
		Name:       name,
		Attributes: make(map[string]interface{}),
	}

	attributePart := strings.TrimPrefix(s, name)
	attributePart = strings.TrimPrefix(attributePart, ":")
	attributePart = strings.TrimPrefix(attributePart, "\"")
	attributePart = strings.TrimSuffix(attributePart, "\"")

	if attributePart == "" {
		return t, nil
	}

	sc := &scanner.Scanner{}
	sc.Mode = scanner.ScanIdents | scanner.ScanInts | scanner.ScanFloats | scanner.ScanStrings
	sc.Init(strings.NewReader(attributePart))

	for {
		tok := sc.Scan()
		switch tok {
		case scanner.EOF:
			return t, nil
		case scanner.Ident:
			ident := sc.TokenText()
			switch sc.Peek() {
			case '=':
				sc.Next()
				value, err := parseValue(sc)
				if err != nil {
					return Tag{}, err
				}
				t.Attributes[ident] = value
			case '[':
				sc.Next()
				arg, err := parseArgs(sc)
				if err != nil {
					return Tag{}, err
				}
				t.Attributes[ident] = arg
			case ',':
				sc.Next()
				t.Attributes[ident] = nil
			case scanner.EOF:
				t.Attributes[ident] = nil
			}
		case ',':
			// NOP
		default:
			return Tag{}, fmt.Errorf("invalid token: %s", sc.TokenText())
		}
	}
}

func parseArray(sc *scanner.Scanner) ([]interface{}, error) {
	var result []interface{}
	for {
		value, err := parseValue(sc)
		if err != nil {
			return result, err
		}
		result = append(result, value)
		next := sc.Next()
		if next == ']' {
			return result, nil
		}
		if next == ',' {
			continue
		}
		return result, fmt.Errorf(", expected but got %s", string(next))
	}
}

func parseValue(sc *scanner.Scanner) (interface{}, error) {
	switch sc.Peek() {
	case '\'':
		sc.Next()
		return parseString(sc)
	case '*':
		r := sc.Next()
		return string(r), nil
	case '<', '>':
		r := sc.Next()
		if sc.Peek() == '=' {
			sc.Next()
			return string(r) + "=", nil
		}
		return string(r), nil
	case '!':
		sc.Next()
		if sc.Peek() == '=' {
			sc.Next()
			return "!=", nil
		}
		return nil, fmt.Errorf("invalid value: %s", sc.TokenText())
	case '[':
		sc.Next()
		return parseArray(sc)
	default:
		tok := sc.Scan()
		text := sc.TokenText()

		switch tok {
		case scanner.Ident:
			return checkType(text), nil

		case scanner.String:
			return text[1 : len(text)-1], nil

		case scanner.Int:
			return strconv.ParseInt(text, base, bitSize64)

		case scanner.Float:
			return strconv.ParseFloat(text, bitSize64)

		default:
			return nil, fmt.Errorf("invalid value: %s", text)
		}
	}
}

func parseArgs(sc *scanner.Scanner) (map[string]interface{}, error) {
	result := map[string]interface{}{}
	for {
		tok := sc.Scan()
		if tok != scanner.Ident {
			return result, fmt.Errorf("invalid attribute name: %s", sc.TokenText())
		}
		name := sc.TokenText()
		eq := sc.Next()
		if eq != '=' {
			return result, fmt.Errorf("= expected but got %s", string(eq))
		}
		value, err := parseValue(sc)
		if err != nil {
			return result, err
		}
		result[name] = value
		next := sc.Next()
		if next == ']' {
			return result, nil
		}
		if next == ',' {
			continue
		}
		return result, fmt.Errorf(") or , expected but got %s", string(next))
	}
}

func parseString(sc *scanner.Scanner) (string, error) {
	var buf bytes.Buffer
	ch := sc.Next()
	for ch != '\'' {
		if ch == '\n' || ch == '\r' || ch < 0 {
			return "", errors.New("unterminated string")
		}
		if ch == '\\' {
			s, err := parseEscape(sc)
			if err != nil {
				return "", err
			}
			buf.WriteString(s)
		} else {
			buf.WriteRune(ch)
		}
		ch = sc.Next()
	}
	return buf.String(), nil
}

func parseEscape(sc *scanner.Scanner) (string, error) {
	ch := sc.Next()
	switch ch {
	case 'a':
		return "\a", nil
	case 'b':
		return "\b", nil
	case 'f':
		return "\f", nil
	case 'n':
		return "\n", nil
	case 'r':
		return "\r", nil
	case 't':
		return "\t", nil
	case 'v':
		return "\v", nil
	case '\\':
		return "\\", nil
	case '"':
		return "\"", nil
	case '\'':
		return "'", nil
	}
	return "", fmt.Errorf("invalid escape sequence: %s", string(ch))
}

func checkType(s string) interface{} {
	switch s {
	case "true", "TRUE":
		return true
	case "false", "FALSE":
		return false
	default:
		if i, err := strconv.ParseInt(s, base, bitSize64); err == nil {
			return i
		}
		if f, err := strconv.ParseFloat(s, bitSize64); err == nil {
			return f
		}

		return s
	}
}
