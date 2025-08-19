import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    workspaceId: String,
    environment: { type: String, default: "Sandbox" }
  }

  static targets = ["status"]

  connect() {
    this.embedAuthorizationComponent()
  }

  embedAuthorizationComponent() {
    const script = document.createElement('script')
    script.src = `https://api.unified.to/docs/unified.js?wid=${this.workspaceIdValue}&did=unified_widget&env=${this.environmentValue}`
    script.async = true
    
    script.onload = () => {
      console.log('Unified.to component script loaded successfully')
      // Set up connection callback handler after script loads
      this.handleConnectionCallback()
    }
    
    script.onerror = () => {
      console.error('Failed to load Unified.to component script')
    }
    
    // The script will search the DOM for a div with the id "unified_widget"
    document.body.appendChild(script)
  }

  handleConnectionCallback() {
    const urlParams = new URLSearchParams(window.location.search)
    const connectionId = urlParams.get('id')

    if (connectionId) {
      console.log('New connection created:', connectionId)
      
      // Store the connectionId for later use
      localStorage.setItem('unifiedConnectionId', connectionId)
      
      // You can also emit a custom event for other parts of your app
      this.dispatch('connectionCreated', { detail: { connectionId } })
      
      // Update status if status target exists
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = `Connection created: ${connectionId}`
        this.statusTarget.classList.add('success')
      }
    } else {
      console.log('No connection ID found in URL parameters')
    }
  }

  // Get the stored connection ID
  getConnectionId() {
    const connectionId = localStorage.getItem('unifiedConnectionId')
    console.log('Getting connection ID:', connectionId)
    
    if (this.hasStatusTarget) {
      if (connectionId) {
        this.statusTarget.textContent = `Connection ID: ${connectionId}`
        this.statusTarget.classList.add('success')
      } else {
        this.statusTarget.textContent = 'No connection ID found'
        this.statusTarget.classList.remove('success')
      }
    }
    
    return connectionId
  }

  // Clear the stored connection ID
  clearConnectionId() {
    localStorage.removeItem('unifiedConnectionId')
    console.log('Connection ID cleared from localStorage')
    
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = 'No active connection'
      this.statusTarget.classList.remove('success')
    }
  }

  // Check if there's an active connection
  hasActiveConnection() {
    const hasConnection = !!this.getConnectionId()
    console.log('Has active connection:', hasConnection)
    
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = hasConnection ? 'Active connection found' : 'No active connection'
      this.statusTarget.classList.toggle('success', hasConnection)
    }
    
    return hasConnection
  }
}
