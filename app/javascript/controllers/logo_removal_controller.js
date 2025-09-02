import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  remove() {
    const hidden = document.createElement('input')
    hidden.type = 'hidden'
    hidden.name = 'challenge[remove_logo]'
    hidden.value = '1'
    this.formTarget.appendChild(hidden)
    this.formTarget.requestSubmit()
  }
}
