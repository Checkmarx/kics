package json

import (
	"bytes"
	"encoding/json"
)

var (
	// EmptyStringBytes is a byte slice containing an empty JSON string.
	EmptyStringBytes = []byte(`""`)

	// NullBytes is a byte slice containing the JSON null literal.
	NullBytes = []byte("null")
)

// NewPtr returns a pointer of t.
func NewPtr[T any](t T) *T {
	return &t
}

// Null returns a null Nullable.
func Null[T any]() Nullable[T] {
	return Nullable[T]{
		isNull: true,
	}
}

// OptionalNull returns a pointer to a null Nullable.
func OptionalNull[T any]() *Nullable[T] {
	return &Nullable[T]{
		isNull: true,
	}
}

// New returns a new Nullable with t as the value.
func New[T any](t T) Nullable[T] {
	return Nullable[T]{
		value:  t,
		isNull: false,
	}
}

// NewOptional returns a pointer to a new Nullable with t as the value.
func NewOptional[T any](t T) *Nullable[T] {
	return &Nullable[T]{
		value:  t,
		isNull: false,
	}
}

// Nullable represents a nullable value.
// It gets serialized as either null or the value.
type Nullable[T any] struct {
	value  T
	isNull bool
}

// MarshalJSON implements the Marshaler interface.
func (n Nullable[T]) MarshalJSON() ([]byte, error) {
	if n.isNull {
		return NullBytes, nil
	}
	return json.Marshal(n.value)
}

// UnmarshalJSON implements the Unmarshaler interface.
func (n *Nullable[T]) UnmarshalJSON(data []byte) error {
	if bytes.Equal(data, NullBytes) {
		n.isNull = true
		return nil
	}
	return json.Unmarshal(data, &n.value)
}

// Value returns the value of the Nullable.
// If the Nullable is null, it returns the zero value of T.
func (n Nullable[T]) Value() T {
	return n.value
}

// IsNull returns true if the Nullable is null.
func (n Nullable[T]) IsNull() bool {
	return n.isNull
}
