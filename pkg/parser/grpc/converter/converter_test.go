package converter

import (
	"bytes"
	"encoding/json"
	"fmt"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/emicklei/proto"
	"github.com/stretchr/testify/require"
)

func Test_newJSONProto(t *testing.T) {
	tests := []struct {
		name string
		want *JSONProto
	}{
		{
			name: "newJSONProto",
			want: &JSONProto{
				Messages:      make(map[string]interface{}),
				Services:      make(map[string]interface{}),
				Imports:       make(map[string]interface{}),
				Options:       make([]Option, 0),
				Enum:          make(map[string]interface{}),
				Syntax:        "",
				PackageName:   "",
				linesToIgnore: make([]int, 0),
				Lines:         make(map[string]model.LineObject),
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := newJSONProto(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("newJSONProto() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestConvert(t *testing.T) {
	tests := []struct {
		name            string
		content         []byte
		want            string
		wantIgnoreLines []int
	}{
		{
			name: "convert simple",
			content: []byte(`
			syntax = "proto3";
			`),
			wantIgnoreLines: []int(nil),
			want: `{
				"syntax": "proto3",
				"package": "",
				"messages": {
					"_kics_lines": {}
				},
				"enum": {
					"_kics_lines": {}
				},
				"services": {
					"_kics_lines": {}
				},
				"imports": {
					"_kics_lines": {}
				},
				"options": [],
				"_kics_lines": {
					"kics__default": {
						"_kics_line":0
					},
					"_kics_syntax": {
						"_kics_line":2
					}
				}
			}`,
		},
		{
			name: "convert message oneOf and enum",
			content: []byte(`
			syntax = "proto3";
			// kics-scan ignore-line
			message test{
				enum Testing {
					// kics-scan ignore-line
					reserved "foo", "bar";
				}
				// kics-scan ignore-block
				oneof payload {
					bytes protobuf_payload = 1;
					string json_payload = 2;
				  }
			}
			`),
			wantIgnoreLines: []int{3, 4, 6, 7, 9, 10, 11, 12},
			want: `{
				"_kics_lines": {
					"_kics_syntax": {
						"_kics_line": 2
					},
					"kics__default": {
						"_kics_line": 0
					}
				},
				"enum": {
					"_kics_lines": {}
				},
				"imports": {
					"_kics_lines": {}
				},
				"messages": {
					"_kics_lines": {
						"_kics_test": {
							"_kics_line": 4
						}
					},
					"test": {
						"_kics_lines": {
							"_kics_Testing": {
								"_kics_line": 5
							},
							"_kics__default": {
								"_kics_line": 4
							},
							"_kics_payload": {
								"_kics_line": 10
							}
						},
						"enum": {
							"Testing": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_arr": [
											{
												"Reserved": {
													"_kics_line": 7
												}
											}
										],
										"_kics_line": 5
									}
								},
								"reserved": [
									{
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 7
											}
										},
										"fieldNames": [
											"foo",
											"bar"
										]
									}
								]
							}
						},
						"oneof": {
							"payload": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 10
									},
									"_kics_json_payload": {
										"_kics_line": 12
									},
									"_kics_protobuf_payload": {
										"_kics_line": 11
									}
								},
								"fields": {
									"json_payload": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 12
											}
										},
										"sequence": 2,
										"type": "string"
									},
									"protobuf_payload": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 11
											}
										},
										"sequence": 1,
										"type": "bytes"
									}
								}
							}
						}
					}
				},
				"options": [],
				"package": "",
				"services": {
					"_kics_lines": {}
				},
				"syntax": "proto3"
			}`,
		},
		{
			name: "convert simple message",
			content: []byte(`
			syntax = "proto3";
			message reserved {
				reserved "foo", "bar";
			}
			`),
			wantIgnoreLines: []int(nil),
			want: `{
				"_kics_lines": {
					"_kics_syntax": {
						"_kics_line": 2
					},
					"kics__default": {
						"_kics_line": 0
					}
				},
				"enum": {
					"_kics_lines": {}
				},
				"imports": {
					"_kics_lines": {}
				},
				"messages": {
					"_kics_lines": {
						"_kics_reserved": {
							"_kics_line": 3
						}
					},
					"reserved": {
						"_kics_lines": {
							"_kics__default": {
								"_kics_arr": [
									{
										"Reserved": {
											"_kics_line": 4
										}
									}
								],
								"_kics_line": 3
							}
						},
						"reserved": [
							{
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 4
									}
								},
								"fieldNames": [
									"foo",
									"bar"
								]
							}
						]
					}
				},
				"options": [],
				"package": "",
				"services": {
					"_kics_lines": {}
				},
				"syntax": "proto3"
			}`,
		},
		{
			name: "convert complex service",
			content: []byte(`syntax = "proto3";
			package statustest;

			import "envoyproxy/protoc-gen-validate/validate/validate.proto";
			import "google/rpc/status.proto";

			package helloworld;

			service Greeter {
			  rpc SayHello (HelloRequest) returns (HelloReply) {
				option (google.api.http) = {
					post: "/service/hello"
					body: "*"
				};
			  }
			}

			message HelloRequest {
			  string name = 1  [(validate.rules).string.pattern = "^\\w+( +\\w+)*$"]; // Required. Allows multiple words with spaces in between, as it can contain both first and last name;
			}

			message HelloReply {
			  string message = 1;
			  google.rpc.Status status = 2;
			}`),
			wantIgnoreLines: []int(nil),
			want: `{
				"_kics_lines": {
					"_kics_package": {
						"_kics_line": 7
					},
					"_kics_syntax": {
						"_kics_line": 1
					},
					"kics__default": {
						"_kics_line": 0
					}
				},
				"enum": {
					"_kics_lines": {}
				},
				"imports": {
					"_kics_lines": {
						"_kics_envoyproxy/protoc-gen-validate/validate/validate.proto": {
							"_kics_line": 4
						},
						"_kics_google/rpc/status.proto": {
							"_kics_line": 5
						}
					},
					"envoyproxy/protoc-gen-validate/validate/validate.proto": {},
					"google/rpc/status.proto": {}
				},
				"messages": {
					"HelloReply": {
						"_kics_lines": {
							"_kics__default": {
								"_kics_line": 22
							},
							"_kics_message": {
								"_kics_line": 23
							},
							"_kics_status": {
								"_kics_line": 24
							}
						},
						"field": {
							"message": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 23
									}
								},
								"sequence": 1,
								"type": "string"
							},
							"status": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 24
									}
								},
								"sequence": 2,
								"type": "google.rpc.Status"
							}
						}
					},
					"HelloRequest": {
						"_kics_lines": {
							"_kics__default": {
								"_kics_line": 18
							},
							"_kics_name": {
								"_kics_line": 19
							}
						},
						"field": {
							"name": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 19
									}
								},
								"options": [
									{
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 19
											}
										},
										"constant": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 19
												}
											},
											"isString": true,
											"quoteRune": 34,
											"source": "^\\\\w+( +\\\\w+)*$"
										},
										"isEmbedded": true,
										"name": "(validate.rules).string.pattern"
									}
								],
								"sequence": 1,
								"type": "string"
							}
						}
					},
					"_kics_lines": {
						"_kics_HelloReply": {
							"_kics_line": 22
						},
						"_kics_HelloRequest": {
							"_kics_line": 18
						}
					}
				},
				"options": [],
				"package": "helloworld",
				"services": {
					"Greeter": {
						"_kics_lines": {
							"_kics_SayHello": {
								"_kics_line": 10
							},
							"_kics__default": {
								"_kics_line": 9
							}
						},
						"rpc": {
							"SayHello": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 10
									}
								},
								"options": [
									{
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 11
											}
										},
										"constant": {
											"_kics_lines": {
												"_kics__default": {
													"_kics_line": 11
												}
											},
											"map": {
												"body": {
													"_kics_lines": {
														"_kics__default": {
															"_kics_line": 13
														}
													},
													"isString": true,
													"quoteRune": 34,
													"source": "*"
												},
												"post": {
													"_kics_lines": {
														"_kics__default": {
															"_kics_line": 12
														}
													},
													"isString": true,
													"quoteRune": 34,
													"source": "/service/hello"
												}
											},
											"orderedMap": [
												{
													"_kics_lines": {
														"_kics__default": {
															"_kics_line": 12
														}
													},
													"isString": true,
													"name": "post",
													"quoteRune": 34,
													"source": "/service/hello"
												},
												{
													"_kics_lines": {
														"_kics__default": {
															"_kics_line": 13
														}
													},
													"isString": true,
													"name": "body",
													"quoteRune": 34,
													"source": "*"
												}
											]
										},
										"name": "(google.api.http)"
									}
								],
								"requestType": "HelloRequest",
								"returnsType": "HelloReply"
							}
						}
					},
					"_kics_lines": {
						"_kics_Greeter": {
							"_kics_line": 9
						}
					}
				},
				"syntax": "proto3"
			}`,
		},
		{
			name: "convert complex",
			content: []byte(`syntax = "proto3";
			package Cx;
			import public "other.proto";
			option java_package = "com.example.foo";
			enum EnumAllowingAlias {
			  option allow_alias = true;
			  UNKNOWN = 0;
			  STARTED = 1;
			  RUNNING = 2 [(custom_option) = "hello world"];
			}
			message Outer {
			  option (my_option).a = true;
			  message Inner {   // Level 2
				int64 ival = 1;
			  }
			  repeated Inner inner_message = 2;
			  EnumAllowingAlias enum_field =3;
			  map<int32, string> my_map = 4;
			}`),
			wantIgnoreLines: []int(nil),
			want: `{
				"_kics_lines": {
					"_kics_package": {
						"_kics_line": 2
					},
					"_kics_syntax": {
						"_kics_line": 1
					},
					"kics__default": {
						"_kics_arr": [
							{
								"java_package": {
									"_kics_line": 4
								}
							}
						],
						"_kics_line": 0
					}
				},
				"enum": {
					"EnumAllowingAlias": {
						"_kics_lines": {
							"_kics_RUNNING": {
								"_kics_line": 9
							},
							"_kics_STARTED": {
								"_kics_line": 8
							},
							"_kics_UNKNOWN": {
								"_kics_line": 7
							},
							"_kics__default": {
								"_kics_line": 5
							},
							"_kics_allow_alias": {
								"_kics_line": 6
							}
						},
						"field": {
							"RUNNING": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 9
									}
								},
								"options": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 9
										}
									},
									"constant": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 9
											}
										},
										"isString": true,
										"quoteRune": 34,
										"source": "hello world"
									},
									"isEmbedded": true,
									"name": "(custom_option)"
								},
								"value": 2
							},
							"STARTED": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 8
									}
								},
								"options": {
									"constant": {}
								},
								"value": 1
							},
							"UNKNOWN": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 7
									}
								},
								"options": {
									"constant": {}
								}
							}
						},
						"options": {
							"allow_alias": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 6
									}
								},
								"constant": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 6
										}
									},
									"source": "true"
								},
								"name": "allow_alias"
							}
						}
					},
					"_kics_lines": {
						"_kics_EnumAllowingAlias": {
							"_kics_line": 5
						}
					}
				},
				"imports": {
					"_kics_lines": {
						"_kics_other.proto": {
							"_kics_line": 3
						}
					},
					"other.proto": {
						"kind": "public"
					}
				},
				"messages": {
					"Outer": {
						"_kics_lines": {
							"_kics_(my_option).a": {
								"_kics_line": 12
							},
							"_kics_Inner": {
								"_kics_line": 13
							},
							"_kics__default": {
								"_kics_line": 11
							},
							"_kics_enum_field": {
								"_kics_line": 17
							},
							"_kics_inner_message": {
								"_kics_line": 16
							},
							"_kics_my_map": {
								"_kics_line": 18
							}
						},
						"field": {
							"enum_field": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 17
									}
								},
								"sequence": 3,
								"type": "EnumAllowingAlias"
							},
							"inner_message": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 16
									}
								},
								"repeated": true,
								"sequence": 2,
								"type": "Inner"
							}
						},
						"inner_message": {
							"Inner": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 13
									},
									"_kics_ival": {
										"_kics_line": 14
									}
								},
								"field": {
									"ival": {
										"_kics_lines": {
											"_kics__default": {
												"_kics_line": 14
											}
										},
										"sequence": 1,
										"type": "int64"
									}
								}
							}
						},
						"map": {
							"my_map": {
								"field": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 18
										}
									},
									"sequence": 4,
									"type": "string"
								},
								"key_type": "int32"
							}
						},
						"options": {
							"(my_option).a": {
								"_kics_lines": {
									"_kics__default": {
										"_kics_line": 12
									}
								},
								"constant": {
									"_kics_lines": {
										"_kics__default": {
											"_kics_line": 12
										}
									},
									"source": "true"
								},
								"name": "(my_option).a"
							}
						}
					},
					"_kics_lines": {
						"_kics_Outer": {
							"_kics_line": 11
						}
					}
				},
				"options": [
					{
						"_kics_lines": {
							"_kics__default": {
								"_kics_line": 4
							}
						},
						"constant": {
							"_kics_lines": {
								"_kics__default": {
									"_kics_line": 4
								}
							},
							"isString": true,
							"quoteRune": 34,
							"source": "com.example.foo"
						},
						"name": "java_package"
					}
				],
				"package": "Cx",
				"services": {
					"_kics_lines": {}
				},
				"syntax": "proto3"
			}`,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			reader := bytes.NewReader(tt.content)
			parserProto := proto.NewParser(reader)
			nodes, err := parserProto.Parse()
			require.NoError(t, err)
			got, ignore := Convert(nodes)
			require.Equal(t, tt.wantIgnoreLines, ignore)
			gotString, err := json.Marshal(got)
			require.NoError(t, err)
			fmt.Println(string(gotString))
			require.JSONEq(t, tt.want, string(gotString))

		})
	}
}
