package secrets

// RuleMatch - represents a secrets rule match
type RuleMatch struct {
	File     string
	RuleName string
	Matches  []string
	Line     int
	Entropy  float64
}
