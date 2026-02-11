import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open(event) {
    if (event) event.preventDefault();


    if (this.modalTarget) {
      this.modalTarget.classList.remove("hidden");
      document.body.style.overflow = "hidden";
    }
  }

  close(event) {
    if (event) event.preventDefault();

    if (this.modalTarget) {
      this.modalTarget.classList.add("hidden");
      document.body.style.overflow = "auto";
      console.log("Successfully closed modal");
    }
  }
}
