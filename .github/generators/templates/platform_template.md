## {{platform}} Queries List
This page contains all queries from {{platform}}.

|            Query            |Severity|Category|Description|Help|
|-----------------------------|--------|--------|-----------|----|
{%- for severity in data -%}
  {%- for id in data[severity] %}
|{{data[severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|<span style="color:{{colors[severity]}}">{{severity}}</span>|{{data[severity][id]['category'] -}}
    |{{data[severity][id]['descriptionText'] -}}
    |<a href="{{data[severity][id]['descriptionUrl']}}">Documentation</a><br/>|
  {%- endfor -%}
{%- endfor -%}