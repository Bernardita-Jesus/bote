---
title: bote
---

<style>
.revision { border: 1px solid #d0d7de; border-radius: 8px; padding: 1rem 1.25rem; margin: 1.5rem 0; }
.revision.ultima { border: 2px solid #f2c230; }
.revision h3 { margin-top: 0; }
.etiqueta { display: inline-block; background: #f2c230; color: #222; font-size: 0.75em; font-weight: bold; border-radius: 4px; padding: 0.1em 0.5em; margin-left: 0.5em; vertical-align: middle; }
.visor { position: relative; width: 100%; aspect-ratio: 4 / 3; background: #f6f8fa; border-radius: 6px; overflow: hidden; touch-action: none; }
.visor canvas { display: block; width: 100%; height: 100%; }
.visor-estado { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; color: #57606a; }
.descargas { margin-top: 0.75rem; }
</style>

Caja eurorack imprimible en 3D de [piruetas](https://piruetas.xyz), hecha en OpenSCAD y publicada como hardware de código abierto. Código fuente en [github.com/piruetasxyz/bote](https://github.com/piruetasxyz/bote).

## Revisiones

Cada revisión tiene su `.stl` para imprimir. El visor se puede girar arrastrando y acercar con la rueda del mouse o pellizcando.

{% assign stls = site.static_files | where: "extname", ".stl" %}
{% assign carpetas = "" | split: "" %}
{% for archivo in stls %}{% assign partes = archivo.path | split: "/" %}{% assign carpetas = carpetas | push: partes[2] %}{% endfor %}
{% assign carpetas = carpetas | uniq | sort | reverse %}

{% if carpetas.size == 0 %}
Todavía no hay archivos `.stl` publicados.
{% endif %}

{% for carpeta in carpetas %}
{% assign datos = site.data.revisiones[carpeta] %}
{% assign ruta = "/stl/" | append: carpeta | append: "/" %}
{% assign archivos = stls | where_exp: "a", "a.path contains ruta" %}
{% assign caja = archivos | where: "name", "bote_caja.stl" | first %}
{% if caja == nil %}{% assign caja = archivos | first %}{% endif %}
<section class="revision{% if forloop.first %} ultima{% endif %}" id="{{ carpeta }}">
<h3>{% if datos.titulo %}{{ datos.titulo }}{% else %}{{ carpeta }}{% endif %}{% if forloop.first %}<span class="etiqueta">última revisión</span>{% endif %}</h3>
{% if datos.fecha or datos.medidas %}<p>{% if datos.fecha %}{{ datos.fecha | capitalize }}.{% endif %}{% if datos.medidas %} Medidas exteriores: {{ datos.medidas }}.{% endif %}</p>{% endif %}
{% if datos.descripcion %}<p>{{ datos.descripcion }}</p>{% endif %}
<div class="visor" data-stl="{{ caja.path | relative_url }}"><div class="visor-estado">Cargando modelo…</div></div>
<ul class="descargas">
{% for archivo in archivos %}
<li><a href="{{ archivo.path | relative_url }}" download>{{ archivo.name }}</a>{% if datos.archivos[archivo.name] %}: {{ datos.archivos[archivo.name] }}{% endif %}</li>
{% endfor %}
</ul>
</section>
{% endfor %}

<script type="importmap">
{
  "imports": {
    "three": "https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js",
    "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.160.0/examples/jsm/"
  }
}
</script>
<script type="module" src="{{ '/assets/visor.js' | relative_url }}"></script>
