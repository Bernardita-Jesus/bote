// bote_caja.scad
// caja de varios modulos, con rieles arriba y abajo donde se
// atornillan los paneles. a diferencia de caja() de
// popusintes-cajas-paneles no tiene lip perimetral: los paneles
// se apoyan solo sobre los rieles

include <../../terceros/popusintes-cajas-paneles/comun/comun.scad>
include <./versiones.scad>

// profundidad util para los modulos, desde el piso hasta
// la cara inferior del panel
BOTE_PROFUNDIDAD_UTIL = 60;

// cuanto entra cada riel desde la pared, deja ~116 mm libres
// entre rieles para los pcb. el agujero piloto termina a 4.3 mm
// de la pared, quedan 1.7 mm de material
BOTE_RIEL_ANCHO = 6;

// espesor del riel bajo el panel. los agujeros piloto atraviesan
// tambien el chaflan, asi que caben tornillos M3 de 6 a 12 mm
BOTE_RIEL_ESPESOR = 5;

// diametro de todos los agujeros piloto M3 de la caja: los de los
// rieles para los paneles y los de los postes para chufe y chufebu.
// mas grande que ROSCA_DIAMETRO_PILOTO (2.6 mm) para que los
// tornillos (por ejemplo befaco knurlies) se puedan atornillar y
// desatornillar con los dedos. todavia hacen una rosca suave en el
// plastico, porque los agujeros impresos salen ~0.1 mm mas chicos
BOTE_DIAMETRO_PILOTO = 2.9;

// chaflan de entrada arriba de cada agujero de los rieles. en 0 no
// hay chaflan: en la prueba con prueba_agujeros.scad de rev-d el
// agujero de 2.9 mm sin chaflan fue el unico comodo para atornillar
// con los dedos desde arriba
BOTE_RIEL_CHAFLAN_ENTRADA = 0;

// juego total del asiento de los paneles, en x y en y
BOTE_HOLGURA = 0.4;

// agujero en ambas paredes laterales para pasar el bus de poder,
// centrado en cada pared. el alto se calcula para dejar
// BOTE_AGUJERO_BUS_MARGEN de pared arriba y abajo del agujero
// (con 64.4 mm de alto exterior el agujero queda de 34.4 mm)
BOTE_AGUJERO_BUS_LARGO = 70;
BOTE_AGUJERO_BUS_MARGEN = 15;

// el agujero es un trapecio: base de BOTE_AGUJERO_BUS_LARGO abajo y
// lado de arriba de este largo, centrado. con 70 y 35 mm y 34.4 mm de
// alto los lados quedan a ~63 grados de la horizontal, mas empinados
// que 45, asi que se imprimen sin soportes
BOTE_AGUJERO_BUS_ARRIBA = 35;

// radio de las 2 esquinas de abajo y de las 2 de arriba del
// trapecio. las de arriba son obtusas y con el mismo radio se ven
// casi en punta, por eso llevan un radio mayor
BOTE_AGUJERO_BUS_RADIO = 3;
BOTE_AGUJERO_BUS_RADIO_ARRIBA = 6;

// el tornillo izquierdo de cada panel queda a MARGEN_X del borde
// y el derecho a MARGEN_X del otro borde, por eso los derechos
// caen desplazados de la grilla de los izquierdos en esta cantidad
// (0.24 mm). los agujeros piloto se alargan en x para cubrir ambos
BOTE_DESFASE_TORNILLOS = 3 * MODULO_ANCHO - 2 * MARGEN_X;

// postes en el piso para atornillar la fuente chufe v0 rev-b y el
// bus chufebu v0 rev-b, uno al lado del otro en x: chufe a la
// izquierda con su jack hacia el agujero de la pared izquierda, y
// chufebu a su derecha. las medidas son [en x, en y] en la caja

// chufe: placa de 50 x 65 mm, 4 agujeros M3 a 5 mm de cada borde
BOTE_CHUFE_PLACA = [50, 65];
BOTE_CHUFE_AGUJEROS = [40, 55];

// el jack de chufe sobresale 4.6 mm del borde izquierdo de la placa.
// su centro queda a 50.36 mm del borde de la placa con y menor en la
// caja (a 14.64 mm del borde de arriba en kicad, que tiene y hacia
// abajo). la placa se ubica para que el jack quede centrado en el
// agujero de la pared, a BOTE_CHUFE_JACK_HOLGURA de la pared
BOTE_CHUFE_JACK_SOBRESALE = 4.6;
BOTE_CHUFE_JACK_Y = 50.36;
BOTE_CHUFE_JACK_HOLGURA = 1;

// chufe va mas alto que chufebu para que el enchufe del jack pase
// sobre el borde de abajo del agujero de la pared (a 15 mm de la
// base). con 11 mm el centro del jack queda a ~21 mm de la base,
// suponiendo que el centro del jack esta a ~6.5 mm sobre la placa
BOTE_CHUFE_POSTE_ALTURA = 11;

