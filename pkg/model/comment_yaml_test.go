package model

import (
	"sort"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

// Test_ignoreCommentsYAML tests the YAML marshalling of the ignoreComments type.
func Test_ignoreCommentsYAML(t *testing.T) {
	type args struct {
		node *yaml.Node
	}
	tests := []struct {
		name string
		args args
		want []int
	}{
		{
			name: "test_1: ignore-block",
			want: []int{1, 2, 3, 4, 5, 6, 7, 8, 9},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:  yaml.ScalarNode,
							Value: "key",
							Line:  1,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "false",
							Tag:   "!!bool",
						},
						{
							Kind:        yaml.ScalarNode,
							HeadComment: "# kics-scan ignore-block",
							Value:       "key_object",
							Line:        2,
						},
						{
							Kind: yaml.MappingNode,
							Content: []*yaml.Node{
								{
									Kind:  yaml.ScalarNode,
									Value: "null_object",
									Line:  3,
								},
								{
									Kind: yaml.ScalarNode,
									Tag:  "!!null",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "int_object",
									Line:  4,
								},
								{
									Kind:  yaml.ScalarNode,
									Tag:   "!!int",
									Value: "24",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "seq_object",
									Line:  5,
								},
								{
									Kind: yaml.SequenceNode,
									Content: []*yaml.Node{
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq",
													Line:  6,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq_2",
													Line:  7,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val_2",
													Tag:   " !!str",
												},
											},
										},
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key",
													Line:  8,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key_2",
													Line:  9,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val_2",
													Tag:   " !!str",
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		{
			name: "test_2: ignore-line",
			want: []int{0, 1},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:        yaml.ScalarNode,
							HeadComment: "# kics-scan ignore-line",
							Value:       "key",
							Line:        1,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "false",
							Tag:   "!!bool",
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "key_object",
							Line:  2,
						},
						{
							Kind: yaml.MappingNode,
							Content: []*yaml.Node{
								{
									Kind:  yaml.ScalarNode,
									Value: "null_object",
									Line:  3,
								},
								{
									Kind: yaml.ScalarNode,
									Tag:  "!!null",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "int_object",
									Line:  4,
								},
								{
									Kind:  yaml.ScalarNode,
									Tag:   "!!int",
									Value: "24",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "seq_object",
									Line:  5,
								},
								{
									Kind: yaml.SequenceNode,
									Content: []*yaml.Node{
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq",
													Line:  6,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq_2",
													Line:  7,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val_2",
													Tag:   " !!str",
												},
											},
										},
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key",
													Line:  8,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key_2",
													Line:  9,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val_2",
													Tag:   " !!str",
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		{
			name: "test_3: regular-comment",
			want: []int{0},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:        yaml.ScalarNode,
							HeadComment: "# kics-scan regular comment",
							Value:       "key",
							Line:        1,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "false",
							Tag:   "!!bool",
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "key_object",
							Line:  2,
						},
						{
							Kind: yaml.MappingNode,
							Content: []*yaml.Node{
								{
									Kind:  yaml.ScalarNode,
									Value: "null_object",
									Line:  3,
								},
								{
									Kind: yaml.ScalarNode,
									Tag:  "!!null",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "int_object",
									Line:  4,
								},
								{
									Kind:  yaml.ScalarNode,
									Tag:   "!!int",
									Value: "24",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "seq_object",
									Line:  5,
								},
								{
									Kind: yaml.SequenceNode,
									Content: []*yaml.Node{
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq",
													Line:  6,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq_2",
													Line:  7,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val_2",
													Tag:   " !!str",
												},
											},
										},
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key",
													Line:  8,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key_2",
													Line:  9,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val_2",
													Tag:   " !!str",
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		{
			name: "test_4: ignore-all",
			want: []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
			args: args{
				&yaml.Node{
					Kind:        yaml.MappingNode,
					HeadComment: "# kics-scan ignore-block",
					Content: []*yaml.Node{
						{
							Kind:  yaml.ScalarNode,
							Value: "key",
							Line:  1,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "false",
							Tag:   "!!bool",
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "key_object",
							Line:  2,
						},
						{
							Kind: yaml.MappingNode,
							Content: []*yaml.Node{
								{
									Kind:  yaml.ScalarNode,
									Value: "null_object",
									Line:  3,
								},
								{
									Kind: yaml.ScalarNode,
									Tag:  "!!null",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "int_object",
									Line:  4,
								},
								{
									Kind:  yaml.ScalarNode,
									Tag:   "!!int",
									Value: "24",
								},
								{
									Kind:  yaml.ScalarNode,
									Value: "seq_object",
									Line:  5,
								},
								{
									Kind: yaml.SequenceNode,
									Content: []*yaml.Node{
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq",
													Line:  6,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_seq_2",
													Line:  7,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "key_val_2",
													Tag:   " !!str",
												},
											},
										},
										{
											Kind: yaml.MappingNode,
											Content: []*yaml.Node{
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key",
													Line:  8,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val",
													Tag:   " !!str",
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_key_2",
													Line:  9,
												},
												{
													Kind:  yaml.ScalarNode,
													Value: "second_val_2",
													Tag:   " !!str",
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
		{
			name: "test_5: ignore-seq",
			want: []int{4, 5, 6, 7, 8, 9},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:  yaml.ScalarNode,
							Value: "key",
							Line:  1,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "false",
							Tag:   "!!bool",
						},
						{
							Kind:        yaml.ScalarNode,
							HeadComment: "# kics-scan ignore-block",
							Value:       "seq_object",
							Line:        5,
						},
						{
							Kind: yaml.SequenceNode,
							Line: 6,
							Content: []*yaml.Node{
								{
									Kind: yaml.MappingNode,
									Line: 6,
									Content: []*yaml.Node{
										{
											Kind:  yaml.ScalarNode,
											Value: "key_seq",
											Line:  6,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "key_val",
											Tag:   " !!str",
											Line:  6,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "key_seq_2",
											Line:  7,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "key_val_2",
											Tag:   " !!str",
											Line:  7,
										},
									},
								},
								{
									Kind: yaml.MappingNode,
									Content: []*yaml.Node{
										{
											Kind:  yaml.ScalarNode,
											Value: "second_key",
											Line:  8,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "second_val",
											Tag:   " !!str",
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "second_key_2",
											Line:  9,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "second_val_2",
											Tag:   " !!str",
										},
									},
								},
							},
						},
					},
				},
			},
		},
		{
			name: "test_6: ignore_multiple_#",
			want: []int{2, 3, 4},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:  yaml.ScalarNode,
							Value: "key",
							Line:  1,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "false",
							Tag:   "!!bool",
						},
						{
							Kind:        yaml.ScalarNode,
							HeadComment: "################################\n#####      SomeTitle       #####\n################################",
							Value:       "seq_object",
							Line:        5,
						},
						{
							Kind: yaml.SequenceNode,
							Line: 6,
							Content: []*yaml.Node{
								{
									Kind: yaml.MappingNode,
									Line: 6,
									Content: []*yaml.Node{
										{
											Kind:  yaml.ScalarNode,
											Value: "key_seq",
											Line:  6,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "key_val",
											Tag:   " !!str",
											Line:  6,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "key_seq_2",
											Line:  7,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "key_val_2",
											Tag:   " !!str",
											Line:  7,
										},
									},
								},
								{
									Kind: yaml.MappingNode,
									Content: []*yaml.Node{
										{
											Kind:  yaml.ScalarNode,
											Value: "second_key",
											Line:  8,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "second_val",
											Tag:   " !!str",
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "second_key_2",
											Line:  9,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "second_val_2",
											Tag:   " !!str",
										},
									},
								},
							},
						},
					},
				},
			},
		},
		{
			name: "test_7: ignore_multiline_string",
			want: []int{4, 5, 6, 7, 8, 9},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:        yaml.ScalarNode,
							Value:       "deploy.yml",
							HeadComment: "# kics-scan ignore-block",
							Line:        5,
							Column:      3,
						},
						{
							Kind:   yaml.ScalarNode,
							Value:  "---\nfoo\n  bar: abc\nuploader-token: my-awesome-token\n",
							Line:   5,
							Column: 15,
						},
					},
				},
			},
		},
		{
			name: "test_8: ignore_doublefootcomment_string",
			want: []int{1, 5},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:        yaml.ScalarNode,
							Value:       "stage",
							FootComment: "################# This is a Foot Comment ###########################",
							Line:        2,
							Column:      3,
						},
						{
							Kind:        yaml.ScalarNode,
							Value:       "Build",
							FootComment: "#this is another foot comment for the same line",
							Line:        2,
							Column:      10,
						},
						{
							Kind:  yaml.ScalarNode,
							Value: "jobs",
							Line:  3,
						},
						{
							Kind:  yaml.SequenceNode,
							Value: "",
							Line:  4,
							Tag:   "!!seq",
							Content: []*yaml.Node{
								{
									Kind: yaml.MappingNode,
									Tag:  "!!map",
									Content: []*yaml.Node{
										{
											Kind:  yaml.ScalarNode,
											Value: "template",
											Line:  5,
										},
										{
											Kind:  yaml.ScalarNode,
											Value: "/Pipeline/Build.yml",
											Line:  5,
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ignoreCommentsYAML(tt.args.node)
			ignoreLines := NewIgnore.GetLines()
			NewIgnore.Reset()
			if len(ignoreLines) > 0 {
				sort.Ints(ignoreLines)
			}
			require.Equal(t, tt.want, ignoreLines)
		})
	}
}

func Test_value(t *testing.T) {
	tests := []struct {
		name  string
		input comment
		want  string
	}{
		{
			name:  "Should return ignore-block",
			input: comment("# source: test/templates/deployment.yaml\n# kics-scan ignore-block\n# kics_helm_id_2:"),
			want:  "ignore-block",
		},
		{
			name:  "Should Not return ignore-block",
			input: comment("# source: test/templates/deployment.yaml\n# kics ignore-block\n# kics_helm_id_2:"),
			want:  "# source: test/templates/deployment.yaml\n# kics ignore-block\n# kics_helm_id_2:",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			res := tt.input.value()
			assert.Equal(t, string(res), tt.want)
		})
	}
}
