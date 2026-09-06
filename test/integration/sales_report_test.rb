require "test_helper"

class SalesReportTest < ActionDispatch::IntegrationTest
  setup do
    sign_in(users(:owner_one))
  end

  test "shows kpis and breakdowns for the current month" do
    get sales_report_reports_path

    assert_response :success
    assert_match(/Reporte de ventas/, response.body)
    assert_match(/97.000/, response.body)
    assert_match(/Cemento 50kg/, response.body)
    assert_match(/Destornillador plano/, response.body)
    assert_match(/Construcción/, response.body)
    assert_match(/Dueño Uno/, response.body)
    assert_match(/Exportar CSV/, response.body)
  end

  test "shows profit and margin for the period" do
    get sales_report_reports_path

    assert_response :success
    assert_match(/Ganancia bruta/, response.body)
    assert_match(/32.000/, response.body)   # (85000 - 60000) + (12000 - 5000)
    assert_match(/33/, response.body)        # margen aprox 32.99% del total 97000
  end

  test "exportar csv with the sales detail" do
    get sales_report_reports_path(format: :csv)

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_match(/ventas_/, response.headers[ "Content-Disposition" ])
    assert_match(/N°;Fecha;Cliente;Producto;Cantidad;Precio unitario;Subtotal/, response.body)
    assert_match(/Juan Pérez;Cemento 50kg;1/, response.body)
    assert_match(/Destornillador plano/, response.body)
  end

  test "filters the report by date range" do
    get sales_report_reports_path, params: { from: 2.months.ago.to_date, to: 45.days.ago.to_date }

    assert_response :success
    assert_no_match(/Cemento 50kg/, response.body)
    assert_match(/No hubo ventas en este período/, response.body)
  end

  private

  def sign_in(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end