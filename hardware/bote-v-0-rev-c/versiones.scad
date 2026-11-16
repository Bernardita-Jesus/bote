// versiones.scad

// version de bote, grabada en la base de la caja. sigue el esquema de
// chufe y chufebu: v<mayor>.<menor> rev-<letra>
VERSION = "v0.1 rev-c";

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
