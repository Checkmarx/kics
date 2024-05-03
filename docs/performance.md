## KICS Accuracy Benchmark

The values below were obtained after scanning 150 open source projects with KICS (1.2.x) covering
the supported IaC technologies (c.f., Terraform, Ansible, Kubernetes, Docker, AWS Cloudformation).


| IaC Technology    | Query Accuracy<sup>1</sup>    | Query Coverage<sup>2</sup> | Scanned IaC files | Number of Results | Average Scan Time (s) | Average Project Size (MB) |
| :---              | :---     | :---    | :--- | :---     | :---| :---  |
| Terraform         | 99.7%    | 46%     | 1176 | 709      | 6.6  | 33.4 |
| Docker            | 98.8%    | 68%     | 1017 | 5109     | 11   | 0.7  |
| Kubernetes        | 99.3%    | 88.7%   | 6089 | 21753    | 7    | 90   |
| CloudFormation    | 95%      | 73%     | 1769 | 5343     | 10.2 | 4.8  |
| Ansible           | 100%     | 54%     | 3367 | 1320     | 23.3 | 4.1  |

---

<sup>1</sup> Query Accuracy = TP results / results

<sup>2</sup> Query Coverage = Query with results / Queries

---

<br/>

### Global Measures

|Measure                        | Value  |
| :---                          | :---   |
| **Average Accuracy**          | 98.6%  |
| **Total Number of Results**   | 34234  |
| **Average Query Coverage**    | 66.4%  |
| **Total Scanned IaC Files**   | 13418  |
| **Average Scan Time (s)**     | 11.2   |
| **Average Project Size (MB)** | 26.6   |

---
## KICS Profiling

Running Kics with `--profiling` flag will log the CPU/MEM metrics used for:

- Getting Queries
- Parsing Files
- Scanning Vulnerabilities
- Generating Reports

Keep in mind that profiling will periodically stop KICS to retrieve the wanted metrics, meaning KICS execution time will increase substantially.

---

### CPU Profiling

Flag: `--profiling CPU`

```text
9:43AM INF Scanning with Keeping Infrastructure as Code Secure dev
9:43AM INF Total CPU usage for get_queries: 6.56s <-
9:43AM INF Inspector initialized, number of queries=1385
9:43AM INF Total CPU usage for get_sources: 200.00ms <-
9:43AM INF Total CPU usage for inspect: 15.43s <-
9:43AM INF Results saved to file results/results.json fileName=results.json
9:43AM INF Results saved to file results/results.sarif fileName=results.sarif
9:43AM INF Results saved to file results/results.html fileName=results.html
9:43AM INF Total CPU usage for generate_report: 290.00ms <-
9:43AM INF Files scanned: 221
9:43AM INF Parsed files: 221
9:43AM INF Queries loaded: 1385
9:43AM INF Queries failed to execute: 0
9:43AM INF Inspector stopped
9:43AM INF Scan duration: 21.1476197s
```

---

### MEM Profiling

Flag: `--profiling MEM`

```text
9:43AM INF Scanning with Keeping Infrastructure as Code Secure dev
9:43AM INF Total MEM usage for get_queries: 237.96MB <-
9:43AM INF Inspector initialized, number of queries=1385
9:43AM INF Total MEM usage for get_sources: 280.53MB <-
9:43AM INF Total MEM usage for inspect: 335.44MB <-
9:43AM INF Results saved to file results/results.json fileName=results.json
9:43AM INF Results saved to file results/results.sarif fileName=results.sarif
9:43AM INF Results saved to file results/results.html fileName=results.html
9:43AM INF Total MEM usage for generate_report: 333.38MB <-
9:43AM INF Files scanned: 221
9:43AM INF Parsed files: 221
9:43AM INF Queries loaded: 1385
9:43AM INF Queries failed to execute: 0
9:43AM INF Inspector stopped
9:43AM INF Scan duration: 21.1476197s
```
