package main

import (
	"github.com/spf13/viper"
)

// fields names
const (
	logLevelEnvField            = "LOG_LEVEL"
	natsConnectionRetryEnvField = "NATS_CONNECTION_RETRY"
	NatsURLEnvField             = "NATS_URL"
	natsTaskSubjectEnvField     = "NATS_TASK_SUBJECT"
	natsTaskGroupEnvField       = "NATS_TASK_GROUP"
	IceRESTPortEnvField         = "ICE_REST_PORT"
	RepostoreAddressEnvField    = "REPOSTORE_ADDRESS"
)

// defaults
const (
	logLevelDefault            = "DEBUG"
	natsConnectionRetryDefault = 10
	iceRESTPortDefault         = "4005"
)

// Config type
type config struct {
	natsURL             string
	natsConnectionRetry int
	tasksConnection     natsConnectionConfig
	restPort            string
	logLevel            string
	repostoreAddress    string
}

type natsConnectionConfig struct {
	subject string
	qGroup  string
}

func loadConfig() *config {
	viper.SetDefault(natsConnectionRetryEnvField, natsConnectionRetryDefault)
	viper.SetDefault(logLevelEnvField, logLevelDefault)
	viper.SetDefault(IceRESTPortEnvField, iceRESTPortDefault)
	// viper.SetDefault("NATS_URL", "nats://cxnats:Cx123456@127.0.0.1:4222")
	// viper.SetDefault("NATS_TASK_SUBJECT", "FETCH_QUERIES")
	// viper.SetDefault("NATS_TASK_GROUP", "WORKERSQG")
	// viper.SetDefault(RepostoreAddressEnvField, "http://localhost:30302")

	viper.AutomaticEnv()

	return &config{
		natsConnectionRetry: viper.GetInt(natsConnectionRetryEnvField),
		natsURL:             viper.GetString(NatsURLEnvField),
		tasksConnection: natsConnectionConfig{
			subject: viper.GetString(natsTaskSubjectEnvField),
			qGroup:  viper.GetString(natsTaskGroupEnvField),
		},
		logLevel:         viper.GetString(logLevelEnvField),
		restPort:         viper.GetString(IceRESTPortEnvField),
		repostoreAddress: viper.GetString(RepostoreAddressEnvField),
	}
}
