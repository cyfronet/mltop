import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static targets = ["input", "text"]

  connect() {
    this.originalText = this.textTarget.innerHTML
  }

  upload() {
    this.textTarget.innerHTML = "Uploading..."
    Array.from(this.inputTarget.files).forEach(file => {
      this.uploadFile(file)
    })
    this.element.closest('form').submit()
  }

  dragenter(event) {
    event.preventDefault()
    this.textTarget.innerHTML = "Drop to upload"
  }

  dragleave(event) {
    event.preventDefault()
    this.textTarget.innerHTML = this.originalText
  }

  drop(event) {
    event.preventDefault()
    const files = event.dataTransfer.files
    this.textTarget.innerHTML = "Uploading..."
    Array.from(files).forEach(file => {
      this.uploadFile(file)
    })
    this.element.closest('form').submit()
  }

  dragover(event) {
    event.preventDefault()
  }

  uploadFile(file) {
    const url = this.inputTarget.dataset.directUploadUrl
    const upload = new DirectUpload(file, url)

    upload.create((error, blob) => {
      if (error) {
        // Handle the error
        console.error("Direct upload failed:", error)
      } else {
        this.inputTarget.setAttribute("type", "hidden")
        this.inputTarget.setAttribute("value", blob.signed_id)
      }
    })
  }
}
