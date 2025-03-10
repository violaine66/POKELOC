import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="audio"
export default class extends Controller {
  static targets = [ "btnAudio" ]
  connect() {
  }
  playMusic(event) {
    event.preventDefault()

   if (this.btnAudioTarget.play) {
      this.btnAudioTarget.play();
      const duration = this.btnAudioTarget.duration;
      setTimeout(() => {
        window.location.href = event.target.href;
      }, duration * 1000);
    }
  }
}
