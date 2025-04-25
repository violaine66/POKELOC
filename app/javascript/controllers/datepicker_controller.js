import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static values = { bookedDates: Array }

  connect() {
    const unavailableDates = this.bookedDatesValue.map(date => new Date(date)); // Transformer les dates en objets Date

    // Initialisation de flatpickr sur l'élément (le div parent)
    flatpickr(this.element.querySelectorAll("input[type='text']"), {
      disable: unavailableDates.map(date => date.toISOString().split('T')[0]), // Convertir les dates en "YYYY-MM-DD"
      onDayCreate: (dObj, dStr, fp, dayElem) => {
        const date = new Date(dayElem.dateObj);  // Créer un objet Date pour comparer les dates
        if (unavailableDates.some(unavailableDate => unavailableDate.getTime() === date.getTime())) {
          dayElem.classList.add("reserved"); // Ajouter la classe reserved si la date est réservée
        }
      }
    });
  }
}
