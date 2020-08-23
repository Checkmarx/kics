package main

import (
	"github.com/spf13/viper"
)

// fields names
const (
	logLevelEnvField              = "LOG_LEVEL"
	IceRESTPortEnvField           = "ICE_REST_PORT"
	RepostoreRestAddressEnvField  = "REPOSTORE_REST_ADDRESS"
	RepostoreGRPCAddressEnvField  = "REPOSTORE_GRPC_ADDRESS"
	WorkflowBrokerAddressEnvField = "WORKFLOW_BROKER_ADDRESS"
	workTimeoutMinutesEnvField    = "WORK_TIMEOUT_IN_MINUTES"
	workJobTypeEnvField           = "WORK_JOB_TYPE"
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
	WorkflowBrokerAddress string
	workTimeoutMinutes    uint
	workJobType           string
	restPort              string
	logLevel              string
}

func loadConfig() *config {
	viper.SetDefault(logLevelEnvField, logLevelDefault)
	viper.SetDefault(IceRESTPortEnvField, iceRESTPortDefault)
	viper.SetDefault(WorkflowBrokerAddressEnvField, "127.0.0.1:26500")
	viper.SetDefault(workJobTypeEnvField, "ice-runner")
	viper.SetDefault(workTimeoutMinutesEnvField, "600")
	viper.SetDefault(RepostoreRestAddressEnvField, "http://localhost:30302")
	viper.SetDefault(RepostoreGRPCAddressEnvField, "localhost:3333")

	viper.AutomaticEnv()

	return &config{
		logLevel:              viper.GetString(logLevelEnvField),
		restPort:              viper.GetString(IceRESTPortEnvField),
		repostoreRestAddress:  viper.GetString(RepostoreRestAddressEnvField),
		repostoreGrpcAddress:  viper.GetString(RepostoreGRPCAddressEnvField),
		WorkflowBrokerAddress: viper.GetString(WorkflowBrokerAddressEnvField),
		workTimeoutMinutes:    viper.GetUint(workTimeoutMinutesEnvField),
		workJobType:           viper.GetString(workJobTypeEnvField),
	}
}
