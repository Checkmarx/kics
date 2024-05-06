# KICS Auto Scanning Extension for Visual Studio Code
Checkmarx’s KICS Auto Scanning extension for VS Code initiates KICS scans directly from their VS Code console. The scan runs automatically whenever an infrastructure file of a supported type is saved, either manually or by auto-save. The scan runs only on the file that is open in the editor.

The results are shown in the VS Code console, making it easy to remediate the vulnerabilities that are detected.

> 📝 KICS (Keeping Infrastructure as Code Secure) is a free, open source solution developed by Checkmarx and the open source community for static code analysis of IaC. KICS automatically parses common IaC files to detect insecure configurations that could expose your applications, data, or services to attack. KICS finds security vulnerabilities, compliance issues, and infrastructure misconfigurations in the following IaC solutions: Terraform, Kubernetes, Docker, AWS CloudFormation, Ansible, and Helm.
> See <a href="https://checkmarx.com/product/opensource/kics-open-source-infrastructure-as-code-project/">KICS - Open Source Solution</a>



>❗️This is a free tool provided by Checkmarx for all VS Code users, and does **not** require the user to submit credentials for a Checkmarx AST account. This feature is bundled together with the **Checkmarx** extension, which is used by authenticated AST users to import scan results into their VS Code IDE.  

The plugin is available on marketplace. In addition, the code can be accessed <a href="https://github.com/Checkmarx/ast-vscode-extension">here</a>.

# Main Features
Free tool, no Checkmarx account required

Run scans directly from your IDE

Scans are triggered automatically whenever a file is saved

# Prerequisites
You must have Docker installed and running in your environment

# Installing the KICS Auto Scanning Extension
**To install the extension from marketplace:**

1. Open Visual Studio Code.
2. In the main navigation, click on the **Extensions** icon.
3. Search for the **Checkmarx** plugin, then click **Install** for the plugin.

![plugin_install](https://user-images.githubusercontent.com/105008282/182109202-7585a4fc-c0ea-44bf-9496-2209ae602a4e.png)


The Checkmarx extension is installed and the Checkmarx icon appears in the left-side navigation panel.

![checkmarx_extension](https://user-images.githubusercontent.com/105008282/182109554-ce6451d8-d357-4219-ad59-8b20fec4bf3b.png)



# Configuring the Extension
The extension is activated automatically upon installation and no configuration is required. 

>❗️It is not necessary to configure the Checkmarx AST Authentication settings in order to use the KICS Auto Scanning feature.

If you would like to customize the scan settings, you can use the following procedure:

1. In the VS Code console, go to **Settings > Extensions > Checkmarx > Checkmarx KICS Auto Scanning.**
![checkmarx_kics_auto_scanning](https://user-images.githubusercontent.com/105008282/182109584-88f5ca31-c5c8-497f-a023-633951132ccc.png)



2. By default the extension is configured to run a KICS scan whenever an infrastructure file of a [supported type](platforms.md) that is open in your editor is saved. If you would like to disable automatic scanning, deselect the **Activate KICS Auto Scanning** checkbox. 
**NOTE** In this case, you will still be able to trigger scans manually from the command palette, as described below.

3. If you would like to customize the scan parameters, enter the desire flags in the **Additional Parameters** field. For a list of available options, see Scan Command Options.

# Triggering a Scan Manually
You can trigger a scan manually for the file that is open in your editor by opening the command palette and entering  Checkmarx-ast: Run kics realtime scan ( you can enter search text and select the command).

# Viewing KICS Results 
## Viewing the Results Summary
When a scan is completed, a summary of the number of vulnerabilities identified by severity level is shown in the OUTPUT section of the VS Code console. 

Example of results summary:

```hcl
1: CxINFO - 2:04:47 PM]Results summary:
2:                     Total Results": 141,
3:                     "CRITICAL": 0,
4:                     "HIGH": 10,
5:                     "INFO": 4,
6:                     "LOW": 62,
7:                     "MEDIUM": 65
```

## Viewing KICS Vulnerability Details
Detailed information about the vulnerabilities that were detected is shown in the file editor window. The vulnerable code is highlighted according the severity level of the vulnerability, as follows:

- Critical - pure red
- High - red
- Medium - orange
- Info - green
- Low - blue

Hover over the vulnerable code to show a tooltip with detailed info about the vulnerability. 

![vulnerabilities](https://user-images.githubusercontent.com/105008282/182109633-0510aa5a-ded0-4287-8bd9-681d6da9185d.png)

## YouTube Demo
 https://youtu.be/sFD-9CQXfs0

