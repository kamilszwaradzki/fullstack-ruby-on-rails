import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const selectedTab = event.currentTarget
    const targetId = selectedTab.dataset.tabsTargetPanel

    this.tabTargets.forEach(tab => {
      tab.classList.remove("border-blue-600", "text-blue-600")
      tab.classList.add("border-transparent", "text-gray-500")
      tab.setAttribute("aria-selected", "false")
    })

    selectedTab.classList.remove("border-transparent", "text-gray-500")
    selectedTab.classList.add("border-blue-600", "text-blue-600")
    selectedTab.setAttribute("aria-selected", "true")

    this.panelTargets.forEach(panel => {
      panel.classList.toggle("hidden", panel.id !== targetId)
    })
  }
}