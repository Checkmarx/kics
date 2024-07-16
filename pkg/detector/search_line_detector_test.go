package detector

import (
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

func TestGetLineBySearchLine(t *testing.T) { //nolint
	type args struct {
		pathComponents []string
		file           *model.FileMetadata
	}
	tests := []struct {
		name    string
		args    args
		want    int
		wantErr bool
	}{
		{ //nolint
			name: "test simple search line",
			args: args{
				pathComponents: []string{"father", "son", "grandson"},
				file: &model.FileMetadata{
					LineInfoDocument: map[string]interface{}{
						"_kics_lines": map[string]interface{}{
							"_kics__default": map[string]interface{}{
								"_kics_line": 0,
							},
							"_kics_father": map[string]interface{}{
								"_kics_line": 3,
							},
						},
						"father": map[string]interface{}{
							"_kics_lines": map[string]interface{}{
								"_kics__default": map[string]interface{}{
									"_kics_line": 3,
								},
								"_kics_son": map[string]interface{}{
									"_kics_line": 4,
								},
							},
							"son": map[string]interface{}{
								"_kics_lines": map[string]interface{}{
									"_kics__default": map[string]interface{}{
										"_kics_line": 4,
									},
									"_kics_grandson": map[string]interface{}{
										"_kics_line": 5,
									},
								},
								"grandson": "value",
							},
						},
					},
				},
			},
			want:    5,
			wantErr: false,
		},
		{
			name: "test with similar array elements",
			args: args{
				pathComponents: []string{"father", "1", "son"},
				file: &model.FileMetadata{
					LineInfoDocument: map[string]interface{}{
						"_kics_lines": map[string]interface{}{
							"_kics__default": map[string]interface{}{
								"_kics_line": 0,
							},
							"_kics_father": map[string]interface{}{
								"_kics_arr": []interface{}{
									map[string]interface{}{
										"_kics__default": map[string]interface{}{
											"_kics_line": 2,
										}, "_kics_son": map[string]interface{}{
											"_kics_line": 4,
										},
									},
									map[string]interface{}{
										"_kics__default": map[string]interface{}{
											"_kics_line": 2,
										},
										"_kics_son": map[string]interface{}{
											"_kics_line": 7,
										},
									},
									map[string]interface{}{
										"_kics__default": map[string]interface{}{
											"_kics_line": 2,
										},
										"_kics_son": map[string]interface{}{
											"_kics_line": 10,
										},
									},
								},
								"_kics_line": 2,
							},
						},
						"father": []interface{}{
							map[string]interface{}{
								"son": "son_1",
							},
							map[string]interface{}{
								"son": "son_2",
							},
							map[string]interface{}{
								"son": "son_3",
							},
						},
					},
				},
			},
			want:    7,
			wantErr: false,
		},
		{ //nolint
			name: "test with dots on keys",
			args: args{
				pathComponents: []string{"father", "son.name", "grandson"},
				file: &model.FileMetadata{
					LineInfoDocument: map[string]interface{}{
						"_kics_lines": map[string]interface{}{
							"_kics__default": map[string]interface{}{
								"_kics_line": 0,
							},
							"_kics_father": map[string]interface{}{
								"_kics_line": 2,
							},
						},
						"father": map[string]interface{}{
							"_kics_lines": map[string]interface{}{
								"_kics__default": map[string]interface{}{
									"_kics_line": 2,
								},
								"_kics_son.name": map[string]interface{}{
									"_kics_line": 3,
								},
							},
							"son.name": map[string]interface{}{
								"_kics_lines": map[string]interface{}{
									"_kics__default": map[string]interface{}{
										"_kics_line": 3,
									},
									"_kics_grandson": map[string]interface{}{
										"_kics_line": 4,
									},
								},
								"grandson": "value",
							},
						},
					},
				},
			},
			want:    4,
			wantErr: false,
		},
		{ //nolint
			name: "test number issue with key",
			args: args{
				pathComponents: []string{"father", "1", "grandson"},
				file: &model.FileMetadata{
					LineInfoDocument: map[string]interface{}{
						"_kics_lines": map[string]interface{}{
							"_kics__default": map[string]interface{}{
								"_kics_line": 0,
							},
							"_kics_father": map[string]interface{}{
								"_kics_line": 2,
							},
						},
						"father": map[string]interface{}{
							"_kics_lines": map[string]interface{}{
								"_kics__default": map[string]interface{}{
									"_kics_line": 2,
								},
								"_kics_son.name": map[string]interface{}{
									"_kics_line": 3,
								},
							},
							"1": map[string]interface{}{
								"_kics_lines": map[string]interface{}{
									"_kics__default": map[string]interface{}{
										"_kics_line": 3,
									},
									"_kics_grandson": map[string]interface{}{
										"_kics_line": 4,
									},
								},
								"grandson": "value",
							},
						},
					},
				},
			},
			want:    4,
			wantErr: false,
		},
		{
			name: "test number issue with array",
			args: args{
				pathComponents: []string{"father", "son", "3"},
				file: &model.FileMetadata{
					LineInfoDocument: map[string]interface{}{
						"_kics_lines": map[string]interface{}{
							"_kics__default": map[string]interface{}{
								"_kics_line": 0,
							},
							"_kics_father": map[string]interface{}{
								"_kics_line": 2,
							},
						},
						"father": map[string]interface{}{
							"_kics_lines": map[string]interface{}{
								"_kics__default": map[string]interface{}{
									"_kics_line": 2,
								},
								"_kics_son": map[string]interface{}{
									"_kics_arr": []interface{}{
										map[string]interface{}{
											"_kics__default": map[string]interface{}{
												"_kics_line": 4,
											},
										}, map[string]interface{}{
											"_kics__default": map[string]interface{}{
												"_kics_line": 5,
											},
										}, map[string]interface{}{
											"_kics__default": map[string]interface{}{
												"_kics_line": 6,
											},
										}, map[string]interface{}{
											"_kics__default": map[string]interface{}{
												"_kics_line": 7,
											},
										},
									},
									"_kics_line": 3,
								},
							},
							"son": []interface{}{
								1,
								2,
								3,
								0,
							},
						},
					},
				},
			},
			want:    7,
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetLineBySearchLine(tt.args.pathComponents, tt.args.file)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetLineBySearchLine() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("GetLineBySearchLine() = %v, want %v", got, tt.want)
			}
		})
	}
}