// chufebu: placa de 100 x 40 mm, 4 agujeros M3 a 5 mm de cada
// esquina, centrada en y
BOTE_CHUFEBU_PLACA = [100, 40];
BOTE_CHUFEBU_AGUJEROS = [90, 30];

// alto de los postes de chufebu sobre el piso. deja espacio para las
// patas de los headers bajo la placa
BOTE_CHUFEBU_POSTE_ALTURA = 6;

// espacio en x entre el borde de chufe y el de chufebu
BOTE_SEPARACION_PLACAS = 5;

// con tornillos M3 x 6 mm y placas de 1.6 mm quedan ~4.4 mm de
// rosca en el plastico
BOTE_POSTE_DIAMETRO = 7;

// base conica de los postes, para que no se quiebren en la union
// con el piso. 45 grados, se imprime sin soportes
BOTE_POSTE_BASE = 1.5;

// alto exterior de la caja: piso, profundidad util y panel
function bote_profundidad_ext(pared = CAJA_PARED) =
  pared + BOTE_PROFUNDIDAD_UTIL + PANEL_PROFUNDIDAD;

// perfil 2d del agujero del bus de poder: trapecio con la base larga
// abajo y las esquinas redondeadas, con el origen en la esquina de
// abajo a la izquierda. la caja se imprime con la base sobre la cama:
// los lados suben inclinados y el lado de arriba queda como un puente
// recto. lo usan bote_caja() y prueba_pared_bus.scad
module bote_agujero_bus_perfil(profundidad_ext) {
  largo = BOTE_AGUJERO_BUS_LARGO;
  alto  = profundidad_ext - 2 * BOTE_AGUJERO_BUS_MARGEN;
  // cuanto entra cada lado del trapecio en x, de abajo hacia arriba
  entrada = (largo - BOTE_AGUJERO_BUS_ARRIBA) / 2;
  r_abajo  = BOTE_AGUJERO_BUS_RADIO;
  r_arriba = BOTE_AGUJERO_BUS_RADIO_ARRIBA;
  // angulo de los lados respecto a la horizontal
  a = atan2(alto, entrada);
  // centro del circulo de cada esquina de la izquierda, tangente a
  // los dos lados que llegan a esa esquina. las de la derecha son el
  // espejo. abajo la esquina mide a, arriba 180 - a
  x_abajo  = r_abajo / tan(a / 2);
  x_arriba = entrada + r_arriba * tan(a / 2);
  assert(x_arriba < largo / 2,
         "el lado de arriba del agujero del bus queda muy corto para su radio");
  // el trapecio es convexo, asi que el hull de los 4 circulos es el
  // trapecio con las esquinas redondeadas, sin mover los lados rectos
  hull()
    for (x = [0, largo], esquina = [[x_abajo, r_abajo, r_abajo],
                                    [x_arriba, alto - r_arriba, r_arriba]])
      translate([x == 0 ? esquina[0] : largo - esquina[0], esquina[1]])
        circle(r = esquina[2], $fn = 48);
}

