## Queries List
This page contains all queries.

 |            Query            |Platform|Severity|Category|More info|
|-----------------------------|---|---|---|---|
{%- for platform in data %}
{%- for sub_platform in data[platform] -%}
  {%- for severity in data[platform][sub_platform] -%}
    {%- for id in data[platform][sub_platform][severity] %}
|{{data[platform][sub_platform][severity][id]['queryName']}}<br/><sup><sub>{{id}}</sub></sup>|{{platform -}}
    |<span style="color:{{colors[severity]}}">{{severity}}</span>|{{data[platform][sub_platform][severity][id]['category'] -}}
    |{{data[platform][sub_platform][severity][id]['descriptionText'] -}}<br><a href="{{data[platform][sub_platform][severity][id]['descriptionUrl']}}">Documentation</a><br/>|
    {%- endfor -%}
  {%- endfor -%}
{%- endfor -%}
{%- endfor -%}
