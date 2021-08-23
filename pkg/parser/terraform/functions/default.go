package functions

import (
	"encoding/base64"

	"github.com/zclconf/go-cty/cty"
	"github.com/zclconf/go-cty/cty/function"
	"github.com/zclconf/go-cty/cty/function/stdlib"
)

// Base64EncodeFunc - https://www.terraform.io/docs/language/functions/base64encode.html
var Base64EncodeFunc = function.New(&function.Spec{
	Params: []function.Parameter{
		{
			Name:             "val",
			Type:             cty.DynamicPseudoType,
			AllowDynamicType: true,
			AllowNull:        true,
		},
	},
	Type: function.StaticReturnType(cty.String),
	Impl: func(args []cty.Value, retType cty.Type) (cty.Value, error) {
		val := args[0]
		if !val.IsWhollyKnown() {
			// We can't serialize unknowns, so if the value is unknown or
			// contains any _nested_ unknowns then our result must be
			// unknown.
			return cty.UnknownVal(retType), nil
		}

		if val.IsNull() {
			return cty.StringVal("null"), nil
		}

		encoded := base64.StdEncoding.EncodeToString([]byte(val.AsString()))

		return cty.StringVal(encoded), nil
	},
})

// TerraformFuncs contains all functions, if KICS has to override a function
// it should create a file in this package and add/change this function key here
var TerraformFuncs = map[string]function.Function{
	"abs":             stdlib.AbsoluteFunc,
	"base64encode":    Base64EncodeFunc,
	"ceil":            stdlib.CeilFunc,
	"chomp":           stdlib.ChompFunc,
	"coalescelist":    stdlib.CoalesceListFunc,
	"compact":         stdlib.CompactFunc,
	"concat":          stdlib.ConcatFunc,
	"contains":        stdlib.ContainsFunc,
	"csvdecode":       stdlib.CSVDecodeFunc,
	"distinct":        stdlib.DistinctFunc,
	"element":         stdlib.ElementFunc,
	"chunklist":       stdlib.ChunklistFunc,
	"flatten":         stdlib.FlattenFunc,
	"floor":           stdlib.FloorFunc,
	"format":          stdlib.FormatFunc,
	"formatdate":      stdlib.FormatDateFunc,
	"formatlist":      stdlib.FormatListFunc,
	"indent":          stdlib.IndentFunc,
	"join":            stdlib.JoinFunc,
	"jsondecode":      stdlib.JSONDecodeFunc,
	"jsonencode":      stdlib.JSONEncodeFunc,
	"keys":            stdlib.KeysFunc,
	"log":             stdlib.LogFunc,
	"lower":           stdlib.LowerFunc,
	"max":             stdlib.MaxFunc,
	"merge":           stdlib.MergeFunc,
	"min":             stdlib.MinFunc,
	"parseint":        stdlib.ParseIntFunc,
	"pow":             stdlib.PowFunc,
	"range":           stdlib.RangeFunc,
	"regex":           stdlib.RegexFunc,
	"regexall":        stdlib.RegexAllFunc,
	"reverse":         stdlib.ReverseListFunc,
	"setintersection": stdlib.SetIntersectionFunc,
	"setproduct":      stdlib.SetProductFunc,
	"setsubtract":     stdlib.SetSubtractFunc,
	"setunion":        stdlib.SetUnionFunc,
	"signum":          stdlib.SignumFunc,
	"slice":           stdlib.SliceFunc,
	"sort":            stdlib.SortFunc,
	"split":           stdlib.SplitFunc,
	"strrev":          stdlib.ReverseFunc,
	"substr":          stdlib.SubstrFunc,
	"timeadd":         stdlib.TimeAddFunc,
	"title":           stdlib.TitleFunc,
	"trim":            stdlib.TrimFunc,
	"trimprefix":      stdlib.TrimPrefixFunc,
	"trimspace":       stdlib.TrimSpaceFunc,
	"trimsuffix":      stdlib.TrimSuffixFunc,
	"upper":           stdlib.UpperFunc,
	"values":          stdlib.ValuesFunc,
	"zipmap":          stdlib.ZipmapFunc,
}
