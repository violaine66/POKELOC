import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    if (this.map) {
      console.log("Carte déjà chargée, on stoppe ici !");
      return;
    }

    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      zoom: 8,
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()

  }
  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div");
      customMarker.innerHTML = marker.marker_html;

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
        .setPopup(popup)
    })
  }
  #fitMapToMarkers() {
  const bounds = new mapboxgl.LngLatBounds();

  if (this.markersValue.length === 0) {
    console.log("Aucun marqueur trouvé, affichage par défaut.");
    this.map.setZoom(2); // Zoom par défaut si aucun marqueur
    return;
  }

  this.markersValue.forEach(marker => {
    if (marker.lng && marker.lat) { // Vérifie que les coordonnées existent
      bounds.extend([marker.lng, marker.lat]);
    }
  });

  if (this.markersValue.length === 1) {
    this.map.setCenter([this.markersValue[0].lng, this.markersValue[0].lat]);
    this.map.setZoom(12); // Zoom plus proche si un seul Pokémon
  } else {
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 12, duration: 1000 });
  }
}

}
