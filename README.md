# bote

## About

bote is an open source hardware 3D-printable Eurorack case by [piruetas](https://piruetas.xyz). It holds 48 hp of 3U modules, with rails at the top and bottom where the panels are screwed in with M3 screws, and an opening in the left wall for the power bus. The design is made in OpenSCAD and uses the shared constants and modules from [popusintes-cajas-paneles](https://github.com/piruetasxyz/popusintes-cajas-paneles), included as a git submodule in `terceros/`. Hardware is licensed under CERN-OHL-P-2.0 and documentation under CC-BY-SA-4.0 (see [LICENSE.md](./LICENSE.md)).

## Acerca de

Caja eurorack imprimible en 3D de [piruetas](https://piruetas.xyz), hecha en OpenSCAD y publicada como hardware de código abierto.

## Características

- 48 hp de ancho para módulos 3U, el máximo par que cabe en la cama de una Bambu Lab X1C.
- Medidas exteriores: 248.24 × 132.8 × 94.4 mm.
- Rieles arriba y abajo con agujeros piloto cada 1 hp, donde los tornillos M3 de 6 a 12 mm hacen su propia rosca en el plástico.
- Rieles con chaflán de 45° por debajo, para imprimir sin soportes con la base sobre la cama.
- Sin lip perimetral: los paneles se apoyan solo sobre los rieles, con 0.4 mm de holgura en el asiento.
- Agujero de 90 × 20 mm en la pared izquierda para pasar el bus de poder, por ejemplo [chufebu](https://github.com/piruetasxyz/chufebu).
- Profundidad útil de 90 mm desde el piso hasta la cara inferior de los paneles.
- Nombre y versión grabados en la base.

## Revisiones

- `v0.1 rev-a`: octubre 2026, primera versión como repositorio propio. Misma geometría que bote `v0.0.11` en popusintes-cajas-paneles, donde vivía antes, pero con la profundidad útil de vuelta en 90 mm (en `v0.0.11` era 45 mm, para una prueba).
- `v0.1 rev-b`: octubre 2026, prueba de 30 hp de ancho y 80 mm de profundidad útil. Medidas exteriores: 156.8 × 132.8 × 84.4 mm. El resto de la geometría es igual a `rev-a`.
- `v0.1 rev-c`: octubre 2026, 40 hp de ancho y la misma profundidad útil de 80 mm que `rev-b`. El agujero del bus de poder pasa a estar en ambas paredes laterales y sube de 20 a 40 mm de alto. Medidas exteriores: 207.6 × 132.8 × 84.4 mm.
- `v0.1 rev-d`: noviembre 2026, misma geometría que `rev-c` pero con 60 mm de profundidad útil, suficiente para los módulos que caben en los 4ms Pods más profundos (55 mm). Agrega postes en el piso para atornillar con tornillos M3 × 6 mm la fuente [chufe](https://github.com/piruetasxyz/chufe) `v0 rev-b` (postes de 11 mm, con el jack hacia el agujero de la pared izquierda) y a su derecha el bus [chufebu](https://github.com/piruetasxyz/chufebu) `v0 rev-b` (postes de 6 mm). Los agujeros piloto de los rieles y de los postes suben de 2.6 a 2.9 mm, sin chaflán de entrada, para atornillar con los dedos, por ejemplo con knurlies de Befaco. Para elegir el diámetro antes de imprimir la caja completa está [prueba_agujeros.scad](./hardware/bote-v-0-rev-d/prueba_agujeros.scad), una placa con agujeros de 2.5 a 2.9 mm y chaflanes de entrada de 0, 0.5 y 1 mm, con la misma forma que los de los rieles. Se prueba atornillando desde arriba, el lado con los grabados, como en la caja. Los agujeros del bus de poder dejan 15 mm de pared arriba y abajo, y pasan a ser medias elipses de 90 mm de base y 34.4 mm de alto. Medidas exteriores: 207.6 × 132.8 × 64.4 mm.
- `v0.1 rev-e`: noviembre 2026, misma geometría que `rev-d`, pero los agujeros del bus de poder pasan a ser trapecios de 70 mm abajo, 35 mm arriba y 34.4 mm de alto, con esquinas redondeadas de 3 mm abajo y 6 mm arriba. Los lados quedan a ~63° de la horizontal, así que se imprimen sin soportes. Para probar cómo se imprime el agujero antes de imprimir la caja completa está [prueba_pared_bus.scad](./hardware/bote-v-0-rev-e/prueba_pared_bus.scad), un tramo de pared con el mismo alto y espesor que el de la caja. Los grabados de la base suben a 10 mm el nombre y 7 mm la versión, con las letras 15% más separadas, para que no se cierren al imprimir contra la cama. Medidas exteriores: 207.6 × 132.8 × 64.4 mm.

## Desarrollo

Clonar el repositorio con su submódulo:

```bash
git clone --recursive https://github.com/piruetasxyz/bote.git
```

Si ya estaba clonado sin `--recursive`:

```bash
git submodule update --init
```

Ejecutar este comando una vez para activar el hook de pre-commit que corrige automáticamente estilo en los archivos `.scad`:

```bash
git config core.hooksPath .githooks
```

Para exportar la caja a `.stl`:

```bash
./scripts/exportar-stl.sh
```

Esto renderiza cada revisión `hardware/bote-v-X-rev-Y/` en su carpeta de fabricación `hardware/bote-v-X-rev-Y-fab/bote_caja.stl`. También se puede exportar una sola revisión, por ejemplo `./scripts/exportar-stl.sh bote-v-0-rev-a`. Requiere tener `openscad` instalado (en Mac, si no está en el `PATH`, el script busca automáticamente `/Applications/OpenSCAD.app`).

Para actualizar la biblioteca compartida a un tag nuevo de popusintes-cajas-paneles:

```bash
git -C terceros/popusintes-cajas-paneles fetch --tags
git -C terceros/popusintes-cajas-paneles checkout <tag>
```

y después volver a exportar y revisar que la caja no cambió sin querer.

## Página

En cada push a `main`, el workflow [publicar.yml](./.github/workflows/publicar.yml) copia los `.stl` de cada carpeta `hardware/bote-v-X-rev-Y-fab/` a la página, construye [docs](./docs) con Jekyll y la publica en GitHub Pages, con un visor 3D y un enlace de descarga por revisión. Las revisiones aparecen solas apenas su carpeta `-fab` tiene un `.stl`; el título, la fecha, las medidas y la descripción de cada una van en [docs/_data/revisiones.yml](./docs/_data/revisiones.yml). Los `.stl` no se renderizan en el workflow: hay que exportarlos con `./scripts/exportar-stl.sh` y hacer commit.

La imagen que se muestra al compartir el enlace (`og:image`, 1200 × 630) es `docs/assets/prevista-<revisión>.jpg`, un render de la última revisión. Para actualizarla después de una revisión nueva (requiere `openscad` y `ffmpeg`):

```bash
./scripts/generar-prevista.sh
```

El script borra la prevista anterior y actualiza su ruta en `docs/_config.yml`. Como el nombre del archivo cambia con cada revisión, WhatsApp y otras apps muestran la imagen nueva en vez de la que tenían en caché. Después hay que hacer commit de `docs/assets/` y `docs/_config.yml`. El título, la descripción y el idioma de la prevista están en [docs/_config.yml](./docs/_config.yml).

## Estructura del repositorio

- [hardware/bote-v-0-rev-a](./hardware/bote-v-0-rev-a): archivos fuente de OpenSCAD de la caja. La versión y el ancho en hp están en [versiones.scad](./hardware/bote-v-0-rev-a/versiones.scad).
- [hardware/bote-v-0-rev-a-fab](./hardware/bote-v-0-rev-a-fab): `.stl` para imprimir la caja.
- [terceros/popusintes-cajas-paneles](https://github.com/piruetasxyz/popusintes-cajas-paneles): submódulo de git con las constantes eurorack y las funciones y módulos de OpenSCAD compartidos entre las cajas y paneles de popusintes.
- [scripts](./scripts): scripts para linting, revisión de sintaxis y exportado a `.stl`.
- [docs](./docs): página publicada en GitHub Pages, con el visor 3D de los `.stl` de cada revisión.
- [branding](./branding): logo de piruetas.
- [LICENSES](./LICENSES): textos completos de las licencias.

## Créditos

- Aarón Montoya-Moraga: concepto, programación, fabricación y documentación.
- Bernardita Jesús: revisión de parámetros, pruebas de fabricación, programación.

## Licencia

bote es (c) 2026 piruetas SpA / Aarón Montoya-Moraga.

- Hardware (`hardware/`): [CERN-OHL-P-2.0](./LICENSES/CERN-OHL-P-2.0.txt).
- Documentación (`README.md`): [CC-BY-SA-4.0](./LICENSES/CC-BY-SA-4.0.txt).
- Scripts (`scripts/`, `.githooks/`): [MIT](./LICENSES/MIT.txt).
- El nombre, logo y marca de piruetas no están cubiertos por estas licencias: ver [LicenseRef-piruetas-branding](./LICENSES/LicenseRef-piruetas-branding.txt).
- Biblioteca compartida (`terceros/popusintes-cajas-paneles`): submódulo con su propia licencia, MIT.

Ver [LICENSE.md](./LICENSE.md) para los detalles. El repositorio sigue la especificación [REUSE](https://reuse.software/).
