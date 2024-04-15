## Introduction

We're dedicated to improving detection capabilities, addressing limitations, and incorporating user feedback to deliver a more robust scanning solution. As technology evolves and user needs evolve, we are committed to continually improving KICS to provide greater value, efficiency, and security for our users.

Here, you'll find information on upcoming enhancements, planned features, and areas of focus for future releases.

---

## Bicep

### Logic and Cycle Operators

Currently, KICS does not analyze logic and cycle operators. This means that expressions within constructs such as for and if statements are ignored during the scanning process. As a result, any security issues or vulnerabilities present within these constructs will not be detected by KICS.

### Module Support

KICS does not currently support the analysis of modules within Bicep files. Due to our current scanning methodology, which involves processing each file independently, we are unable to scan other files referenced within modules. Therefore, any security issues or vulnerabilities contained within modules will not be identified by KICS.

### Passwords and Secrets Query

Due to the nature of regex-based pattern matching, the passwords and secrets query may generate false positives when applied to Bicep files. Bicep files have a different syntax and structure compared to other file formats which can affect the accuracy of the query.

To mitigate the potential for false positives and ensure a more accurate scanning process for Bicep files, we recommend users consider disabling the passwords and secrets query when scanning Bicep files. This can be achieved by using the "--disable-secrets" flag.

Note: Disabling the passwords and secrets query may reduce the overall coverage of security checks performed by KICS. Therefore, users should consider the trade-offs and implications based on their specific use case and security requirements. More information about this query can be found on the [Password and Secrets documentation](https://github.com/Checkmarx/kics/blob/master/docs/secrets.md). 

---

## Contribution

If you'd like to contribute or provide insightfull feedback regarding KICS' capabilities and limitations, please don't hesitate to contact [our team](https://github.com/Checkmarx/kics/issues/).
We appreciate your patience and understanding as we strive to deliver a more robust scanning solution.