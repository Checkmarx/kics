module github.com/Checkmarx/kics

go 1.16

require (
	github.com/BurntSushi/toml v0.4.1
	github.com/agnivade/levenshtein v1.1.1
	github.com/antlr/antlr4/runtime/Go/antlr v0.0.0-20210907221601-4f80a5e09cd0
	github.com/cheggaaa/pb/v3 v3.0.8
	github.com/getsentry/sentry-go v0.11.0
	github.com/golang/mock v1.6.0
	github.com/google/pprof v0.0.0-20210720184732-4bb14d4b1be1
	github.com/google/uuid v1.3.0
	github.com/gookit/color v1.5.0
	github.com/hashicorp/go-getter v1.5.9
	github.com/hashicorp/hcl v1.0.0
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/hashicorp/terraform-json v0.13.0
	github.com/johnfercher/maroto v0.33.0
	github.com/mailru/easyjson v0.7.7
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	github.com/moby/buildkit v0.9.2
	github.com/open-policy-agent/opa v0.33.0
	github.com/pkg/errors v0.9.1
	github.com/rs/zerolog v1.25.0
	github.com/spf13/cobra v1.2.1
	github.com/spf13/pflag v1.0.5
	github.com/spf13/viper v1.9.0
	github.com/stretchr/testify v1.7.0
	github.com/tdewolff/minify/v2 v2.9.22
	github.com/tidwall/gjson v1.11.0
	github.com/xeipuuv/gojsonschema v1.2.0
	github.com/zclconf/go-cty v1.9.1
	golang.org/x/net v0.0.0-20210825183410-e898025ed96a
	golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b
	helm.sh/helm/v3 v3.7.1
)

replace github.com/docker/docker => github.com/docker/docker v1.4.2-0.20200227233006-38f52c9fec82

replace github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d

replace github.com/containerd/containerd => github.com/containerd/containerd v1.5.7
