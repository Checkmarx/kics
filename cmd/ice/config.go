package main

import (
	"github.com/spf13/viper"
)

// fields names
const (
	logLevelEnvField              = "LOG_LEVEL"
	iceRESTPortEnvField           = "ICE_REST_PORT"
	repostoreRestAddressEnvField  = "REPOSTORE_REST_ADDRESS"
	repostoreGRPCAddressEnvField  = "REPOSTORE_GRPC_ADDRESS"
	workflowBrokerAddressEnvField = "WORKFLOW_BROKER_ADDRESS"
	workTimeoutMinutesEnvField    = "WORK_TIMEOUT_IN_MINUTES"
	workJobTypeEnvField           = "WORK_JOB_TYPE"
	dbConnectionField             = "POSTGRES_URL"
	querySourcePathField          = "QUERY_SOURCE_PATH"
)

// defaults
const (
	logLevelDefault    = "DEBUG"
	iceRESTPortDefault = "4005"
)

// Config type
type config struct {
	repostoreRestAddress  string
	repostoreGrpcAddress  string
	dbConnectionAddress   string
	querySourcePath       string
	workflowBrokerAddress string
	workTimeoutMinutes    uint
	workJobType           string
	restPort              string
	logLevel              string
}

func loadConfig() *config {
	viper.SetDefault(logLevelEnvField, logLevelDefault)
	viper.SetDefault(iceRESTPortEnvField, iceRESTPortDefault)
	viper.SetDefault(workflowBrokerAddressEnvField, "127.0.0.1:26500")
	viper.SetDefault(workJobTypeEnvField, "kics-runner")
	viper.SetDefault(workTimeoutMinutesEnvField, "600")
	viper.SetDefault(repostoreRestAddressEnvField, "http://localhost:30302")
	viper.SetDefault(repostoreGRPCAddressEnvField, "localhost:3333")
	viper.SetDefault(dbConnectionField, "host=localhost port=5432 user=postgres password=Cx123456 database=AST_SHOWOFF sslmode=disable")
	viper.SetDefault(querySourcePathField, "/app/assets/queries")

	viper.AutomaticEnv()

	return &config{
		logLevel:              viper.GetString(logLevelEnvField),
		restPort:              viper.GetString(iceRESTPortEnvField),
		repostoreRestAddress:  viper.GetString(repostoreRestAddressEnvField),
		repostoreGrpcAddress:  viper.GetString(repostoreGRPCAddressEnvField),
		dbConnectionAddress:   viper.GetString(dbConnectionField),
		workflowBrokerAddress: viper.GetString(workflowBrokerAddressEnvField),
		workTimeoutMinutes:    viper.GetUint(workTimeoutMinutesEnvField),
		workJobType:           viper.GetString(workJobTypeEnvField),
		querySourcePath:       viper.GetString(querySourcePathField),
	}
}
