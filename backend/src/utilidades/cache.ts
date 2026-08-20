type Entrada<T> = {
  valor: T;
  expira: number;
};

class CacheMemoria<T> {
  private readonly datos = new Map<string, Entrada<T>>();
  private readonly ttl = 60_000;

  obtener(clave: string): T | undefined {
    const entrada = this.datos.get(clave);
    if (!entrada) return undefined;
    if (entrada.expira <= Date.now()) {
      this.datos.delete(clave);
      return undefined;
    }
    return entrada.valor;
  }

  guardar(clave: string, valor: T) {
    this.datos.set(clave, { valor, expira: Date.now() + this.ttl });
  }

  limpiar() {
    this.datos.clear();
  }
}

export const cacheProductos = new CacheMemoria<Record<string, unknown>>();
