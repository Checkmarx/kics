## Introduction

We're dedicated to improving detection capabilities, addressing limitations, and incorporating user feedback to deliver a more robust scanning solution. As technology evolves and user needs evolve, we are committed to continually improving KICS to provide greater value, efficiency, and security for our users.

Here, you'll find information on upcoming enhancements, planned features, and areas of focus for future releases.

---

## Bicep

### Linting and File Validation

Currently, KICS doesn't perform validation checks on Bicep files before scanning them.
This means that even if a file isn't syntactically or structurally correct, it will still be scanned, potentially leading to inaccurate results without any error notifications.

### Commands on Bicep Files as Comments

The current version does not support **ignoring sections using special commands in comments** when scanning Bicep files. Unlike other file types, where comments starting with `kics-scan` can control the scan behavior, this feature is not yet available for Bicep.

We are working on adding this capability in future updates. Until then, please note that Bicep files will be scanned in their entirety, and commands in comments will be ignored.

More information about commands on comments in files is available on [Running KICS documentation page](https://docs.kics.io/latest/running-kics/#using_commands_on_scanned_files_as_comments)

### Logic and Cycle Operators

Currently, KICS does not analyze logic and cycle operators. This means that expressions within constructs such as for and if statements are ignored during the scanning process. As a result, any security issues or vulnerabilities present within these constructs will not be detected by KICS.

### Module Support

KICS does not currently support the analysis of modules within Bicep files. Due to our current scanning methodology, which involves processing each file independently, we are unable to scan other files referenced within modules. Therefore, any security issues or vulnerabilities contained within modules will not be identified by KICS.

### Passwords and Secrets Query

Due to the nature of regex-based pattern matching, the passwords and secrets query may generate false positives when applied to Bicep files. Bicep files have a different syntax and structure compared to other file formats which can affect the accuracy of the query.

To avoid potential false positives and improve the accuracy of scans when working with Bicep files, we recommend users consider disabling the passwords and secrets query. This can be done by using the "--disable-secrets" flag.

**Note**: When using the "--disable-secrets" flag, be aware that this will disable the passwords and secrets query for all languages, not just Bicep files. As a result, you may miss some security checks in other files. Before using this flag, carefully consider the impact on your overall security coverage, especially if your project includes multiple languages or file types.

We advise reviewing your project's specific security needs to determine if this flag is appropriate. More information about the passwords and secrets query is available in our [Password and Secrets documentation](https://github.com/Checkmarx/kics/blob/master/docs/secrets.md). 


---

## Contribution

If you'd like to contribute or provide insightful feedback regarding KICS' capabilities and limitations, please don't hesitate to contact [our team](https://github.com/Checkmarx/kics/issues/).
We appreciate your patience and understanding as we strive to deliver a more robust scanning solution.
