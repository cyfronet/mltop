import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    interval: Number
  }

  #timer

  connect() {
    this.#scheduleRemoval();
  }

  disconnect() {
    this.#resetTimer()
  }

  remove() {
    console.log("removing")
    this.element.remove()
  }

  // Private

  #scheduleRemoval() {
    if (!!this.intervalValue) {
      this.#timer = setTimeout(() => this.remove(), this.intervalValue * 1000)
    }
  }

  #resetTimer() {
    if(!!this.#timer) {
      clearTimeout(this.#timer)
      this.#timer = null
    }

  }
}
