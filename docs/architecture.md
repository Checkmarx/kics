## Overview

KICS is 100% open source is written in Golang using Open Policy Agent (<a href="https://www.openpolicyagent.org/" target="_blank">OPA</a>).

Golang speed, simplicity and reliability made it the perfect choice for writing KICS, while <a href="https://www.openpolicyagent.org/docs/latest/policy-language/" target="_blank">Rego</a> as a query language, was a native choice to implement security queries.

So far have written 1000+ ready-to-use queries that cover a wide range of vulnerabilities checks for AWS, GCP, Azure and other cloud providers.

---

## High Level Architecture

KICS has a pluggable architecture with extensible pipeline of parsing IaC languages, which allows an easy integration of new IaC languages and queries.

At a very high level, KICS is composed of the following main components: a command line interface, parser, queries execution engine,  IaC providers,  security queries, and results writer.

- Command Line Interface => Provides CLI input to KICS.
- Parser => responsible for parsing input IaC files (terraform and others)
- IaC Providers => Converts IaC language into normalized JSON
- Queries Execution Engine => applies REGO queries against normalized JSON
- Security Queries => pre-built REGO queries for each security and misconfiguration
- Writer => Writes results into JSON format

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/arch/high-level-arch.png">
<br/>

---
## Execution Flow

The sequence diagram below depicts interaction of the main KICS components:
<br/>
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/arch/exec-flow-1.png">
<br/>
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/arch/exec-flow-2.png">
