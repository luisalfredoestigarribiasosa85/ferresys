require "test_helper"
require "stringio"

class ProductImporterTest < ActiveSupport::TestCase
  setup do
    Current.account = accounts(:one)
  end

  teardown { Current.reset }

  def importer_for(csv_body)
    file = ActionDispatch::Http::UploadedFile.new(
      tempfile: StringIO.new(csv_body),
      filename: "productos.csv",
      type: "text/csv"
    )
    ProductImporter.new(file, account: accounts(:one))
  end

  test "imports valid rows and creates products" do
    csv = <<~CSV
      nombre,sku,categoria,costo,precio,stock,minimo,unidad
      Clavo 2 pulgadas,CLA-2,Sujeciones,15000,25000,100,20,caja
      Cemento 25kg,CEM-25,Construccion,30000,45000,40,5,bolsa
    CSV

    importer = importer_for(csv)
    importer.preview
    assert_equal 2, importer.valid_rows.count

    importer.import!
    assert_equal 2, importer.imported_count
    assert_empty importer.errors

    product = accounts(:one).products.find_by(sku: "CLA-2")
    assert_equal "Clavo 2 pulgadas", product.name
    assert_equal 15000, product.cost_price
    assert_equal 25000, product.price
    assert_equal 100, product.stock
    assert_equal 20, product.min_stock
    assert_equal "caja", product.unit
    assert_equal "Sujeciones", product.category.name
  end

  test "skips malformed rows and reports errors" do
    csv = <<~CSV
      nombre,sku,categoria,costo,precio,stock,minimo,unidad
      ,CLA-2,,15000,25000,100,20,caja
      Tornillo,TOR-1,,abc,25000,3,1,unidad
      Bulon,BUL-1,,10000,20000,10,2,unidad
    CSV

    importer = importer_for(csv)
    importer.preview

    assert_equal 1, importer.valid_rows.count
    importer.import!
    assert_equal 1, importer.imported_count
    assert_equal 2, importer.errors.count
  end

  test "creates category on the fly and normalizes accents in headers" do
    csv = <<~CSV
      NOMBRE,SKU,CATEGORÍA,COSTO,PRECIO,STOCK,MÍNIMO,UNIDAD
      Pintura Latex,PIN-1,Pinturas,50000,80000,10,3,lata
    CSV

    importer = importer_for(csv)
    importer.import!
    assert_equal 1, importer.imported_count
    assert accounts(:one).categories.where(name: "Pinturas").exists?
  end
end