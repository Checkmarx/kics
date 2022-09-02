// Package json provides configurable interfaces for JSON encoding and decoding.
package json

import "encoding/json"

var (
	// Marshal marshals the given value into a JSON string.
	Marshal = json.Marshal

	// Unmarshal unmarshals the given JSON string into v.
	Unmarshal = json.Unmarshal

	// MarshalIndent marshals the given value into a JSON string with indentation.
	MarshalIndent = json.MarshalIndent

	// Indent is the indentation used in MarshalIndent.
	Indent = json.Indent

	// NewEncoder returns a new JSON encoder that writes to w.
	NewEncoder = json.NewEncoder

	// NewDecoder returns a new JSON decoder that reads from r.
	NewDecoder = json.NewDecoder
)

type (
	// RawMessage is a raw encoded JSON value.
	RawMessage = json.RawMessage

	// Marshaler is the interface implemented by types that can marshal JSON.
	Marshaler = json.Marshaler

	// Unmarshaler is the interface implemented by types that can unmarshal a JSON description of themselves.
	Unmarshaler = json.Unmarshaler
)
