## KICS Benchmark

The values below were obtained after scanning 150 open source projects with KICS (v1.2.0) covering
the supported IaC technologies (c.f., Terraform, Ansible, Kubernetes, Docker, AWS Cloudformation).


| IaC Technology    | Query Accuracy<sup>1</sup>    | Query Coverage<sup>2</sup> | Scanned IaC files​ | Number of Results​ | Average Scan Time​ (s) | Average Project Size (MB) |
| :---              | :---     | :---    | :--- | :---     | :---| :---|
| Terraform​         | 99.7%​    | 46%     | 1176​ | 709      | 6.6  | 33.4​ |
| Docker​            | 98.8%​​    | 68%​     | 1017​ | 5109     | 11   | 0.7 |​
| Kubernetes​        | 99.3%​​    | 88.7%​   | 6089​ | 21753    | 7    | 90 |​
| CloudFormation​    | 95%​      | 73%​     | 1769​ | 5343     | 10.2 | 4.8 |​
| Ansible ​          | 100%     |​ 54%​     | 3367​ | 1320     | 23.3 | 4.1 |​

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



