// prueba_pared_bus.scad
// tramo de pared lateral con el agujero del bus de poder, para probar
// como se imprime antes de imprimir la caja completa. la pared tiene
// el mismo alto y espesor que la de la caja, y el agujero sale del
// mismo bote_agujero_bus_perfil() de bote_caja.scad, asi que queda a
// la misma altura de la cama. lo que mas interesa revisar es el
// puente del lado de arriba del agujero y las esquinas redondeadas
// de arriba. se imprime con el pie sobre la cama, igual que la caja

$fn = 32;

include <./bote_caja.scad>

// pared a cada lado del agujero, en el largo de la pared
PRUEBA_LADO = 10;

// pie en la base para que la pared se pare sola, como el piso de la
// caja. hacia un solo lado de la pared, que queda como la cara de
// adentro
PRUEBA_PIE = 20;

PRUEBA_TAMANO_TEXTO = 5;

module prueba_pared_bus() {
  pared = CAJA_PARED;
  alto  = bote_profundidad_ext(pared);
  largo = BOTE_AGUJERO_BUS_LARGO + 2 * PRUEBA_LADO;
  texto = str(BOTE_AGUJERO_BUS_LARGO, " / ", BOTE_AGUJERO_BUS_ARRIBA,
              " r", BOTE_AGUJERO_BUS_RADIO, "/", BOTE_AGUJERO_BUS_RADIO_ARRIBA);

  difference() {
    union() {
      // pared en el plano x-z
      cube([largo, pared, alto]);
      // pie
      cube([largo, PRUEBA_PIE, pared]);
    }

    // agujero, a BOTE_AGUJERO_BUS_MARGEN de la base como en la caja.
    // rotate lleva y 2d -> z y la extrusion -> y
    translate([PRUEBA_LADO, pared + 1, BOTE_AGUJERO_BUS_MARGEN])
      rotate([90, 0, 0])
        linear_extrude(height = pared + 2)
          bote_agujero_bus_perfil(alto);

    // medidas del agujero grabadas arriba del pie
    translate([largo / 2, pared + (PRUEBA_PIE - pared) / 2, pared - grabado_hondo])
      linear_extrude(height = grabado_hondo + 0.01)
        text(texto,
             size = PRUEBA_TAMANO_TEXTO,
             font = grabado_fuente,
             halign = "center",
             valign = "center");
  }
}

prueba_pared_bus();
