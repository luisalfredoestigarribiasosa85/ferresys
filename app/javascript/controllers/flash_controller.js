import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoHide: Boolean }

  connect() {
    if (this.autoHideValue) {
      setTimeout(() => this.dismiss(), 5000)
    }
  }

  dismiss() {
    this.element.remove()
  }
}