import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset"
export default class extends Controller {
  resetForm() {
    const timer = setInterval(() => {
      document.getElementById("modal").remove();
      clearInterval(timer);
    }, 100)
  }
}
