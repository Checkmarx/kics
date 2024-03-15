## Integrate KICS with Terraform Cloud

You can integrate KICS into Terraform Cloud as a Task Event Hook.

This provides you the ability to run a KICS scan on the plan in the pre-apply stage.

### Configuring KICS as a Task Event Hook

To Configure Task Event Hook go to:

Organization Settings -> Integrations -> Task Event Hook -> Create Event Hook

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/create_event_hook_tfcloud.png" width="850">

Set the name you wish for the Task Event Hook

In the Hook endpoint URL place:

```
https://kics.io/tfc/event?failOn=low
```

And Create event hook.

Note: You can choose which kind of severity you wish for KICS to fail on by passing `failOn` as query parameter in the URL. KICS will fail on any result found with that severity and above.

Available Severities are:

 - critical
 - high
 - medium
 - low
 - info

Query parameter `failOn` is required and cannot be empty.


### Adding KICS Event Hook to Workspace

To add KICS Event Hook as a Task to your Workspace go to:

Workspace Settings -> Tasks -> Available Event Hooks and Choose KICS Event Hook you just created

<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/create_workspace_task.png" width="850">

Choose the Enforcement Level and press Create

And now every time a new plan is started KICS will scan this plan for Vulnerabilities and missconfigurations

### Example Results

Task Failed
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/task_failed_tfcloud.png" width="850">

To see KICS Scan report press `Details` to download the html report and see all vulnerabilities found by KICS

Please keep in mind the report link is only active for 15 minutes

Task Passed
<img src="https://raw.githubusercontent.com/Checkmarx/kics/master/docs/img/task_success_tfcloud.png" width="850">
