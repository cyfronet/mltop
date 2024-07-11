import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["testSet", "entry", "testSetEntries"];

  connect() {
    this.testSetEntries = JSON.parse(this.testSetEntriesTarget.value);
  }

  testSetChanged() {
    const selectedTestSetId = parseInt(this.testSetTarget.value);
    const selectedTestSet = this.testSetEntries.find(testSet => testSet.id === selectedTestSetId);
    
    if (selectedTestSet) {
      this.entryTarget.innerHTML = '';
      selectedTestSet.entries.forEach(entry => {
        const option = document.createElement('option');
        option.value = entry.id;
        option.text = entry.name;
        this.entryTarget.appendChild(option);
      });
    }
  }
}
