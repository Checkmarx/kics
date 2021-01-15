module github.com/Checkmarx/kics

go 1.15

require (
	github.com/agnivade/levenshtein v1.1.0
	github.com/getsentry/sentry-go v0.9.0
	github.com/golang/mock v1.4.4
	github.com/google/go-cmp v0.5.0 // indirect
	github.com/google/uuid v1.1.5
	github.com/hashicorp/hcl/v2 v2.8.2
	github.com/mailru/easyjson v0.7.6
	github.com/moby/buildkit v0.8.1
	github.com/open-policy-agent/opa v0.25.2
	github.com/pkg/errors v0.9.1
	github.com/rs/zerolog v1.20.0
	github.com/spf13/cobra v1.1.1
	github.com/stretchr/testify v1.6.1
	github.com/zclconf/go-cty v1.7.1
	gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776
)

replace github.com/containerd/containerd => github.com/containerd/containerd v1.3.1-0.20200227195959-4d242818bf55

replace github.com/docker/docker => github.com/docker/docker v1.4.2-0.20200227233006-38f52c9fec82
