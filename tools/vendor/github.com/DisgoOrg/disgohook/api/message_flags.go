package api

// The MessageFlags of a Message
type MessageFlags int64

// Constants for MessageFlags
const (
	MessageFlagCrossposted MessageFlags = 1 << iota
	MessageFlagIsCrosspost
	MessageFlagSuppressEmbeds
	MessageFlagSourceMessageDeleted
	MessageFlagUrgent
	_
	MessageFlagEphemeral
	MessageFlagLoading              // Message is an interaction of type 5, awaiting further response
	MessageFlagNone    MessageFlags = 0
)

// Add allows you to add multiple bits together, producing a new bit
func (f MessageFlags) Add(bits ...MessageFlags) MessageFlags {
	total := MessageFlags(0)
	for _, bit := range bits {
		total |= bit
	}
	f |= total
	return f
}

// Remove allows you to subtract multiple bits from the first, producing a new bit
func (f MessageFlags) Remove(bits ...MessageFlags) MessageFlags {
	total := MessageFlags(0)
	for _, bit := range bits {
		total |= bit
	}
	f &^= total
	return f
}

// HasAll will ensure that the bit includes all of the bits entered
func (f MessageFlags) HasAll(bits ...MessageFlags) bool {
	for _, bit := range bits {
		if !f.Has(bit) {
			return false
		}
	}
	return true
}

// Has will check whether the Bit contains another bit
func (f MessageFlags) Has(bit MessageFlags) bool {
	return (f & bit) == bit
}

// MissingAny will check whether the bit is missing any one of the bits
func (f MessageFlags) MissingAny(bits ...MessageFlags) bool {
	for _, bit := range bits {
		if !f.Has(bit) {
			return true
		}
	}
	return false
}

// Missing will do the inverse of Bit.Has
func (f MessageFlags) Missing(bit MessageFlags) bool {
	return !f.Has(bit)
}
