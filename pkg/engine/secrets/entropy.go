package secrets

import (
	"math"
	"strings"
)

/*
{
	"id": "00a180e1-138e-4127-9eb0-d3ed8fa23fa3",
	"queryName": "High Entropy String",
	"severity": "HIGH",
	"category": "Secret Management",
	"descriptionText": "Query to find high entropy strings that could be a secrets",
	"descriptionUrl": "https://kics.io/",
	"platform": "Common",
	"descriptionID": "2f8abf55",
	"cloudProvider": "common"
}
*/

const (
	EntropyRuleName           = "High Entropy Token"
	Base64EntropyThreashold   = 4.7
	HexCharsEntropyThreashold = 2.7
	MinStringLen              = 20
	Base64Type                = "base64"
	Base64Chars               = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
	HexType                   = "hex"
	HexChars                  = "1234567890abcdefABCDEF"
)

// CalculateEntropy - calculates the entropy of a string based on the Shannon formula
func CalculateEntropy(token, charSet string) float64 {
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
func GetHighEntropyTokens(s string) []RuleMatch {
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
