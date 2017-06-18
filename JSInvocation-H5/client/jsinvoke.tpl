{% extends "common:page/layout.tpl" %}

{% block css %}
	{% require "home:static/css/iosclipboard.less" %}
{% endblock %}

{% block content %}
<script type="text/javascript" src= "../static/js/lib/rem.js"></script>
</script>
<div class="content" id="wrapper">
    <div class="testOpen">testJS</div>
</div>
{% endblock%}

{% block endscript %}
{% require "home:static/js/jsinvoke.js" %}
<script>
   
</script>

{% endblock %}