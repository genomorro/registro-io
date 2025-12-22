import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['field'];
    static values = {
        condition: String,
    }

    connect() {
        this.toggle();
    }

    toggle(event) {
        const selectedValue = event ? event.currentTarget.value : this.element.querySelector('select, input[type="radio"]:checked, input[type="checkbox"]:checked')?.value;

        if (selectedValue === this.conditionValue) {
            this.fieldTarget.classList.remove('d-none');
        } else {
            this.fieldTarget.classList.add('d-none');
        }
    }
}
