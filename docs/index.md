<div class="row" >
    <div class="col-6 text-center" >
        <div style="width: 100%; display: grid; place-items: center;">
                <img alt="KICS - Keeping Infrastructure as Code Secure" src="img/logo/kics_new_logo_2022_dark.png#only-light#gh-light-mode-only" width="500">
                <img alt="KICS - Keeping Infrastructure as Code Secure" src="img/logo/kics_new_logo_2022_white.png#only-dark#gh-dark-mode-only" width="500">
        </div>
        <br/>
         <br/>
        <p>Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development cycle of your infrastructure-as-code with <b>KICS</b> by Checkmarx.</p>
        <p><b>KICS</b> stands for <b>K</b>eeping <b>I</b>nfrastructure as <b>C</b>ode <b>S</b>ecure, it is open source and is a must-have for any cloud native project.</p>
    </div>
    <div class="col-6 text-center">
        <br/><br/>
        <h4>Version 2.1.13</h4>
        <p style="font-size:8pt">2025.08.12<p>
        <a class="btn btn-outline-success"  href="https://docs.kics.io/latest/CONTRIBUTING">Contribute!</a>
    </div>
</div>

---
#### Version 2.0.0 Added Features, Breaking Changes and Deprecated Queries

#### Breaking changes
- Critical severity added a [new exit status code](https://docs.kics.io/latest/results/#results_status_code)
- Terraformer removed

#### Added features
- Critical severity
- Parallel Scan (by default)

#### Deprecated Queries
Click [here](roadmap.md) to check the deprecated queries list.

---
#### Supported Platforms

KICS scans and detects issues in following Infrastructure as Code solutions:

<div style="display:flex;flex:1;flex-wrap:wrap;align-items:center;justify-content:center">
<div class="card card-interactable" style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#terraform">
                <img alt="Terraform" src="img/logo-terraform.png" width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#kubernetes">
                <img alt="Kubernetes" src="img/logo-k8s.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#docker">
                <img alt="Docker" src="img/logo-docker.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#cloudformation">
                <img alt="CloudFormation" src="img/logo-cf.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#ansible">
                <img alt="Ansible" src="img/logo-ansible.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#openapi">
                <img alt="OpenAPI" src="img/logo-openapi.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#helm">
                <img alt="Helm" src="img/logo-helm.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:120;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#grpc">
                <img alt="gRPC" src="img/logo-grpc.png"  width="120" style="min-width:120px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:150;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#cdk">
                <img alt="Cloud Deployment Kit" src="img/logo-cdk.png"  width="150" style="min-width:150px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#crossplane">
                <img alt="Crossplane" src="img/logo-crossplane.png"  width="170" style="min-width:170px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#pulumi">
                <img alt="Pulumi" src="img/logo-pulumi.png"  width="170" style="min-width:170px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#serverlessfw">
                <img alt="ServerlessFW" src="img/logo-serverlessfw.png"  width="170" style="min-width:170px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:55;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#google_deployment_manager">
                <img alt="Google Deployment Manager" src="img/logo-gdm.png"  width="55" style="min-width:55px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:55;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#azure_resource_manager">
                <img alt="Azure Resource Manager" src="img/logo-arm.png"  width="55" style="min-width:55px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:55;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#sam">
                <img alt="SAM" src="img/logo-sam.png"  width="55" style="min-width:55px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#docker_compose">
                <img alt="Docker Compose" src="img/logo-dockercompose.png"  width="80" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#knative">
                <img alt="Knative" src="img/logo-knative.png"  width="80" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#azure_blueprints">
                <img alt="Azure Blueprints" src="img/logo-azure-blueprints.png"  width="80" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#cicd">
                <img alt="GitHub Workflows" src="img/logo-github-icon.png"  width="80" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#terraform">
                <img alt="OpenTofu" src="img/logo-opentofu.png"  width="130" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#bicep">
                <img alt="Bicep" src="img/logo-bicep.png"  width="80" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
<div class="card card-interactable"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <a href="platforms/#nifcloud_for_terraform">
                <img alt="NIFCloud" src="img/logo-nifcloud.png"  width="80" style="min-width:80px">&nbsp;&nbsp;&nbsp;
        </a>
</div>
</div>

#### Beta Features
<div style="display:flex;flex:1;flex-wrap:wrap;align-items:center;justify-content:center">
<div class="card" style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <img alt="Databricks" src="img/logo-databricks.png" width="200">&nbsp;&nbsp;&nbsp;
</div>
<div class="card"  style="min-width:80;flex:0 0 25%;display:flex;align-items:center;justify-content:center;margin:8px">
        <img alt="TencentCloud" src="img/logo-tencentcloud.png" width="120">&nbsp;&nbsp;&nbsp;
</div>
</div>

By default, Databricks, NIFCloud, and TencentCloud queries run when you scan Terraform files using KICS.

The `Severity` and `Description` of these queries are still under review.

## Getting Started

Setting up and using KICS is super-easy.

-   First, see how to [install and get KICS running](getting-started.md).
-   Then explore KICS [output results format](results.md) and quickly fix the issues detected.

Interested in more advanced stuff?

-   Deep dive into KICS [queries](queries.md).
-   Understand how you to [integrate](integrations.md) KICS in your favorite CI/CD pipelines.

## How it Works

What makes KICS really powerful and popular is its built-in extensibility. This extensibility is achieved by:

-   Fully customizable and adjustable heuristics rules, called [queries](queries.md). These can be easily edited, extended and added.
-   Robust but yet simple [architecture](architecture.md), which allows quick addition of support for new Infrastructure as Code solutions.

## Contribution

KICS is a true community project. It's built as an open source project from day one and anyone can find his own way to contribute to the project.
[Check out how](CONTRIBUTING.md), within just minutes, you can start making a difference, by sharing your expertise with a community of thousands of security experts and software developers.

-   [How can I help?!](CONTRIBUTING.md)
-   <a href="https://github.com/Checkmarx/kics/" target="_blank">Take me to the repo on GitHub!</a>

## About the Project

The KICS project is powered by <a href="https://www.checkmarx.com/" target="_blank">Checkmarx</a>, global leader of Application Security Testing.
[Read more](about.md) about **Infrastructure as Code**, **Infrastructure as Code Testing** and Checkmarx.

KICS will always stay an open source and free project for the benefit of global software industry community.
We believe that when **Software is Everywhere, Security is Everything**.

Now, Software <span style="color: #5FBB46">**=**</span> **Security**.

Looking for more info? Explore KICS project in details:

-   [Roadmap](roadmap.md)
-   <a href="https://github.com/Checkmarx/kics/projects" target="_blank">Project plans</a>
-   <a href="https://github.com/Checkmarx/kics/issues" target="_blank">Issues</a>

Join the <a href="https://github.com/Checkmarx/kics/discussions" target="_blank">GitHub discussions</a>.
Or contact KICS core team at [kics@checkmarx.com](mailto:kics@checkmarx.com)
