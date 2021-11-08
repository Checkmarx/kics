package model

import (
	"testing"

	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

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
			want: []int{2, 1, 3, 4, 5, 6, 7, 8, 9},
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
							HeadComment: "# kics ignore-block",
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
							HeadComment: "# kics ignore-line",
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
			want: []int{},
			args: args{
				&yaml.Node{
					Kind: yaml.MappingNode,
					Content: []*yaml.Node{
						{
							Kind:        yaml.ScalarNode,
							HeadComment: "# kics regular comment",
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
			want: []int{1, 0, 2, 3, 4, 5, 6, 7, 8, 9},
			args: args{
				&yaml.Node{
					Kind:        yaml.MappingNode,
					HeadComment: "# kics ignore-block",
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
			want: []int{5, 4, 6, 7, 8, 9},
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
							HeadComment: "# kics ignore-block",
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
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ignoreCommentsYAML(tt.args.node)
			require.Equal(t, tt.want, NewIgnore.GetLines())
			NewIgnore.Reset()
		})
	}
}
