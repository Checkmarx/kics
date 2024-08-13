# KICS
The present repository contains the source code of the Datadog version of [KICS](https://github.com/Checkmarx/kics). KICS is a project originally owned by Checkmarx to find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development cycle of your infrastructure-as-code.

At Datadog, we use it to scan your Terraform code and output a SARIF file and report it to our backend.

For more details about the full capabilities of the tool, please refer to the upstream repository.

## Contributing code

This repository is already a fork of [Checkmarx KICS](https://github.com/Checkmarx/kics).

Before contributing, please ensure you want to change a Datadog specific behavior of the scanner.
If not, please consider contributing directly to the upstream repository.

If it is about Datadog's specific behavior, a contributing guide should come up soon. In the meantime, please [open an issue](https://www.github.com/DataDog/kics/issues) to start the discussion with us

## License

The Datadog version of KICS is licensed under the [Apache License, Version 2.0](LICENSE).
