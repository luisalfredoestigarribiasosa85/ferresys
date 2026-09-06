import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { sales: Array }
  static targets = ["customerSelect", "saleSelect"]

  connect() {
    this.filterSales()
  }

  filterSales() {
    const customerId = this.customerSelectTarget.value
    const open = this.salesValue.filter((s) => String(s.customer_id) === customerId && s.balance > 0)
    const select = this.saleSelectTarget
    const previous = select.value

    select.innerHTML = ""

    if (open.length === 0) {
      select.disabled = true
      const opt = document.createElement("option")
      opt.textContent = "— Sin ventas a crédito pendientes —"
      select.appendChild(opt)
      this.selectValue(select, previous)
      return
    }

    select.disabled = false
    const blank = document.createElement("option")
    blank.value = ""
    blank.textContent = "— Seleccionar venta —"
    select.appendChild(blank)

    open.forEach((s) => {
      const opt = document.createElement("option")
      opt.value = s.id
      opt.textContent = `#${s.number} — Saldo ${this.format(s.balance)}`
      select.appendChild(opt)
    })

    this.selectValue(select, previous)
  }

  selectValue(select, value) {
    if (value && [ ...select.options ].some((o) => o.value === value)) {
      select.value = value
    }
  }

  format(value) {
    return `Gs. ${new Intl.NumberFormat("es").format(value)}`
  }
}