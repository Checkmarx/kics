package webhook

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/disgo/rest"
	"github.com/disgoorg/log"
)

// DefaultConfig is the default configuration for the webhook client
func DefaultConfig() *Config {
	return &Config{
		Logger:                 log.Default(),
		DefaultAllowedMentions: &discord.DefaultAllowedMentions,
	}
}

// Config is the configuration for the webhook client
type Config struct {
	Logger                 log.Logger
	RestClient             rest.Client
	RestClientConfigOpts   []rest.ConfigOpt
	Webhooks               rest.Webhooks
	DefaultAllowedMentions *discord.AllowedMentions
}

// ConfigOpt is used to provide optional parameters to the webhook client
type ConfigOpt func(config *Config)

// Apply applies all options to the config
func (c *Config) Apply(opts []ConfigOpt) {
	for _, opt := range opts {
		opt(c)
	}
	if c.RestClient == nil {
		c.RestClient = rest.NewClient("", c.RestClientConfigOpts...)
	}
	if c.Webhooks == nil {
		c.Webhooks = rest.NewWebhooks(c.RestClient)
	}
}

// WithLogger sets the logger for the webhook client
func WithLogger(logger log.Logger) ConfigOpt {
	return func(config *Config) {
		config.Logger = logger
	}
}

// WithRestClient sets the rest client for the webhook client
func WithRestClient(restClient rest.Client) ConfigOpt {
	return func(config *Config) {
		config.RestClient = restClient
	}
}

// WithRestClientConfigOpts sets the rest client configuration for the webhook client
func WithRestClientConfigOpts(opts ...rest.ConfigOpt) ConfigOpt {
	return func(config *Config) {
		config.RestClientConfigOpts = append(config.RestClientConfigOpts, opts...)
	}
}

// WithWebhooks sets the webhook service for the webhook client
func WithWebhooks(webhooks rest.Webhooks) ConfigOpt {
	return func(config *Config) {
		config.Webhooks = webhooks
	}
}

// WithDefaultAllowedMentions sets the default allowed mentions for the webhook client
func WithDefaultAllowedMentions(allowedMentions discord.AllowedMentions) ConfigOpt {
	return func(config *Config) {
		config.DefaultAllowedMentions = &allowedMentions
	}
}
