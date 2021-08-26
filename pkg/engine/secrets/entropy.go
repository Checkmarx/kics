package secrets

import (
	"math"
	"strings"
)

const (
	// EntropyRuleName - rule name
	EntropyRuleName = "High Entropy Token"
	// Base64EntropyThreashold - entropy threshold for base64
	Base64EntropyThreashold = 4.7
	// HexCharsEntropyThreashold - entropy threshold for hex
	HexCharsEntropyThreashold = 2.7
	// MinStringLen - minimum length of a string to be considered a secret
	MinStringLen = 20
	// HexType - hex type
	Base64Type = "base64"
	// Base64Chars - Base64 charset
	Base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
	// HexType - hex type
	HexType = "hex"
	// HexChars - Hex charset
	HexChars = "1234567890abcdefABCDEF"
)

// CalculateEntropy - calculates the entropy of a string based on the Shannon formula
func CalculateEntropy(token string, charSet string) float64 {
	if token == "" {
		return 0
	}
	charMap := map[rune]float64{}
	for _, char := range token {
		if strings.Contains(charSet, string(char)) {
			charMap[char]++
		}
	}

	var freq float64
	length := float64(len(token))
	for _, count := range charMap {
		freq += count * math.Log2(count)
	}

	return math.Log2(length) - freq/length
}

// GetHighEntropyTokens - returns a list of tokens that have a high entropy
func GetHighEntropyTokens(s, file string, line int) []RuleMatch {
	tokens := TokenizeString(s)
	ruleMatches := make([]RuleMatch, 0)
	for _, token := range tokens {
		if len(token) > MinStringLen {
			base64Entropy := CalculateEntropy(token, Base64Chars)
			hexEntropy := CalculateEntropy(token, HexChars)
			if base64Entropy > Base64EntropyThreashold || hexEntropy > HexCharsEntropyThreashold {
				highestEntropy := math.Max(base64Entropy, hexEntropy)

				ruleMatches = append(ruleMatches, RuleMatch{
					RuleName: EntropyRuleName,
					File:     file,
					Line:     line,
					Matches:  []string{token},
					Entropy:  highestEntropy,
				})
			}
		}
	}
	return ruleMatches
}

// TokenizeString - returns a list of tokens from a string
func TokenizeString(s string) []string {
	return strings.Fields(s)
}
