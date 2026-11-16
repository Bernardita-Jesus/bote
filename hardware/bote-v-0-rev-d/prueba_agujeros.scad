// prueba_agujeros.scad
// placa de prueba para elegir el diametro de los agujeros piloto de
// los rieles y el tamano del chaflan de entrada, antes de imprimir la
// caja completa. cada columna es un diametro y cada fila un chaflan.
// los agujeros tienen la misma forma que en los rieles de
// bote_caja.scad (alargados en x por BOTE_DESFASE_TORNILLOS, con el
// chaflan arriba). se imprime con la base sobre la cama, igual que la
// caja, y se prueba atornillando desde arriba (el lado con los
// grabados), que es como se atornillan los paneles en la caja

$fn = 32;

include <./bote_caja.scad>

// diametros a probar, en mm, uno por columna. para tornillos M3:
// 3.0 y 3.1 quedaron muy sueltos en la primera prueba
PRUEBA_DIAMETROS = [2.5, 2.6, 2.7, 2.8, 2.9];

// chaflanes de entrada a probar, en mm, uno por fila
PRUEBA_CHAFLANES = [0, 0.5, 1.0];

// distancia entre agujeros, en x y en y
PRUEBA_PASO = [12, 10];

// alto de la placa. en la caja, bajo cada agujero hay ~7.8 mm de
// plastico: los 5 mm del riel mas ~2.8 mm del chaflan en ese punto
PRUEBA_ALTO = 8;

// franjas para los grabados: a la izquierda los chaflanes y atras
// los diametros
PRUEBA_MARGEN_TEXTO = [12, 7];
PRUEBA_TAMANO_TEXTO = 3;

// numero con un decimal, para que 3 se grabe como 3.0
function con_un_decimal(d) =
  let (decimas = round(d * 10))
    str(floor(decimas / 10), ".", decimas % 10);

module agujero_prueba(d, c) {
  hull()
    for (dx = [0, BOTE_DESFASE_TORNILLOS]) {
      translate([dx, 0, -1])
        cylinder(h = PRUEBA_ALTO + 2, d = d, $fn = 24);
      if (c > 0)
        translate([dx, 0, PRUEBA_ALTO - c])
          cylinder(h = c + 0.01, d1 = d, d2 = d + 2 * c, $fn = 24);
    }
}

module grabado(texto, x, y) {
  translate([x, y, PRUEBA_ALTO - grabado_hondo])
    linear_extrude(height = grabado_hondo + 0.01)
      text(texto,
           size = PRUEBA_TAMANO_TEXTO,
           font = grabado_fuente,
           halign = "center",
           valign = "center");
}

module prueba_agujeros() {
  columnas = len(PRUEBA_DIAMETROS);
  filas = len(PRUEBA_CHAFLANES);
  largo = PRUEBA_MARGEN_TEXTO[0] + columnas * PRUEBA_PASO[0];
  ancho = filas * PRUEBA_PASO[1] + PRUEBA_MARGEN_TEXTO[1];

  // centro del agujero de la columna i y la fila j. la fila 0 queda
  // adelante (y chico)
  function x_columna(i) = PRUEBA_MARGEN_TEXTO[0] + PRUEBA_PASO[0] * (i + 0.5);
  function y_fila(j) = PRUEBA_PASO[1] * (j + 0.5);

  difference() {
    cube([largo, ancho, PRUEBA_ALTO]);

    for (i = [0 : columnas - 1], j = [0 : filas - 1])
      translate([x_columna(i), y_fila(j), 0])
        agujero_prueba(PRUEBA_DIAMETROS[i], PRUEBA_CHAFLANES[j]);

    // diametro arriba de cada columna
    for (i = [0 : columnas - 1])
      grabado(con_un_decimal(PRUEBA_DIAMETROS[i]),
              x_columna(i), filas * PRUEBA_PASO[1] + PRUEBA_MARGEN_TEXTO[1] / 2);

    // chaflan a la izquierda de cada fila
    for (j = [0 : filas - 1])
      grabado(con_un_decimal(PRUEBA_CHAFLANES[j]),
              PRUEBA_MARGEN_TEXTO[0] / 2, y_fila(j));
  }
}

prueba_agujeros();
