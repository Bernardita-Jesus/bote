// versiones.scad

// version de bote, grabada en la base de la caja. sigue el esquema de
// chufe y chufebu: v<mayor>.<menor> rev-<letra>
VERSION = "v0.1 rev-d";

BOTE_TEXTO = "bote";

// 40 hp, entre la prueba de 30 hp de rev-b y los 48 hp de rev-a
BOTE_HP = 40;

// versiones
//
// v0.1 rev-a: octubre 2026. primera version como repositorio propio.
// misma geometria que bote en popusintes-cajas-paneles v0.0.11, con
// rieles arriba y abajo con agujeros piloto M3 cada 1 hp, sin lip
// perimetral, 0.4 mm de holgura en el asiento y agujero de 90 x 20 mm
// en la pared izquierda para el bus de poder. la profundidad util
// vuelve a 90 mm, despues de la prueba de 45 mm de v0.0.11
//
// v0.1 rev-b: octubre 2026. prueba de 30 hp de ancho y 80 mm de
// profundidad util. el resto de la geometria es igual a rev-a
//
// v0.1 rev-c: octubre 2026. 40 hp de ancho, misma profundidad util
// de 80 mm que rev-b. el agujero del bus de poder pasa a estar en
// ambas paredes laterales y sube de 20 a 40 mm de alto
//
// v0.1 rev-d: noviembre 2026. misma geometria que rev-c, pero con
// 60 mm de profundidad util, suficiente para los modulos que caben
// en los 4ms pods mas profundos (55 mm). agrega postes en el piso para
// atornillar con tornillos M3 x 6 mm la fuente chufe v0 rev-b (postes
// de 11 mm, con el jack hacia el agujero de la pared izquierda) y a
// su derecha el bus chufebu v0 rev-b (postes de 6 mm). los agujeros
// piloto de los rieles y de los postes suben de 2.6 a 2.9 mm, sin
// chaflan de entrada, para atornillar con los dedos. el diametro se
// eligio imprimiendo prueba_agujeros.scad.
// los agujeros del bus de poder dejan 15 mm de pared arriba y abajo,
// y pasan a ser trapecios de 90 mm de base y 34.4 mm de alto, con
// lados a 45 grados (21.2 mm arriba) y esquinas redondeadas de 3 mm
