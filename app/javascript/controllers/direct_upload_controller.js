import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static targets = ["input", "text"]

  connect() {
    this.originalText = this.textTarget.innerHTML
  }

  upload() {
    this.textTarget.innerHTML = "Uploading..."
    const files = Array.from(this.inputTarget.files)
    this.uploadFiles(files).then(() => {
      this.inputTarget.value = null
      this.element.closest('form').submit()
    })
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
    const allowsMultiple = this.inputTarget.hasAttribute("multiple")

    if (!allowsMultiple && files.length > 1) {
      this.addErrorMessage()
      return
    }

    this.textTarget.innerHTML = "Uploading..."
    this.uploadFiles(files).then(() => {
      this.inputTarget.value = null
      this.element.closest('form').submit()
    })
  }

  dragover(event) {
    event.preventDefault()
  }

  uploadFiles(files) {
    // Create an array of promises for all uploads
    this.uploadPromises = Array.from(files).map(file => {
      return new Promise((resolve) => {
        this.uploadFile(file, resolve)
      })
    })

    return Promise.all(this.uploadPromises)
  }

  uploadFile(file, resolve) {
    const url = this.inputTarget.dataset.directUploadUrl
    const upload = new DirectUpload(file, url)

    upload.create((error, blob) => {
      if (error) {
        // Handle the error
        console.error("Direct upload failed:", error)
      } else {
        const hiddenField = document.createElement('input')
        hiddenField.setAttribute("type", "hidden")
        hiddenField.setAttribute("value", blob.signed_id)
        hiddenField.name = this.inputTarget.name
        this.element.closest('form').appendChild(hiddenField)
        resolve()
      }
    })
  }

  addErrorMessage() {
    const errorMessage = document.createElement("div")
    errorMessage.classList.add("file-upload-error", "text-red-500", "text-sm", "ml-2", "mt-1", "opacity-100", "transition-opacity", "duration-500")
    errorMessage.textContent = "You can only upload one file."

    this.textTarget.parentElement.insertAdjacentElement("afterend", errorMessage)

    setTimeout(() => {
      errorMessage.classList.replace("opacity-100", "opacity-0")
      setTimeout(() => errorMessage.remove(), 500)
    }, 3000)
  }
}
