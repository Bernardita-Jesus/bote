// visor.js
// visor 3D de los .stl de la pagina, con three.js. cada elemento con
// atributo data-stl se convierte en un visor que se puede girar (arrastrar)
// y acercar (rueda o pellizco). los .stl se cargan recien cuando el visor
// aparece en pantalla, para no descargar todas las revisiones de una vez

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { STLLoader } from "three/addons/loaders/STLLoader.js";

const COLOR_PIEZA = 0xf2c230;

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

  function ajustarTamano() {
    const ancho = contenedor.clientWidth;
    const alto = contenedor.clientHeight;
    renderizador.setSize(ancho, alto, false);
    camara.aspect = ancho / alto;
    camara.updateProjectionMatrix();
  }
  new ResizeObserver(ajustarTamano).observe(contenedor);
  ajustarTamano();

  new STLLoader().load(
    url,
    (geometria) => {
      geometria.computeVertexNormals();
      geometria.computeBoundingBox();
      const caja = geometria.boundingBox;
      const centro = caja.getCenter(new THREE.Vector3());
      const tamano = caja.getSize(new THREE.Vector3()).length();

      const pieza = new THREE.Mesh(
        geometria,
        new THREE.MeshStandardMaterial({ color: COLOR_PIEZA, roughness: 0.6 })
      );
      escena.add(pieza);

      // vista en diagonal desde arriba y adelante
      controles.target.copy(centro);
      camara.position.copy(centro).add(new THREE.Vector3(0.55, -0.85, 0.75).multiplyScalar(tamano));
      camara.near = tamano / 100;
      camara.far = tamano * 10;
      camara.updateProjectionMatrix();
      controles.update();

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
