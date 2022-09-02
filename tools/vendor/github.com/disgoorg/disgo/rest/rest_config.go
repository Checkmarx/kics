package rest

import (
	"net/http"
	"time"

	"github.com/disgoorg/log"
)

// DefaultConfig is the configuration which is used by default
func DefaultConfig() *Config {
	return &Config{
		Logger:     log.Default(),
		HTTPClient: &http.Client{Timeout: 20 * time.Second},
	}
}

// Config is the configuration for the rest client
type Config struct {
	Logger                    log.Logger
	HTTPClient                *http.Client
	RateLimiter               RateLimiter
	RateRateLimiterConfigOpts []RateLimiterConfigOpt
	UserAgent                 string
}

// ConfigOpt can be used to supply optional parameters to NewClient
type ConfigOpt func(config *Config)

// Apply applies the given ConfigOpt(s) to the Config
func (c *Config) Apply(opts []ConfigOpt) {
	for _, opt := range opts {
		opt(c)
	}
	if c.RateLimiter == nil {
		c.RateLimiter = NewRateLimiter(c.RateRateLimiterConfigOpts...)
	}
}

// WithLogger applies a custom logger to the rest rate limiter
func WithLogger(logger log.Logger) ConfigOpt {
	return func(config *Config) {
		config.Logger = logger
	}
}

// WithHTTPClient applies a custom http.Client to the rest rate limiter
func WithHTTPClient(httpClient *http.Client) ConfigOpt {
	return func(config *Config) {
		config.HTTPClient = httpClient
	}
}

// WithRateLimiter applies a custom rrate.RateLimiter to the rest client
func WithRateLimiter(rateLimiter RateLimiter) ConfigOpt {
	return func(config *Config) {
		config.RateLimiter = rateLimiter
	}
}

// WithRateRateLimiterConfigOpts applies rrate.ConfigOpt for the rrate.RateLimiter to the rest rate limiter
func WithRateRateLimiterConfigOpts(opts ...RateLimiterConfigOpt) ConfigOpt {
	return func(config *Config) {
		config.RateRateLimiterConfigOpts = append(config.RateRateLimiterConfigOpts, opts...)
	}
}

// WithUserAgent sets the user agent for all requests
func WithUserAgent(userAgent string) ConfigOpt {
	return func(config *Config) {
		config.UserAgent = userAgent
	}
}
