package hosts

import (
	"encoding/json"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestParser_GetKind tests the functions [GetKind()] and all the methods called by them
func TestParser_GetKind(t *testing.T) {
	p := &Parser{}
	require.Equal(t, model.KindINI, p.GetKind())
}

// TestParser_SupportedExtensions tests the functions [SupportedExtensions()] and all the methods called by them
func TestParser_SupportedExtensions(t *testing.T) {
	p := &Parser{}
	require.Equal(t, []string{".ini"}, p.SupportedExtensions())
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
			name: "INI to model.Document",
			p:    &Parser{},
			args: args{
				content: []byte(`
[webservers]
webserver1 ansible_host=192.168.1.100
webserver2 ansible_host=192.168.1.101

[webservers:vars]
http_port=80
app_env=production

[databases]
dbserver1 ansible_host=192.168.1.200
dbserver2 ansible_host=192.168.1.201

[databases:vars]
db_port=3306
db_backup_path=/path/to/backup/directory

[loadbalancers]
lb1 ansible_host=192.168.1.150

[monitoring]
monitoring_server ansible_host=192.168.1.250

[testing]
testserver1 ansible_host=192.168.1.50
testserver2 ansible_host=192.168.1.51

[webservers:vars]
ansible_user=your_username
ansible_ssh_private_key_file=/path/to/your/private_key

[testing:children]
webservers

[webservers:children]
databases`),
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
