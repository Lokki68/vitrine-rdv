import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static values = { url: String }

    load(event) {
        const date = event.target.value

        if (!date) return

        const frame = document.getElementById("slots")
        frame.src = `${this.urlValue}&date=${date}`
    }
}