import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calculate-total-price"
export default class extends Controller {
  static targets = ["startdate", "enddate", "pricePerDay", "totalprice"]

  connect() {
    console.log("CalculateTotalPriceController connected!");
  }

  calculatePrice() {
    const startDate = new Date(this.startdateTarget.value);
    const endDate = new Date(this.enddateTarget.value);
    const pricePerDay = parseFloat(this.pricePerDayTarget.value) || 0; // Prix par jour
    const totalPriceElement = this.totalpriceTarget;

    // Vérifier si les dates sont valides
    if (isNaN(startDate) || isNaN(endDate) || startDate >= endDate) {
      console.log("Invalid dates");
      totalPriceElement.textContent = "0 €";
      totalPriceElement.style.display = "none"; // Cache si les dates sont invalides
      return;
    }

    // Calcul du nombre de jours (inclure les jours de début et de fin)
    const diffTime = Math.abs(endDate - startDate);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // Ajouter +1 pour inclure les 2 jours (début et fin)

    console.log("Number of Days:", diffDays);

    // Calcul du prix total
    const totalPrice = diffDays * pricePerDay;

    console.log("Total Price:", totalPrice);

    // Mise à jour du prix total à afficher
    totalPriceElement.textContent = totalPrice.toFixed(2) + " €";
    totalPriceElement.style.display = "inline"; // Affiche le prix total
  }
}
