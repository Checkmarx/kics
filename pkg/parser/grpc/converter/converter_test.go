package converter

import (
	"bytes"
	"encoding/json"
	"fmt"
	"reflect"
	"testing"

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
				Messages:    make(map[string]Message),
				Services:    make(map[string]Service),
				Imports:     make(map[string]Import),
				Options:     make([]Option, 0),
				Enum:        make(map[string]Enum),
				Syntax:      "",
				PackageName: "",
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
		name    string
		content []byte
		want    string
	}{
		{
			name: "convert simple",
			content: []byte(`
			syntax = "proto3";
			`),
			want: `{
				"syntax": "proto3",
				"package": "",
				"messages": {},
				"enum": {},
				"services": {},
				"imports": {},
				"options": []
			}`,
		},
		{
			name: "convert message oneOf and enum",
			content: []byte(`
			syntax = "proto3";
			message test{
				enum Testing {
					reserved "foo", "bar";
				}
				oneof payload {
					bytes protobuf_payload = 1;
					string json_payload = 2;
				  }
			}
			`),
			want: `{
				"syntax": "proto3",
				"package": "",
				"messages": {
					"test": {
						"oneof": {
							"payload": {
								"fields": {
									"json_payload": {
										"type": "string",
										"sequence": 2
									},
									"protobuf_payload": {
										"type": "bytes",
										"sequence": 1
									}
								}
							}
						},
						"enum": {
							"Testing": {
								"reserved": [
									{
										"fieldNames": [
											"foo",
											"bar"
										]
									}
								]
							}
						}
					}
				},
				"enum": {},
				"services": {},
				"imports": {},
				"options": []
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
			want: `{
				"syntax": "proto3",
				"package": "",
				"messages": {
					"reserved": {
						"reserved": [
							{
								"fieldNames": [
									"foo",
									"bar"
								]
							}
						]
					}
				},
				"enum": {},
				"services": {},
				"imports": {},
				"options": []
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
			want: `{
				"syntax": "proto3",
				"package": "helloworld",
				"messages": {
					"HelloReply": {
						"field": {
							"message": {
								"type": "string",
								"sequence": 1
							},
							"status": {
								"type": "google.rpc.Status",
								"sequence": 2
							}
						}
					},
					"HelloRequest": {
						"field": {
							"name": {
								"type": "string",
								"sequence": 1,
								"options": [
									{
										"name": "(validate.rules).string.pattern",
										"constant": {
											"source": "^\\\\w+( +\\\\w+)*$",
											"isString": true,
											"quoteRune": 34
										},
										"isEmbedded": true
									}
								]
							}
						}
					}
				},
				"enum": {},
				"services": {
					"Greeter": {
						"rpc": {
							"SayHello": {
								"requestType": "HelloRequest",
								"returnsType": "HelloReply",
								"options": [
									{
										"name": "(google.api.http)",
										"constant": {
											"map": {
												"body": {
													"source": "*",
													"isString": true,
													"quoteRune": 34
												},
												"post": {
													"source": "/service/hello",
													"isString": true,
													"quoteRune": 34
												}
											},
											"orderedMap": [
												{
													"name": "post",
													"source": "/service/hello",
													"isString": true,
													"quoteRune": 34
												},
												{
													"name": "body",
													"source": "*",
													"isString": true,
													"quoteRune": 34
												}
											]
										}
									}
								]
							}
						}
					}
				},
				"imports": {
					"envoyproxy/protoc-gen-validate/validate/validate.proto": {},
					"google/rpc/status.proto": {}
				},
				"options": []
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
			want: `{
				"syntax": "proto3",
				"package": "Cx",
				"messages": {
					"Outer": {
						"field": {
							"enum_field": {
								"type": "EnumAllowingAlias",
								"sequence": 3
							},
							"inner_message": {
								"type": "Inner",
								"sequence": 2,
								"repeated": true
							}
						},
						"map": {
							"my_map": {
								"field": {
									"type": "string",
									"sequence": 4
								},
								"key_type": "int32"
							}
						},
						"inner_message": {
							"Inner": {
								"field": {
									"ival": {
										"type": "int64",
										"sequence": 1
									}
								}
							}
						},
						"options": {
							"(my_option).a": {
								"name": "(my_option).a",
								"constant": {
									"source": "true"
								}
							}
						}
					}
				},
				"enum": {
					"EnumAllowingAlias": {
						"field": {
							"RUNNING": {
								"value": 2,
								"options": {
									"name": "(custom_option)",
									"constant": {
										"source": "hello world",
										"isString": true,
										"quoteRune": 34
									},
									"isEmbedded": true
								}
							},
							"STARTED": {
								"value": 1,
								"options": {
									"constant": {}
								}
							},
							"UNKNOWN": {
								"options": {
									"constant": {}
								}
							}
						},
						"options": {
							"allow_alias": {
								"name": "allow_alias",
								"constant": {
									"source": "true"
								}
							}
						}
					}
				},
				"services": {},
				"imports": {
					"other.proto": {
						"kind": "public"
					}
				},
				"options": [
					{
						"name": "java_package",
						"constant": {
							"source": "com.example.foo",
							"isString": true,
							"quoteRune": 34
						}
					}
				]
			}`,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			reader := bytes.NewReader(tt.content)
			parserProto := proto.NewParser(reader)
			nodes, err := parserProto.Parse()
			require.NoError(t, err)
			got := Convert(nodes)
			gotString, err := json.Marshal(got)
			require.NoError(t, err)
			fmt.Println(string(gotString))
			require.JSONEq(t, tt.want, string(gotString))

		})
	}
}
