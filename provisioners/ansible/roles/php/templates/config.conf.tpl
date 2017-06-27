{% for sectionName in config %}
[{{sectionName}}]
{% for configName in config[sectionName] %}
{{configName}}= {{config[sectionName][configName]}}
{% endfor %}
{% endfor %}