// This tfvars file lives outside the scan root. With --strict-source-resolution
// it must NOT be loaded via the kics_terraform_vars magic comment.
instance_type = "leaked-from-outside-scan-root"
