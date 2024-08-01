import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["testSet", "entry", "testSetEntries"];

  connect() {
    this.loadEntries();
  }

  loadEntries() {
    const testSetId = this.testSetTarget.value;

    fetch(`/admin/test_sets/${testSetId}/entries`, {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      this.entryTarget.innerHTML = '';

      data.forEach(entry => {
        const option = document.createElement('option');
        option.value = entry.id;
        option.text = entry.name;
        this.entryTarget.appendChild(option);
      });
    });
  }

  testSetChanged() {
    this.loadEntries();
  }
}