module bote_caja(
    hp,
    texto = BOTE_TEXTO,
    version = VERSION,
    pared = CAJA_PARED,
    radio_esquina = 1.5,
    tamano_texto = MODULO_ALTURA_3U * 0.05,
    tamano_version = MODULO_ALTURA_3U * 0.035
) {

  ancho_int  = MODULO_ANCHO * hp + BOTE_HOLGURA;
  altura_int = MODULO_ALTURA_3U + BOTE_HOLGURA;

  ancho_ext  = 2 * pared + ancho_int;
  altura_ext = 2 * pared + altura_int;

  // cara superior de los rieles = cara inferior de los paneles
  z_rieles = pared + BOTE_PROFUNDIDAD_UTIL;
  // los paneles quedan al ras del borde de la caja
  profundidad_ext = z_rieles + PANEL_PROFUNDIDAD;

  // origen de los paneles, centrados en la holgura
  x_paneles = pared + BOTE_HOLGURA / 2;
  y_paneles = pared + BOTE_HOLGURA / 2;

  // riel con chaflan de 45 grados por debajo, para imprimir sin
  // soportes con la base sobre la cama. y_pared es la y de la pared
  // donde se apoya, sentido es +1 (riel inferior) o -1 (superior)
  module riel(y_pared, sentido) {
    y_bloque = sentido > 0 ? y_pared : y_pared - BOTE_RIEL_ANCHO;
    y_filo   = sentido > 0 ? y_pared : y_pared - 0.01;
    hull() {
      translate([pared, y_bloque, z_rieles - BOTE_RIEL_ESPESOR])
        cube([ancho_int, BOTE_RIEL_ANCHO, BOTE_RIEL_ESPESOR]);
      translate([pared, y_filo, z_rieles - BOTE_RIEL_ESPESOR - BOTE_RIEL_ANCHO])
        cube([ancho_int, 0.01, BOTE_RIEL_ANCHO]);
    }
  }

  // agujeros piloto cada 1 hp, para que los tornillos M3 hagan
  // su propia rosca en el plastico, con un chaflan de entrada arriba
  module agujeros_piloto() {
    ultimo = floor((ancho_int - BOTE_HOLGURA - 2 * MARGEN_X - BOTE_DESFASE_TORNILLOS) / MODULO_ANCHO + 0.001);
    d = BOTE_DIAMETRO_PILOTO;
    c = BOTE_RIEL_CHAFLAN_ENTRADA;
    for (k = [0 : ultimo])
      for (y = [MARGEN_Y, MODULO_ALTURA_3U - MARGEN_Y])
        hull()
          for (dx = [0, BOTE_DESFASE_TORNILLOS])
            translate([x_paneles + MARGEN_X + k * MODULO_ANCHO + dx, y_paneles + y, 0]) {
              translate([0, 0, z_rieles - BOTE_RIEL_ESPESOR - BOTE_RIEL_ANCHO - 1])
                cylinder(h = BOTE_RIEL_ESPESOR + BOTE_RIEL_ANCHO + 2, d = d, $fn = 24);
              if (c > 0)
                translate([0, 0, z_rieles - c])
                  cylinder(h = c + 0.01, d1 = d, d2 = d + 2 * c, $fn = 24);
            }
  }

  // esquina [x, y] de cada placa en la caja
  chufe_esquina = [pared + BOTE_CHUFE_JACK_HOLGURA + BOTE_CHUFE_JACK_SOBRESALE,
                   altura_ext/2 - BOTE_CHUFE_JACK_Y];
  chufebu_esquina = [chufe_esquina[0] + BOTE_CHUFE_PLACA[0] + BOTE_SEPARACION_PLACAS,
                     altura_ext/2 - BOTE_CHUFEBU_PLACA[1]/2];
  assert(chufebu_esquina[0] + BOTE_CHUFEBU_PLACA[0] <= pared + ancho_int,
         "chufe y chufebu no caben uno al lado del otro");

  // 4 postes [x, y, alto] centrados en la placa
  function postes_placa(esquina, placa, agujeros, alto) = [
    for (sx = [-1, 1], sy = [-1, 1])
      [esquina[0] + placa[0]/2 + sx * agujeros[0]/2,
       esquina[1] + placa[1]/2 + sy * agujeros[1]/2,
       alto]
  ];

  postes = concat(
    postes_placa(chufe_esquina, BOTE_CHUFE_PLACA,
                 BOTE_CHUFE_AGUJEROS, BOTE_CHUFE_POSTE_ALTURA),
    postes_placa(chufebu_esquina, BOTE_CHUFEBU_PLACA,
                 BOTE_CHUFEBU_AGUJEROS, BOTE_CHUFEBU_POSTE_ALTURA)
  );

  module poste(alto) {
    // parte desde un poco dentro del piso para que se una bien
    translate([0, 0, pared - 0.01]) {
      cylinder(h = alto + 0.01, d = BOTE_POSTE_DIAMETRO);
      cylinder(h = BOTE_POSTE_BASE + 0.01,
               d1 = BOTE_POSTE_DIAMETRO + 2 * BOTE_POSTE_BASE,
               d2 = BOTE_POSTE_DIAMETRO);
    }
  }

  // agujero del bus de poder en el plano y-z, extruido en x
  module agujero_bus(espesor) {
    // rotate lleva x 2d -> y, y 2d -> z, y la extrusion -> x
    rotate([90, 0, 90])
      linear_extrude(height = espesor)
        bote_agujero_bus_perfil(profundidad_ext);
  }

  difference() {
    union() {
      difference() {
        caja_redondeada(ancho_ext, altura_ext, profundidad_ext, radio_esquina);
        translate([pared, pared, pared])
          cube([ancho_int, altura_int, profundidad_ext]);
      }
      riel(pared, 1);
      riel(pared + altura_int, -1);

      for (p = postes)
        translate([p[0], p[1], 0]) poste(p[2]);
    }

    agujeros_piloto();

    // agujeros piloto de los postes, ciegos: no atraviesan el piso
    for (p = postes)
      translate([p[0], p[1], pared])
        cylinder(h = p[2] + 1, d = BOTE_DIAMETRO_PILOTO, $fn = 24);

    // agujeros del bus de poder en las paredes izquierda y derecha
    for (x = [-1, ancho_ext - pared - 1])
      translate([x,
                 altura_ext/2 - BOTE_AGUJERO_BUS_LARGO/2,
                 BOTE_AGUJERO_BUS_MARGEN])
        agujero_bus(pared + 2);

    // grabados en la base
    texto_base(texto,   tamano_texto,   ancho_ext/2, 40*altura_ext/100);
    texto_base(version, tamano_version, ancho_ext/2, 60*altura_ext/100);
  }
}
