package secrets

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestEntropyInterval(t *testing.T) {
	inputs := []struct {
		entropy Entropy
		token   string
		want    bool
	}{
		{
			entropy: Entropy{
				Group: 0, // not relevant for this test
				Min:   0,
				Max:   0,
			},
			token: "",
			want:  false,
		},
		{
			entropy: Entropy{
				Group: 0,
				Min:   1,
				Max:   2, // 3.655152
			},
			token: "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0",
			want:  false,
		},
		{
			entropy: Entropy{
				Group: 0,
				Min:   1,
				Max:   3.7,
			},
			token: "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0",
			want:  true,
		},
		{
			entropy: Entropy{
				Group: 0,
				Min:   3, // 2.321928
				Max:   4,
			},
			token: "passx",
			want:  false,
		},
		{
			entropy: Entropy{
				Group: 0,
				Min:   2, // 2.321928
				Max:   3,
			},
			token: "passx", // min length is >5
			want:  false,
		},
		{
			entropy: Entropy{
				Group: 0,
				Min:   2, // 2.321928
				Max:   3,
			},
			token: "passxx", // min length is >5
			want:  true,
		},
	}
	for _, in := range inputs {
		highEntropy, entropyValue := CheckEntropyInterval(in.entropy, in.token)
		require.Equal(t, in.want, highEntropy, "CheckEntropyInterval(%+v, %s) = %v, want %v :: entropyValue %v", in.entropy, in.token, highEntropy, in.want, entropyValue)
	}
}
