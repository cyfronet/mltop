import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["from", "to", "evaluators"];

  connect() { }

  updateEvaluators() {
    const fromValue = this.fromTarget.value;
    const toValue = this.toTarget.value;

    fetch(`/evaluators?from=${fromValue}&to=${toValue}`)
      .then(response => response.json())
      .then(data => {
        this.populateEvaluators(data);
      })
      .catch(error => console.error("Error fetching evaluators:", error));
  }

  populateEvaluators(evaluators) {
    this.evaluatorsTarget.innerHTML = "";

    evaluators.forEach(evaluator => {
      const option = document.createElement("option");
      option.value = evaluator.id;
      option.textContent = evaluator.name;
      this.evaluatorsTarget.appendChild(option);
    });
  }
}
