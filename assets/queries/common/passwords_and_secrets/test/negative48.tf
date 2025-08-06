data "template_file" "sci_integration_app_properties_secret_template" {
  template = file(join("", ["/secrets/sci-integration-app", var.resource_identifier_shorthand], ".json"))

  vars = {
    ayreshirerarran_password   = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["ayreshirerarran_password"]
    lanark_password            = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["lanark_password"]
    tayside_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["tayside_password"]
    glasgow_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["glasgow_password"]
    grampian_password          = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["grampian_password"]
    highland_password          = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["highland_password"]
    westernisles_password      = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["westernisles_password"]
    dumfriesandgalloway_password = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["dumfriesandgalloway_password"]
    forthvalley_password       = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["forthvalley_password"]
    borders_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["borders_password"]
    lothian_password           = data.aws_kms_secrets.sci_app_kms_secrets.plaintext["lothian_password"]
  }
}
