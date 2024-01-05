package json

import (
	"encoding/json"
	"testing"

	"github.com/stretchr/testify/require"
)

type args struct {
	doc []byte
}

var testsinitiateJSONLine = []struct {
	name         string
	args         args
	want         string
	wantKicsLine string
}{
	{
		name: "test array of ints",
		args: args{
			doc: []byte(`{
					"father": {
						"son" : [
							1,
							2,
							3,
							0
						]
					}
				}
				`),
		},
		want: `{
				"LineInfo": {
				  "0": {
					".father.son": {
					  "Value": [
						7
					  ]
					}
				  },
				  "1": {
					".father.son": {
					  "Value": [
						4
					  ]
					}
				  },
				  "2": {
					".father.son": {
					  "Value": [
						5
					  ]
					}
				  },
				  "3": {
					".father.son": {
					  "Value": [
						6
					  ]
					}
				  },
				  "father": {
					"": {
					  "Value": [
						2
					  ]
					}
				  },
				  "son": {
					".father": {
					  "Value": [
						3
					  ]
					}
				  }
				}
			  }
			  `,
		wantKicsLine: `{
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 0
				  },
				  "_kics_father": {
					"_kics_line": 2
				  }
				},
				"father": {
				  "_kics_lines": {
					"_kics__default": {
					  "_kics_line": 2
					},
					"_kics_son": {
					  "_kics_arr": [
						{
						  "_kics__default": {
							"_kics_line": 4
						  }
						},
						{
						  "_kics__default": {
							"_kics_line": 5
						  }
						},
						{
						  "_kics__default": {
							"_kics_line": 6
						  }
						},
						{
						  "_kics__default": {
							"_kics_line": 7
						  }
						}
					  ],
					  "_kics_line": 3
					}
				  },
				  "son": [
					1,
					2,
					3,
					0
				  ]
				}
			  }`,
	},
	{
		name: "test array objects line",
		args: args{
			doc: []byte(`{
					"father": [
						{
							"key": "value"
						}
					]
				}
				`),
		},
		wantKicsLine: `
			{
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 0
				  },
				  "_kics_father": {
					"_kics_arr": [
					  {
						"_kics__default": {
						  "_kics_line": 4
						},
						"_kics_key": {
						  "_kics_line": 4
						}
					  }
					],
					"_kics_line": 2
				  }
				},
				"father": [
				  {
					"key": "value"
				  }
				]
			  }
			  `,
		want: `
			{
				"LineInfo": {
				  "father": {
					"": {
					  "Value": [
						2
					  ]
					}
				  },
				  "key": {
					".father": {
					  "Value": [
						4
					  ]
					}
				  },
				  "value": {
					".father": {
					  "Value": [
						4
					  ]
					}
				  }
				}
			  }
			`,
	},
	{
		name: "test initiate json line",
		args: args{
			doc: []byte(`{
					"parameters": "simple test"
				}
				`),
		},
		wantKicsLine: `
			{
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 0
					},
					"_kics_parameters": {
						"_kics_line": 2
					}
				},
				"parameters":"simple test"
			}`,
		want: `
			{
				"LineInfo": {
					"parameters": {
						"": {
							"Value": [
								2
							]
						}
					},
					"simple test": {
						"": {
						"Value": [
								2
							]
						}
					}
				}
			}
			`,
	},
	{
		name: "test initiate special close json line",
		args: args{
			doc: []byte(`{
					"father": {
						"close": [
							"value"
						]
					}
				}
				`),
		},
		wantKicsLine: `
			{
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 0
				  },
				  "_kics_father": {
					"_kics_line": 2
				  }
				},
				"father": {
				  "_kics_lines": {
					"_kics__default": {
					  "_kics_line": 2
					},
					"_kics_close": {
					  "_kics_arr": [
						{
						  "_kics__default": {
							"_kics_line": 4
						  }
						}
					  ],
					  "_kics_line": 3
					}
				  },
				  "close": [
					"value"
				  ]
				}
			  }
			  `,
		want: `
			{
				"LineInfo": {
				  "close": {
					".father": {
					  "Value": [
						3
					  ]
					}
				  },
				  "father": {
					"": {
					  "Value": [
						2
					  ]
					}
				  },
				  "value": {
					".father.close": {
					  "Value": [
						4
					  ]
					}
				  }
				}
			  }
			`,
	},
	{
		name: "test same key different path json line",
		args: args{
			doc: []byte(`{
					"father1": {
						"key": "value"
					},
					"father2": {
						"key": "value"
					}
				}
				`),
		},
		wantKicsLine: `{
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 0
				  },
				  "_kics_father1": {
					"_kics_line": 2
				  },
				  "_kics_father2": {
					"_kics_line": 5
				  }
				},
				"father1": {
				  "_kics_lines": {
					"_kics__default": {
					  "_kics_line": 2
					},
					"_kics_key": {
					  "_kics_line": 3
					}
				  },
				  "key": "value"
				},
				"father2": {
				  "_kics_lines": {
					"_kics__default": {
					  "_kics_line": 5
					},
					"_kics_key": {
					  "_kics_line": 6
					}
				  },
				  "key": "value"
				}
			  }`,
		want: `
			{
				"LineInfo": {
					"father1": {
						"": {
							"Value": [
								2
							]
						}
					},
					"father2": {
						"": {
							"Value": [
								5
							]
						}
					},
					"key": {
						".father1": {
							"Value": [
								3
							]
						},
						".father2": {
							"Value": [
								6
							]
						}
					},
					"value": {
						".father1": {
							"Value": [
								3
							]
						},
						".father2": {
							"Value": [
								6
							]
						}
					}
				}
			}`,
	},
	{
		name: "test with parent json line",
		args: args{
			doc: []byte(`{
				"father": {
					"son": "this is a son"
				}
			}
			`),
		},
		wantKicsLine: `
			{
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 0
					},
					"_kics_father":{
						"_kics_line": 2
					}
				},
				"father": {
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 2
						},
						"_kics_son": {
							"_kics_line": 3
						}
					},
					"son": "this is a son"
					}
			}`,
		want: `
		{
			"LineInfo": {
				"father": {
					"": {
						"Value": [
							2
						]
					}
				},
				"son": {
					".father": {
						"Value": [
							3
						]
					}
				},
				"this is a son": {
					".father": {
						"Value": [
							3
						]
					}
				}
			}
		}
		`},
	{
		name: "test with array string json line",
		args: args{
			doc: []byte(`{
					"father": [
						"testing1",
						"testing2"
					]
				}
				`),
		},
		wantKicsLine: `
			{
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 0
					},
					"_kics_father": {
						"_kics_arr": [
							{
								"_kics__default": {
									"_kics_line": 3
								}
							},
							{
								"_kics__default": {
									"_kics_line": 4
								}
							}
						],
						"_kics_line":2
					}
				},
				"father": [
					"testing1",
					"testing2"
				]
			}`,
		want: `
			{
				"LineInfo": {
					"father": {
						"": {
							"Value": [
								2
							]
						}
					},
					"testing1": {
						".father": {
							"Value": [
								3
							]
						}
					},
					"testing2": {
						".father": {
							"Value": [
								4
							]
						}
					}
				}
			}
			`,
	},
	{
		name: "test with equal string json line",
		args: args{
			doc: []byte(`{
					"father": [
						"testing",
						"testing"
					]
				}
				`),
		},
		wantKicsLine: `
			{
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 0
					},
					"_kics_father": {
						"_kics_arr":[
							{
								"_kics__default": {
									"_kics_line": 3
								}
							},
							{
								"_kics__default": {
									"_kics_line": 4
								}
							}
						],
						"_kics_line": 2
					}
				},
				"father":[
					"testing",
					"testing"
				]
			}`,
		want: `
			{
				"LineInfo": {
					"father": {
						"": {
							"Value": [
								2
							]
						}
					},
					"testing": {
						".father": {
							"Value": [
								3,
								4
							]
						}
					}
				}
			}
			`,
	},
	{
		name: "test arrays with objects",
		args: args{
			doc: []byte(`{
				"resources": [
					{
						"properties": {
							"httpsOnly": false
						}
					},
					{
						"properties": {
							"httpsOnly": false
						}
					}
				]
			}
			`),
		},
		wantKicsLine: `
			{
				"_kics_lines":{
					"_kics__default":{
						"_kics_line":0
					},
					"_kics_resources":{
						"_kics_line":2,
					"_kics_arr":[
						{
							"_kics__default":{
								"_kics_line":4
							},
							"_kics_properties":{
								"_kics_line":4
							}
						},
						{
							"_kics__default":{
								"_kics_line":9
							},
							"_kics_properties":{
								"_kics_line":9
							}
						}
					]
				}
			},
			"resources":[
				{
					"properties":{
						"_kics_lines":{
							"_kics__default":{
								"_kics_line":4
							},
							"_kics_httpsOnly":{
								"_kics_line":5
							}
						},
						"httpsOnly":false
					}
				},
				{
					"properties":{
						"_kics_lines":{
							"_kics__default":{
								"_kics_line":9
							},
							"_kics_httpsOnly":{
								"_kics_line":10
							}
						},
						"httpsOnly":false
					}
				}
			]
		}`,
		want: `
		{
			"LineInfo":	{
					"false": {
						".resources.properties": {
							"Value": [
								5,
								10
							]
						}
					},
					"httpsOnly": {
						".resources.properties": {
							"Value": [
								5,
								10
							]
						}
					},
					"properties": {
						".resources": {
							"Value": [
								4,
								9
							]
						}
					},
					"resources": {
						"": {
							"Value": [
								2
							]
						}
					}
				}
			}`,
	},
}

