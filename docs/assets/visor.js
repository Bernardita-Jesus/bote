// visor.js
// visor 3D de los .stl de la pagina, con three.js. cada elemento con
// atributo data-stl se convierte en un visor que se puede girar (arrastrar)
// y acercar (rueda o pellizco). los .stl se cargan recien cuando el visor
// aparece en pantalla, para no descargar todas las revisiones de una vez

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { STLLoader } from "three/addons/loaders/STLLoader.js";

const COLOR_PIEZA = 0xf2c230;

// espacio alrededor de la pieza: 1 la deja justo tocando los bordes
const MARGEN = 1.25;

// direccion desde donde se mira: en diagonal desde arriba y adelante
const DIRECCION_VISTA = new THREE.Vector3(0.55, -0.85, 0.75).normalize();

function crearVisor(contenedor) {
  const url = contenedor.dataset.stl;
  const estado = contenedor.querySelector(".visor-estado");

  const escena = new THREE.Scene();
  const camara = new THREE.PerspectiveCamera(35, 1, 0.1, 5000);
  // los .stl de openscad tienen z hacia arriba
  camara.up.set(0, 0, 1);

  const renderizador = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderizador.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  contenedor.appendChild(renderizador.domElement);

  escena.add(new THREE.HemisphereLight(0xffffff, 0x666655, 2.2));
  const luz = new THREE.DirectionalLight(0xffffff, 1.6);
  luz.position.set(1, -1.5, 2);
  escena.add(luz);

  const controles = new OrbitControls(camara, renderizador.domElement);
  controles.enableDamping = true;

  // esfera que envuelve la pieza, se define cuando carga el .stl
  let esfera = null;
  // si la persona ya giro o acerco la vista, no se reencuadra al cambiar
  // el tamano de la ventana
  let movida = false;
  controles.addEventListener("start", () => { movida = true; });

  // aleja la camara lo justo para que la esfera entre completa, tanto en
  // alto como en ancho (en pantallas angostas manda el ancho)
  function encuadrar() {
    if (!esfera) return;
    const mitadVertical = THREE.MathUtils.degToRad(camara.fov / 2);
    const mitadHorizontal = Math.atan(Math.tan(mitadVertical) * camara.aspect);
    const mitad = Math.min(mitadVertical, mitadHorizontal);
    const distancia = (esfera.radius * MARGEN) / Math.sin(mitad);

    controles.target.copy(esfera.center);
    camara.position.copy(esfera.center).addScaledVector(DIRECCION_VISTA, distancia);
    camara.near = distancia / 100;
    camara.far = distancia * 10;
    camara.updateProjectionMatrix();
    controles.update();
  }

  function ajustarTamano() {
    const ancho = contenedor.clientWidth;
    const alto = contenedor.clientHeight;
    if (!ancho || !alto) return;
    renderizador.setSize(ancho, alto, false);
    camara.aspect = ancho / alto;
    camara.updateProjectionMatrix();
    if (!movida) encuadrar();
  }
  new ResizeObserver(ajustarTamano).observe(contenedor);
  ajustarTamano();

  new STLLoader().load(
    url,
    (geometria) => {
      geometria.computeVertexNormals();
      geometria.computeBoundingSphere();
      esfera = geometria.boundingSphere;

      const pieza = new THREE.Mesh(
        geometria,
        new THREE.MeshStandardMaterial({ color: COLOR_PIEZA, roughness: 0.6 })
      );
      escena.add(pieza);

      encuadrar();

      if (estado) estado.remove();
    },
    undefined,
    () => {
      if (estado) estado.textContent = "No se pudo cargar el modelo.";
    }
  );

  function animar() {
    controles.update();
    renderizador.render(escena, camara);
    requestAnimationFrame(animar);
  }
  animar();
}

const observador = new IntersectionObserver(
  (entradas) => {
    for (const entrada of entradas) {
      if (entrada.isIntersecting) {
        observador.unobserve(entrada.target);
        crearVisor(entrada.target);
      }
    }
  },
  { rootMargin: "200px" }
);

document.querySelectorAll("[data-stl]").forEach((visor) => observador.observe(visor));
