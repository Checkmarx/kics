# KICS Auto Remediation

With this new feature, KICS provides auto remediation for simple replacements and simple additions in a single line.

By default, when multiple versions are supported, KICS will generate remediation based on the latest supported version of the tool (e.g., Terraform).

Note that this feature will be only available for Terraform, for now.

<p align="center">
<img width="950" alt="image" src="https://user-images.githubusercontent.com/74001161/177953750-3d279868-8cdb-44c9-86f2-379b05bb85d4.png">
</p>



## How KICS AR works?


1. As a first step, you will need to scan your project/file and generate a JSON report.

   Example: ```docker run -v /home/cosmicgirl/:/path/ kics scan -p /path/sample.tf -i "41a38329-d81b-4be4-aef4-55b2615d3282,a9dfec39-a740-4105-bbd6-721ba163c053,2bb13841-7575-439e-8e0a-cccd9ede2fa8" --no-progress -o /path/results --report-formats json```

   If KICS makes available a remediation for a result, the result will have the fields `remediation` and `remediation_type` defined. As an example, please see:
   <p align="center">
   <img width="700" alt="image" src="https://user-images.githubusercontent.com/74001161/177957089-7007d5c0-aea5-4f3a-8300-7008ab0e6312.png">
   </p>


2. If your JSON report has any result with remediation, you will need to run the new KICS command: remediate. 

   If you want KICS to remediate all the reported issues, you can run 

   ```docker run -v /home/cosmicgirl/:/path/ kics remediate --results /path/results/results.json -v```.

   If you want to specify which remediation KICS should fix, you can use the flag `--include-ids`. In this flag, you should point the `similarity_id` of the result. For example: 

   ```docker run -v /home/cosmicgirl/:/path/ kics remediate --results /path/results/results.json --include-ids "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce" -v```
