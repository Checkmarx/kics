module github.com/Checkmarx/kics

go 1.16

require (
	cloud.google.com/go/monitoring v1.2.0 // indirect
	github.com/BurntSushi/toml v0.4.1
	github.com/GoogleCloudPlatform/terraformer v0.8.18
	github.com/agnivade/levenshtein v1.1.1
	github.com/alexmullins/zip v0.0.0-20180717182244-4affb64b04d0
	github.com/antlr/antlr4/runtime/Go/antlr v0.0.0-20211114212643-ec144ca0d701
	github.com/aws/aws-sdk-go v1.37.19
	github.com/cheggaaa/pb/v3 v3.0.8
	github.com/emicklei/proto v1.9.1
	github.com/getsentry/sentry-go v0.12.0
	github.com/golang/mock v1.6.0
	github.com/google/pprof v0.0.0-20210720184732-4bb14d4b1be1
	github.com/google/uuid v1.3.0
	github.com/gookit/color v1.5.0
	github.com/hashicorp/go-getter v1.5.9
	github.com/hashicorp/hcl v1.0.1-0.20201015184941-809e678c39ec
	github.com/hashicorp/hcl/v2 v2.10.1
	github.com/hashicorp/terraform-json v0.13.0
	github.com/johnfercher/maroto v0.33.0
	github.com/mailru/easyjson v0.7.7
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	github.com/moby/buildkit v0.9.3
	github.com/open-policy-agent/opa v0.34.2
	github.com/pkg/errors v0.9.1
	github.com/rs/zerolog v1.26.1
	github.com/spf13/cobra v1.2.1
	github.com/spf13/pflag v1.0.5
	github.com/spf13/viper v1.9.0
	github.com/stretchr/testify v1.7.0
	github.com/tdewolff/minify/v2 v2.9.22
	github.com/tidwall/gjson v1.13.0
	github.com/xeipuuv/gojsonschema v1.2.0
	github.com/zclconf/go-cty v1.10.0
	golang.org/x/net v0.0.0-20211008194852-3b03d305991f
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b
	helm.sh/helm/v3 v3.7.1
)

replace (
	github.com/containerd/containerd => github.com/containerd/containerd v1.5.9
	github.com/docker/cli => github.com/docker/cli v20.10.12+incompatible
	github.com/hashicorp/vault => github.com/hashicorp/vault v1.7.5
	github.com/opencontainers/image-spec => github.com/opencontainers/image-spec v1.0.2
	github.com/spf13/afero => github.com/spf13/afero v1.2.2
	gopkg.in/jarcoal/httpmock.v1 => github.com/jarcoal/httpmock v1.0.5
)
