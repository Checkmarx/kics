## {{platform}} Queries List
This page contains all queries from {{platform}}, classified by severity level.
{% for severity in data %}
### Severity: <span style="color:{{colors[severity]}}">**{{severity}}**</span>

|            Query            |Category|Description|Help|
|-----------------------------|---|---|---|
{% for id in data[severity] %}|{{data[severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|{{data[severity][id]['category']}}|{{data[severity][id]['descriptionText']}}|{% for url in data[severity][id]['descriptionUrl'] %}<a href="{{url}}">Documentation</a><br/>{% endfor %}|
{% endfor %}
{% endfor %}