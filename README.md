# Ferresys

Sistema web **SaaS multiusuario** para el control de ventas e inventario de ferreterías.
Cada cuenta (una ferretería) tiene sus propios productos, ventas, clientes y proveedores.

## Stack

- **Rails 8.1** (Ruby 3.4) + **PostgreSQL**
- **Tailwind CSS** (vía `tailwindcss-rails`)
- **Hotwire** (Turbo + Stimulus), importmap
- Autenticación propia con `bcrypt` (sin Devise)
- Solid Queue / Solid Cache / Solid Cable (adaptadores en la misma base)
- Deploy con **Kamal** + Docker

## Funcionalidades

- Registro de cuenta (cada ferretería) y login por usuario (dueño / empleado)
- Catálogo de productos con categorías, SKU, costos, precios, stock y mínimo
- **Ventas** tipo punto de venta: líneas dinámicas, descuento, cliente y forma de pago
- Filtros de ventas por rango de fecha, cliente, forma de pago y estado
- Descuento de stock automático y trazabilidad completa vía **movimientos de stock**
- Anulación de venta con restauración de stock
- **Compras a proveedor**: suma stock y actualiza el costo promedio (costo ponderado)
- Compras, ajustes y devoluciones de inventario manuales
- **Caja diaria**: ingreso total del día desglosado por forma de pago
- Historial de movimientos embebido en la ficha de cada producto
- Clientes, proveedores y empleados
- Panel con resumen del día y alertas de stock bajo

## Puesta en marcha (local)

```bash
# Requisitos: Ruby 3.4.x, PostgreSQL en local
bundle install
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed        # datos de ejemplo
bin/dev                  # servidor + construcción de Tailwind
```

Abrir http://localhost:3000 e ingresar con las credenciales del seed:

- Email: `admin@ferrecentral.com`
- Contraseña: `password123`

## Tests

```bash
bin/rails test
bin/rubocop
bin/ci
```

## Multi-tenant

Todos los datos de negocio pertenecen a un `Account` (la ferretería vía el modelo `AccountScoped`).
El request actual expone `Current.account` (ver `app/models/current.rb`) y las consultas
siempre se filtran por la cuenta logueada.

## Producción

El deploy está preparado con Kamal (`config/deploy.yml`) apuntando a un servidor local
(`192.168.0.1`). La configuración de migraciones, credenciales y volumen de storage
se documenta en `config/deploy.yml`.