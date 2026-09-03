# Datos de ejemplo para desarrollo. Idempotente: solo crea si no existen.
return unless Rails.env.development?

account = Account.find_or_create_by!(name: "Ferretería Central") do |a|
  a.phone = "+595 21 000 000"
  a.address = "Av. Principal 123"
end

owner = account.users.find_or_create_by!(email: "admin@ferrecentral.com") do |u|
  u.name = "Administrador"
  u.role = :owner
  u.password = "password123"
  u.password_confirmation = "password123"
end

categories = {
  "Herramientas" => "Manuales y eléctricas",
  "Plomería" => "Tuberías y accesorios",
  "Electricidad" => "Cables, llaves y artefactos",
  "Fijaciones" => "Tornillos, bulones y anclajes",
  "Pinturas" => "Pinturas y accesorios"
}

category_records = categories.map do |name, description|
  account.categories.find_or_create_by!(name: name) { |c| c.description = description }
end

products = {
  "Taladro percutor 13mm" => [ "TAL-13", category_records[0], 450_000, 690_000, 12, 4, "unidad" ],
  "Martillo de goma 500g" => [ "MAR-500", category_records[0], 55_000, 85_000, 20, 5, "unidad" ],
  "Caño PVC 110mm x 3m" => [ "PVC-110", category_records[1], 38_000, 60_000, 30, 10, "unidad" ],
  "Cinta aislante 20m" => [ "CIN-20", category_records[2], 4_500, 8_000, 100, 20, "unidad" ],
  "Tornillo 1/4 x 2 pulg (caja)" => [ "TOR-142", category_records[3], 22_000, 38_000, 25, 6, "caja" ],
  "Lata de pintura 4L blanco" => [ "PIN-4LB", category_records[4], 120_000, 190_000, 8, 3, "lata" ]
}

product_records = products.map do |name, (sku, category, cost, price, stock, min_stock, unit)|
  account.products.find_or_create_by!(name: name) do |p|
    p.sku = sku
    p.category = category
    p.cost_price = cost
    p.price = price
    p.stock = stock
    p.min_stock = min_stock
    p.unit = unit
  end
end

normal = account.customers.find_or_create_by!(document_number: "1234567") do |c|
  c.name = "Juan Pérez"
  c.phone = "0981 123 456"
  c.address = "Barrio Centro"
end
account.customers.find_or_create_by!(document_number: "7654321") do |c|
  c.name = "María López"
  c.phone = "0971 654 321"
end

account.suppliers.find_or_create_by!(ruc: "80000000-1") do |s|
  s.name = "Distribuidora FerreMax"
  s.phone = "021 555 000"
end
account.suppliers.find_or_create_by!(ruc: "80000001-2") do |s|
  s.name = "Importadora El Tornillo"
  s.phone = "021 555 001"
end

if account.sales.none?
  sale = account.sales.new(
    customer: normal,
    user: owner,
    payment_method: :cash,
    note: "Venta de ejemplo"
  )
  product_records.first(3).each do |product|
    sale.items.build(product: product, quantity: 1, unit_price: product.price)
  end
  sale.save!
end

puts "Seeds cargados: #{account.name} / admin@ferrecentral.com / password123"