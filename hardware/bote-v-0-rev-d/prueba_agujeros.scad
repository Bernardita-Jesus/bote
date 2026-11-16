// prueba_agujeros.scad
// barra de prueba para elegir el diametro de los agujeros piloto de
// los rieles, antes de imprimir la caja completa. cada agujero tiene
// la misma forma que en los rieles de bote_caja.scad (alargado en x
// por BOTE_DESFASE_TORNILLOS y con chaflan de entrada arriba) y su
// diametro grabado al lado. se imprime con la base sobre la cama,
// igual que la caja, para que los agujeros salgan con la misma
// orientacion

$fn = 32;

include <./bote_caja.scad>

// diametros a probar, en mm
PRUEBA_DIAMETROS = [2.7, 2.8, 2.9, 3.0, 3.1];

// distancia entre agujeros
PRUEBA_PASO = 12;

// alto de la barra. en la caja, bajo cada agujero hay ~7.8 mm de
// plastico: los 5 mm del riel mas ~2.8 mm del chaflan en ese punto
PRUEBA_ALTO = 8;

// ancho de la barra en y: agujero adelante, grabado atras
PRUEBA_ANCHO = 14;
PRUEBA_Y_AGUJERO = 4.5;
PRUEBA_Y_TEXTO = 10.5;
PRUEBA_TAMANO_TEXTO = 3;

// diametro con un decimal, para que 3 se grabe como 3.0
function con_un_decimal(d) =
  let (decimas = round(d * 10))
    str(floor(decimas / 10), ".", decimas % 10);

module agujero_prueba(d) {
  c = BOTE_RIEL_CHAFLAN_ENTRADA;
  hull()
    for (dx = [0, BOTE_DESFASE_TORNILLOS]) {
      translate([dx, 0, -1])
        cylinder(h = PRUEBA_ALTO + 2, d = d, $fn = 24);
      translate([dx, 0, PRUEBA_ALTO - c])
        cylinder(h = c + 0.01, d1 = d, d2 = d + 2 * c, $fn = 24);
    }
}

module prueba_agujeros() {
  n = len(PRUEBA_DIAMETROS);
  largo = n * PRUEBA_PASO;
  difference() {
    cube([largo, PRUEBA_ANCHO, PRUEBA_ALTO]);
    for (i = [0 : n - 1]) {
      x = PRUEBA_PASO / 2 + i * PRUEBA_PASO;
      translate([x, PRUEBA_Y_AGUJERO, 0])
        agujero_prueba(PRUEBA_DIAMETROS[i]);
      // grabado arriba, se lee mirando la barra desde arriba
      translate([x, PRUEBA_Y_TEXTO, PRUEBA_ALTO - grabado_hondo])
        linear_extrude(height = grabado_hondo + 0.01)
          text(con_un_decimal(PRUEBA_DIAMETROS[i]),
               size = PRUEBA_TAMANO_TEXTO,
               font = grabado_fuente,
               halign = "center",
               valign = "center");
    }
  }
}

prueba_agujeros();