func Test_initializeJSONLine(t *testing.T) {
	for _, tt := range testsinitiateJSONLine {
		t.Run(tt.name, func(t *testing.T) {
			got := initializeJSONLine(tt.args.doc)
			compareJSONLine(t, *got, tt.want)
		})
	}
}

func compareJSONLine(t *testing.T, test1 interface{}, test2 string) {
	stringefiedJSON, err := json.Marshal(&test1)
	require.NoError(t, err)
	aux := string(stringefiedJSON)
	require.JSONEq(t, test2, aux)
}

func Test_jsonLine_setLineInfo(t *testing.T) {
	for _, tt := range testsinitiateJSONLine {
		//t.Run(tt.name, func(t *testing.T) {
		unmarshaledJSON := make(map[string]interface{})
		err := json.Unmarshal(tt.args.doc, &unmarshaledJSON)
		require.NoError(t, err)
		j := initializeJSONLine(tt.args.doc)
		got := j.setLineInfo(unmarshaledJSON)
		compareJSONLine(t, got, tt.wantKicsLine)
		//})
	}
}

func Test_fifo_add(t *testing.T) {
	type fields struct {
		name  string
		value []int
	}
	type args struct {
		elements []int
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   []int
	}{
		{
			name: "test pop",
			fields: fields{
				name:  "simple_pop",
				value: []int{1, 2, 3, 4, 5, 6},
			},
			args: args{
				elements: []int{9, 10},
			},
			want: []int{1, 2, 3, 4, 5, 6, 9, 10},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := &fifo{
				name:  tt.fields.name,
				Value: tt.fields.value,
			}
			f.add(tt.args.elements...)
			require.Equal(t, tt.want, f.Value)
		})
	}
}

