[![codecov](https://codecov.io/gh/Checkmarx/kics/branch/master/graph/badge.svg?token=SN0NO4H46G)](https://codecov.io/gh/Checkmarx/kics)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/ceddb5b1b37d4edfa56440842c6248a4)](https://www.codacy.com/gh/Checkmarx/kics/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Checkmarx/kics&amp;utm_campaign=Badge_Grade)
[![CodeFactor](https://www.codefactor.io/repository/github/checkmarx/kics/badge)](https://www.codefactor.io/repository/github/checkmarx/kics)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Checkmarx_kics&metric=alert_status)](https://sonarcloud.io/dashboard?id=Checkmarx_kics)
[![Gitter](https://badges.gitter.im/kics-dev/community.svg)](https://gitter.im/kics-dev/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Latest Release](https://img.shields.io/github/v/release/checkmarx/kics)](https://github.com/checkmarx/kics/releases) [![Join the chat at https://gitter.im/kics-io/community](https://badges.gitter.im/kics-io/community.svg)](https://gitter.im/kics-io/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


<img alt="KICS - Keep Infrastructure as Code Secure" src="docs/img/logo/xmas-donkey.png" width="250">  

---

<a href="https://www.kics.io" title="www.kics.io"><img src="docs/img/button_www-kics-io.png" align="right"></a>

**KICS** (pronounced as 'kick-s') or **Kicscan** is an open source solution for static code analysis of Infrastructure as Code.

**K**eeping **I**nfrastructure as **C**ode **S**ecure (in short **KICS**) is a must-have for any cloud native project. With KICS, finding security vulnerabilities, compliance issues, and infrastructure misconfigurations happens early in the development cycle, when fixing these is straightforward and cheap.

It is as simple as running a CLI tool, making it easy to integrate into any project CI.

#### Supported Platforms

<img alt="Terraform" src="docs/img/logo-terraform.png" width="150">&nbsp;&nbsp;&nbsp;<img alt="Kubernetes" src="docs/img/logo-k8s.png" width="150">&nbsp;&nbsp;&nbsp;<img alt="Docker" src="docs/img/logo-docker.png" width="150">&nbsp;&nbsp;&nbsp;<img alt="CloudFormation" src="docs/img/logo-cf.png" width="150">&nbsp;&nbsp;&nbsp;<img alt="Ansible" src="docs/img/logo-ansible.png" width="150">

Support of other solutions, such as Chef, and of additional cloud providers are on the [roadmap](docs/roadmap.md).


## Getting Started

Setting up and using KICS is super-easy.

- First, see how to [install and get KICS running](docs/getting-started.md).
- Next, check how you can easily [integrate it into your CI](docs/integrations.md) for any project.
- Eventually, [explore the output results format](docs/results.md) and quickly fix the issues detected.

## How it Works

What makes KICS really powerful and popular is its built-in extensibility. This extensibility is achieved by:

- Fully customizable and adjustable heuristics rules, called [queries](docs/queries.md). These can be easily edited, extended, and added.
- Robust but yet simple [architecture](docs/architecture.md), which allows quick addition of support for new Infrastructure as Code solutions.

## Contribution

KICS is a true community project. It's built as an open source from day one, and anyone can find his own way to contribute to the project.  
[Check out how](docs/CONTRIBUTING.md), within just minutes, you can start making a difference, by sharing your expertise with a community of thousands of security experts and software developers.

## More

<a href="https://www.kics.io" title="www.kics.io"><img src="docs/img/button_www-kics-io.png" align="right"></a>

[KICS public documentation](https://docs.kics.io/) has all the project aspects covered.  
Join the chat [on Gitter](https://gitter.im/kics-dev/community).  
Or contact KICS core team at [kics@checkmarx.com](mailto:kics@checkmarx.com)

**Keep Infrastructure as Code Secure!**

---

&copy; 2020 Checkmarx Ltd. All Rights Reserved.
