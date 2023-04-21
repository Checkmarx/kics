## Integrate KICS with Terraform Cloud

You can integrate KICS into Terraform Cloud as a Run task.

This provides you the ability to run a KICS scan on the plan in the pre-plan, post-plan and pre-apply stages.

### Configuring KICS as a Run task

To Configure Run task go to:

Organization Settings -> Integrations -> Run tasks -> Create run task

<img src="https://user-images.githubusercontent.com/111127232/233617645-8a620963-408c-43d3-b956-404528e18299.png" width="850">

Set the name you wish for the Run task

In the Endpoint URL place:

```
https://kics.io/tfc/event?failOn=low
```

And Create Run task.

Note: You can choose which kind of severity you wish for KICS to fail on by passing `failOn` as query parameter in the URL. KICS will fail on any result found with that severity and above.

Available Severities are:
 - high
 - medium
 - low
 - info

Query parameter `failOn` is required and cannot be empty.


### Adding KICS Run task to Workspace

To add KICS Run task to your Workspace go to:

Workspace Settings -> Run Tasks -> Choose KICS Run task you just created

<img src="https://user-images.githubusercontent.com/111127232/233622300-14c12aa4-0cfc-40cf-a28b-f32ba72bf616.png" width="850">

Choose the Run stage and Enforcement Level and press Create

<img src="https://user-images.githubusercontent.com/111127232/233622915-ac1dd509-aa63-4b36-b2ab-b565bab66163.png" width="850">

And now every time a new plan is started KICS will scan this plan for Vulnerabilities and missconfigurations.