func Test_fifo_pop(t *testing.T) {
	type fields struct {
		name  string
		value []int
	}
	tests := []struct {
		name   string
		fields fields
		want   int
	}{
		{
			name: "test pop",
			fields: fields{
				name:  "simple_pop",
				value: []int{1, 2, 3, 4, 5, 6},
			},
			want: 1,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := &fifo{
				name:  tt.fields.name,
				Value: tt.fields.value,
			}
			length := len(f.Value)
			if got := f.pop(); got != tt.want {
				t.Errorf("fifo.pop() = %v, want %v", got, tt.want)
			}
			require.Equal(t, length-1, len(f.Value))
		})
	}
}

func Test_fifo_head(t *testing.T) {
	type fields struct {
		name  string
		value []int
	}
	tests := []struct {
		name   string
		fields fields
		want   int
	}{
		{
			name: "test head",
			fields: fields{
				name:  "simple_head",
				value: []int{5, 2, 3, 4, 5, 6},
			},
			want: 5,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			f := &fifo{
				name:  tt.fields.name,
				Value: tt.fields.value,
			}
			length := len(f.Value)
			if got := f.head(); got != tt.want {
				t.Errorf("fifo.head() = %v, want %v", got, tt.want)
			}
			require.Equal(t, length, len(f.Value))
		})
	}
}
