import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../prisma/client/client.js";

const adaptador = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter: adaptador });

async function demostrar() {
  const categorias = await prisma.categoria.findMany();
  const inicioAntes = Date.now();
  for (const categoria of categorias) {
    await prisma.producto.findMany({ where: { idCategoria: categoria.idCategoria } });
  }
  const antes = Date.now() - inicioAntes;

  const inicioDespues = Date.now();
  await prisma.categoria.findMany({ include: { productos: true } });
  const despues = Date.now() - inicioDespues;

  console.log(JSON.stringify({ antesN1Milisegundos: antes, despuesEagerLoadingMilisegundos: despues }));
}

demostrar().finally(() => prisma.$disconnect());
