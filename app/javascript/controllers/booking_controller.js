import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["startsAt"]
  static values = { slotsUrl: String }

  loadSlots(event) {
    const url = new URL(this.slotsUrlValue, window.location.origin)
    url.searchParams.set('date', event.target.value)
    document.getElementById('slots').src = url.toString()
  }

  select(event) {
    this.startsAtTarget.value = event.params.iso
    this.element.querySelectorAll('button').forEach(btn => btn.classlist.remove('btn-active'))
    event.currentTarget.classList.add('btn-active')
  }
}

