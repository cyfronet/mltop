import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "content"];

  toggle() {
    const content = this.contentTarget;

    if (content.classList.contains("hidden")) {
      content.classList.remove("hidden");
      this.buttonTarget.textContent = "-";
    } else {
      content.classList.add("hidden");
      this.buttonTarget.textContent = "+";
    }
  }
}
