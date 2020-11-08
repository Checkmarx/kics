Checkmarx Infrastructure as Code Scanning Engine (ICE)

**ICE** is a infrastructure-as-code Engine that scans infrastructure provisioned using [Terraform](https://terraform.io/).

ICE identifies security vulnerabilties and misconfigurations that may expose IaC files owners to cyber attacks.

ICE also powers [**Checkmarx**](https://www.checkmarx.com/products/static-application-security-testing  ) SAST product, the security-first platform that streamlines code security throughout DevSecOps lifecycle. 

## **Table of contents**

- [Features](#features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)

## Features

* ICE scans terraform files and leverages over 40 built-in queries that cover security and compliance best practices for AWS, Azure and Google Cloud.

* ICE users can create their own customer queries to support specific use-cases and prevent unique attack scenarios.


* ICE Output is currently available as CLI, JSON and references to remediation guides.

## Installation

This section describes installation procedure of ICE.

To have a fully working environment to use and develop in ICE you will need:

1. Download and install Go: https://golang.org/dl/
2. Install VS Code (or another IDE of your choosing): https://code.visualstudio.com/Download
3. Inside VS Code, install the following extensions:
 - Go
 - Open Policy Agent
 - Git Lens 
4. Install PostgreSQL: https://www.postgresql.org/download/ (optional, not needed for CLI usage)
5. Clone the repository of ICE to VS Code: https://github.com/CheckmarxDev/ice
6. Test if the application is running properly by running in the terminal, in the root of the project:

go run ./cmd/console/main.go -p assets/queries/terraform

## Contributing

Contribution is welcome and appreciated!!

Start by reviewing the [contribution guidelines](CONTRIBUTING.md)

Looking to contribute new scanning queries? Learn how to do it here


