import { Controller } from "@hotwired/stimulus"
const restoreForm = (id) => {
  console.log(document.getElementById(id));
  document.getElementById(`${id}`).reset();
}

// Connects to data-controller="reset"
export default class extends Controller {
  resetForm() {
    const timer = setInterval(() => {
      document.getElementById("modal").remove();
      clearInterval(timer);
    }, 100)
  }

  commentForm(e) {
    const formId = e.target.id;
    const timer = setInterval(() => {
      restoreForm(formId);
      clearInterval(timer);
    }, 100)
  }

  answerForm() {
    const formId = "form_answers"
    const timer = setInterval(() => {
      restoreForm(formId);
      clearInterval(timer);
    }, 100)
  }
}
