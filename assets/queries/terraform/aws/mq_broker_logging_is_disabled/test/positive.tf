resource "aws_mq_broker" "logging_disabled" {
  broker_name = "no-logging"
}

resource "aws_mq_broker" "audit_logging_missing" {
  broker_name = "partial-logging"

  logs {
      general = true
  }
}

resource "aws_mq_broker" "general_logging_disabled" {
  broker_name = "disabled-logging"

  logs {
      general = false
      audit = true
  }
}
