import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["audio"];

  connect() {
    // S'assure que l'audio est préchargé
    this.audioTarget.load();
  }

  playMusic(event) {
    event.preventDefault();


    this.audioTarget.play();


    const duration = this.audioTarget.duration;
    setTimeout(() => {
      window.location.href = event.target.href;
    }, duration * 1000);
  }
}
