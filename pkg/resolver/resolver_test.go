package resolver

import (
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
)

func initializeBuilder() *Resolver {
	bd, _ := NewBuilder().
		Build()
	return bd
}

func TestGetType(t *testing.T) {
	res := initializeBuilder()
	type args struct {
		filepath string
	}
	tests := []struct {
		name string
		args args
		want model.FileKind
	}{

		{
			name: "get_no_type",
			args: args{
				filepath: filepath.FromSlash("../../test/fixtures/all_auth_users_get_read_access"),
			},
			want: model.KindCOMMON,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := res.GetType(tt.args.filepath)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetType() = %v, want = %v", got, tt.want)
			}
		})
	}
}
