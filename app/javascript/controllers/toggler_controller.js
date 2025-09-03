import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle"]
  static classes = ["toggle"]

  toggle() {
    this.toggleTargets.forEach(element => {
      this.toggleClasses.forEach(klass => {
        element.classList.toggle(klass)
      })
    })
  }
}
