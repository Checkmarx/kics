## {{platform}} Queries List
This page contains all queries from {{platform}}, classified by severity level.
{% for severity in data %}
### <span style="color:{{colors[severity]}}">**{{severity}}**</span>

|Query name|Category|Query description|Help|
|---|---|---|---|
{% for id in data[severity] %}|{{data[severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|{{data[severity][id]['category']}}|{{data[severity][id]['descriptionText']}}|{% for url in data[severity][id]['descriptionUrl'] %}<a href="{{url}}">{{url}}</a><br/>{% endfor %}|
{% endfor %}
{% endfor %}