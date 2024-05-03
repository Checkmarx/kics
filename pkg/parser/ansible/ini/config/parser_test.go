package ansibleconfig

import (
	"encoding/json"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindCFG, p.GetKind())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".cfg", ".conf"}, p.SupportedExtensions())
}

// TestParser_SupportedExtensions tests the functions [SupportedTypes()] and all the methods called by them
func TestParser_SupportedTypes(t *testing.T) {
	p := &Parser{}
	require.Equal(t, map[string]bool{
		"ansible": true,
	}, p.SupportedTypes())
}

// TestParser_Parse tests the functions [Parse()] and all the methods called by them
func TestParser_Parse(t *testing.T) {
	type args struct {
		content []byte
	}
	tests := []struct {
		name    string
		p       *Parser
		args    args
		want    string
		wantErr bool
	}{
		{
			name: "CFG to model.Document",
			p:    &Parser{},
			args: args{
				content: []byte(`
[defaults]
inventory = /etc/ansible/hosts
library = /usr/share/ansible/
module_utils = /usr/share/ansible/plugins/modules/
inventory_plugins = /usr/share/ansible/plugins/inventory/
roles_path = /etc/ansible/roles
stdout_callback = yaml
forks = 10
strategy = free
httpapi_plugins=~/.ansible/plugins/httpapi:/usr/share/ansible/plugins/httpapi
internal_poll_interval=0.001
inventory_plugins=~/.ansible/plugins/inventory:/usr/share/ansible/plugins/inventory
jinja2_extensions=[]

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=30m -o ControlPath=/tmp/ansible-ssh-%h-%p-%r

[callback_plugins]
profile_tasks = yes
`),
			},
			want:    "",
			wantErr: false,
		},
	}
	for i, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			p := &Parser{}
			switch i {
			case 0:
				got, _, err := p.Parse("", tt.args.content)
				if (err != nil) != tt.wantErr {
					t.Errorf("Parser() error = %v, wantErr %v", err, tt.wantErr)
					return
				}
				_, err = json.Marshal(got)
				if err != nil {
					t.Errorf("json.Marshal() error = %v, wantErr %v", err, tt.wantErr)
					return
				}
			}
		})
	}
}
