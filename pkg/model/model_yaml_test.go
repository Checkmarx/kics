package model

import (
	json "encoding/json"
	"testing"

	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

type args struct {
	value *yaml.Node
}

/*
=============== TEST CASES ===================
===================#1=========================
key: false
key_object:
	null_object: null
	int_object: 24
	seq_object:
		- key_seq: key_val
	  	key_seq_2: key_val_2
		- second_key: second_val
      	second_key_2: second_val_2

===================#2=========================

- name: ansible
ansible_object:
name: object
- name: ansible_2
ansible_object_2:
name: object_2

===================#3=========================

array:
	- case1
	- case2
	- case3

=============== TEST CASES ===================
*/

var tests = []struct {
	name    string
	m       *Document
	args    args
	wantErr bool
	want    string
}{
	{
		name: "test simple unmarshal",
		args: args{
			value: &yaml.Node{
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
		m:       &Document{},
		wantErr: false,
		want: `{
			"_kics_lines": {
			  "_kics__default": {
				"_kics_line": 0
			  },
			  "_kics_key": {
				"_kics_line": 1
			  },
			  "_kics_key_object": {
				"_kics_line": 2
			  }
			},
			"key": false,
			"key_object": {
			  "_kics_lines": {
				"_kics__default": {
				  "_kics_line": 2
				},
				"_kics_int_object": {
				  "_kics_line": 4
				},
				"_kics_null_object": {
				  "_kics_line": 3
				},
				"_kics_seq_object": {
				  "_kics_arr": [
					{
					  "_kics__default": {
						"_kics_line": 6
					  },
					  "_kics_key_seq": {
						"_kics_line": 6
					  },
					  "_kics_key_seq_2": {
						"_kics_line": 7
					  }
					},
					{
					  "_kics__default": {
						"_kics_line": 8
					  },
					  "_kics_second_key": {
						"_kics_line": 8
					  },
					  "_kics_second_key_2": {
						"_kics_line": 9
					  }
					}
				  ],
				  "_kics_line": 5
				}
			  },
			  "int_object": 24,
			  "null_object": null,
			  "seq_object": [
				{
				  "key_seq": "key_val",
				  "key_seq_2": "key_val_2"
				},
				{
				  "second_key": "second_val",
				  "second_key_2": "second_val_2"
				}
			  ]
			}
		  }
		  `,
	},
	{
		name: "test playbooks yaml",
		m:    &Document{},
		args: args{
			value: &yaml.Node{
				Kind: yaml.SequenceNode,
				Content: []*yaml.Node{
					{
						Kind: yaml.MappingNode,
						Content: []*yaml.Node{
							{
								Kind:  yaml.ScalarNode,
								Line:  1,
								Value: "name",
							},
							{
								Kind:  yaml.ScalarNode,
								Value: "ansible",
							},
							{
								Kind:  yaml.ScalarNode,
								Value: "ansible_object",
								Line:  2,
							},
							{
								Kind: yaml.MappingNode,
								Content: []*yaml.Node{
									{
										Kind:  yaml.ScalarNode,
										Value: "name",
										Line:  3,
									},
									{
										Kind:  yaml.ScalarNode,
										Value: "object",
									},
								},
							},
						},
					},
					{
						Kind: yaml.MappingNode,
						Content: []*yaml.Node{
							{
								Kind:  yaml.ScalarNode,
								Line:  4,
								Value: "name",
							},
							{
								Kind:  yaml.ScalarNode,
								Value: "ansible_2",
							},
							{
								Kind:  yaml.ScalarNode,
								Value: "ansible_object_2",
								Line:  5,
							},
							{
								Kind: yaml.MappingNode,
								Content: []*yaml.Node{
									{
										Kind:  yaml.ScalarNode,
										Value: "name",
										Line:  6,
									},
									{
										Kind:  yaml.ScalarNode,
										Value: "object_2",
									},
								},
							},
						},
					},
				},
			},
		},
		wantErr: false,
		want: `{
			"_kics_lines": {
			  "_kics__default": {
				"_kics_arr": [
				  {
					"_kics__default": {
					  "_kics_line": 0
					},
					"_kics_ansible_object": {
					  "_kics_line": 2
					},
					"_kics_name": {
					  "_kics_line": 1
					}
				  },
				  {
					"_kics__default": {
					  "_kics_line": 0
					},
					"_kics_ansible_object_2": {
					  "_kics_line": 5
					},
					"_kics_name": {
					  "_kics_line": 4
					}
				  }
				],
				"_kics_line": 0
			  }
			},
			"playbooks": [
			  {
				"ansible_object": {
				  "_kics_lines": {
					"_kics__default": {
					  "_kics_line": 2
					},
					"_kics_name": {
					  "_kics_line": 3
					}
				  },
				  "name": "object"
				},
				"name": "ansible"
			  },
			  {
				"ansible_object_2": {
				  "_kics_lines": {
					"_kics__default": {
					  "_kics_line": 5
					},
					"_kics_name": {
					  "_kics_line": 6
					}
				  },
				  "name": "object_2"
				},
				"name": "ansible_2"
			  }
			]
		  }
		  `,
	},
	{
		name:    "test array scalar nodes",
		m:       &Document{},
		wantErr: false,
		args: args{
			value: &yaml.Node{
				Kind: yaml.MappingNode,
				Content: []*yaml.Node{
					{
						Kind:  yaml.ScalarNode,
						Value: "array",
						Line:  1,
					},
					{
						Kind: yaml.SequenceNode,
						Content: []*yaml.Node{
							{
								Kind:  yaml.ScalarNode,
								Tag:   "!!str",
								Value: "case1",
								Line:  2,
							},
							{
								Kind:  yaml.ScalarNode,
								Tag:   "!!str",
								Value: "case2",
								Line:  3,
							},
							{
								Kind:  yaml.ScalarNode,
								Tag:   "!!str",
								Value: "case3",
								Line:  4,
							},
						},
					},
				},
			},
		},
		want: `{
			"_kics_lines": {
			  "_kics__default": {
				"_kics_line": 0
			  },
			  "_kics_array": {
				"_kics_arr": [
				  {
					"_kics__default": {
					  "_kics_line": 2
					}
				  },
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
				"_kics_line": 1
			  }
			},
			"array": [
			  "case1",
			  "case2",
			  "case3"
			]
		  }
		  `,
	},
}

func TestDocument_UnmarshalYAML(t *testing.T) {
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if err := tt.m.UnmarshalYAML(tt.args.value); (err != nil) != tt.wantErr {
				t.Errorf("Document.UnmarshalYAML() error = %v, wantErr %v", err, tt.wantErr)
			}
			compareJSONLine(t, tt.m, tt.want)
		})
	}
}

