import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  connect() {
    console.log ("Estas conectado al controlador de stimulus");
  }
}
