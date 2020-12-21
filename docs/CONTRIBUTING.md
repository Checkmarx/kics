## Contribution

We would like to THANK YOU for considering contributing to KICS!  

KICS is a true community project. It's built as an open source from day one, and anyone can find his own way to contribute to the project.  

Within just minutes, you can start making a difference, by sharing your expertise with a community of thousands of security experts and software developers.

### Contribution Options

Good news! You don't have to contribute code. There are plenty of ways you can contribute to KICS project:

- Reporting new [bugs or issues](https://github.com/Checkmarx/kics/issues)
- Help triaging issues
- Improving and translating the documentation 
- Volunteering to maintain the project

### Code of Conduct

By participating and contributing to the project, you agree to uphold our [Code of Conduct](code-of-conduct.md).


## Get Started!

Follow the instructions below to setup local KICS development environment and push your changes.

1. Fork the `kics` repo on GitHub.
1. Clone your fork locally:  
   ```
   git clone https://github.com/Checkmarx/kics.git
   ```
1. Create a branch for local development.  
Use succinct but descriptive name (prefix with *feature/issue#-descriptive-name>* or *hotfix/issue#-descriptive-name*):  
   ```
   git checkout -b <name-of-your-issue>
   ```
1. Make your changes locally.
1. Validate your changes to reassure they meet project quality and contribution standards:  
   ```
   golint . 
   go mod vendor 
   go test -mod=vendor -v ./...     
   ```
1. Commit your changes and push your branch to GitHub:  
   ```
   git add .
   ```  
   ```
   git commit
   ```  
   ```
   git push --set-upstream origin <name-of-your-issue>
   ```
1. Submit a pull request on GitHub website.

## How to Contribute

Contributions are made to this repo via Issues and Pull Requests (PRs).  A few general guidelines that cover both:

- Search for existing [issues](https://github.com/Checkmarx/kics/issues) and [pull requests](https://github.com/Checkmarx/kics/pulls) before creating your own to avoid duplicates.
- PRs will only be accepted if associated with an issue (enhancement or bug) that has been submitted and reviewed/labeld as *accepted*.
- We will work hard to makes sure issues that are raised are handled in a timely manner.

### Issues

Issues should be used to report problems with the solution / source code, request a new feature, or to discuss potential changes before a PR is created. When you create a new Issue, a template will be loaded that will guide you through collecting and providing the information we need to investigate.

If you find an Issue that addresses the problem you're having, please add your own reproduction information to the existing issue rather than creating a new one. Adding a [reaction](https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/) can also help by indicating to our maintainers that a particular problem is affecting more than just the reporter.


### Pull Requests

Pull Requests (PRs) are always welcome and can be a quick way to get your fix or improvement slated for the next release. In general, PRs should:

- Only fix/add the functionality in question **or** address code style issues, not both.
- Ensure all necessary details are provided and adhered to.
- Add unit or integration tests for fixed or changed functionality (if a test suite already exists) or specify steps taken to ensure changes were tested and functionality works as expected.
- Address a single concern in the least number of changed lines as possible.
- Include documentation in the repo or Provide additional comments in Markdown comments that should be pulled/reflected in GitHub Wiki for the given project. 
- Be accompanied by a complete Pull Request template (loaded automatically when a PR is created).

For changes that address core functionality or would require breaking changes (e.g. a major release), please open an Issue to discuss your proposal first. 

### Pull Request Guidelines

Before you submit a pull request, please reassure that it meets these guidelines:

1. All validations and tests passed locally.
1. The pull request includes tests.
1. The relevant docs are updated, whether you're pushing new functionality or updating a query.

### Templates

The following templates will be used when [creating a new issue](https://github.com/Checkmarx/kics/issues/new/choose):  

- Enhancement/Feature Request Template
- New (Approved) Feature Template
- Query Template
- Bug Report Template

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