func compareJSONLine(t *testing.T, test1 interface{}, test2 string) {
	stringefiedJSON, err := json.Marshal(&test1)
	require.NoError(t, err)
	require.JSONEq(t, test2, string(stringefiedJSON))
}

func Test_GetIgnoreLines(t *testing.T) {
	tests := []struct {
		name string
		file *FileMetadata
		want []int
	}{
		{
			name: "test get ignore lines",
			file: &FileMetadata{
				FilePath:    "sample.yaml",
				LinesIgnore: []int{53, 54},
				OriginalData: `- name: Playbook to Create users and Projects in Openstack
  hosts: localhost
  collections:
    - openstack.cloud
  tasks:
    - name: "Ensure Projects are as defined"
      include: subroutines/openstack_per_project_actions.yaml
    - name: "Create Users in Openstack"
      openstack.cloud.identity_user:
        state: present
        name: "{{ add_user.name }}"
        password: "{{ all_openstack_default_pass }}"
        email: "{{ add_user.email }}"
        # kics-scan ignore-line
        update_password: on_create
        default_project: "{{ add_user.orgunit }}"
        domain: default
      loop: "{{ users_present }}"
      loop_control:
        loop_var: add_user
    - name: Basic AMI Creation2
      amazon.aws.ec2_ami:
        instance_id: i-xxxxxx
        device_mapping:
          device_name: /dev/sda
        wait: yes
        name: newtest
        tags:
          Name: newtest
          Service: TestService`,
			},
			want: []int{14, 15},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := GetIgnoreLines(tt.file)
			require.Equal(t, got, tt.want)
		})
	}
}
