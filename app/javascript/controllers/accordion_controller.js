import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "header", "content"];

  toggle() {
    const content = this.contentTarget;

    if (content.classList.contains("hidden")) {
      this.buttonTarget.textContent = "-";
      this.headerTarget.classList.remove("rounded-lg")
      this.headerTarget.classList.add("rounded-t-lg")
      content.classList.remove("hidden");
    } else {
      this.headerTarget.classList.add("rounded-lg")
      this.headerTarget.classList.remove("rounded-t-lg")
      this.buttonTarget.textContent = "+";
      content.classList.add("hidden");
    }
  }
}
