module github.com/Checkmarx/kics

go 1.16

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/agnivade/levenshtein v1.1.0
	github.com/containerd/containerd v1.4.4 // indirect
	github.com/getsentry/sentry-go v0.10.0
	github.com/golang/mock v1.5.0
	github.com/google/go-cmp v0.5.3 // indirect
	github.com/google/uuid v1.2.0
	github.com/gookit/color v1.2.4
	github.com/hashicorp/hcl v1.0.0
	github.com/hashicorp/hcl/v2 v2.9.0
	github.com/mailru/easyjson v0.7.7
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	github.com/moby/buildkit v0.8.2
	github.com/open-policy-agent/opa v0.26.0
	github.com/pelletier/go-toml v1.8.1 // indirect
	github.com/pkg/errors v0.9.1
	github.com/rs/zerolog v1.20.0
	github.com/spf13/cobra v1.1.3
	github.com/spf13/pflag v1.0.5
	github.com/spf13/viper v1.7.1
	github.com/stretchr/testify v1.7.0
	github.com/zclconf/go-cty v1.8.0
	golang.org/x/sys v0.0.0-20210220050731-9a76102bfb43 // indirect
	gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776
	helm.sh/helm/v3 v3.5.3
)

replace github.com/docker/docker => github.com/docker/docker v1.4.2-0.20200227233006-38f52c9fec82

replace github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d
