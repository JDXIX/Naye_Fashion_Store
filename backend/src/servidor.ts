import express from "express";

const aplicacion = express();
const puerto = Number(process.env.PORT) || 3000;

aplicacion.get("/api/salud", (_solicitud, respuesta) => {
  respuesta.status(200).json({
    exito: true,
    mensaje: "API de Naye Fashion Store disponible"
  });
});

aplicacion.listen(puerto, () => {
  console.log(`Servidor ejecutándose en el puerto ${puerto}`);
});
