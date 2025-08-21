import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]

  connect() {
    this.setupPopupHandler()
    this.setupDataFetching()
  }

  setupPopupHandler() {
    const button = document.getElementById('open-unified-popup')
    if (button) {
      button.addEventListener('click', () => this.openUnifiedPopup())
    }
    
    const testButton = document.getElementById('test-connection')
    if (testButton) {
      testButton.addEventListener('click', () => this.testZendeskConnection())
    }
  }

  openUnifiedPopup() {
    const workspaceId = this.element.dataset.workspaceId || '<%= ENV["UNIFIED_WORKSPACE_ID"] %>'
    const apiKey = this.element.dataset.apiKey || '<%= ENV["UNIFIED_API_KEY"] %>'
    
    // Open Unified.to in a popup window
    const popup = window.open(
      `https://app.unified.to/embed?workspace_id=${workspaceId}&api_key=${apiKey}&popup=true`,
      'UnifiedToIntegration',
      'width=800,height=600,scrollbars=yes,resizable=yes,status=yes'
    )

    if (popup) {
      // Focus the popup
      popup.focus()
      
      // Listen for messages from the popup
      window.addEventListener('message', (event) => {
        if (event.origin === 'https://app.unified.to') {
          this.handlePopupMessage(event.data)
        }
      })

      // Check if popup was closed
      const checkClosed = setInterval(() => {
        if (popup.closed) {
          clearInterval(checkClosed)
          this.checkConnectionStatus()
        }
      }, 1000)
    } else {
      alert('Popup blocked! Please allow popups for this site.')
    }
  }

  handlePopupMessage(data) {
    console.log('Message from Unified.to popup:', data)
    
    if (data.type === 'connection_established') {
      this.updateConnectionStatus('Connection established!', 'success')
      this.storeConnectionId(data.connectionId)
    } else if (data.type === 'connection_failed') {
      this.updateConnectionStatus('Connection failed. Please try again.', 'error')
    }
  }

  updateConnectionStatus(message, type) {
    const statusElement = this.statusTarget
    if (statusElement) {
      statusElement.textContent = message
      statusElement.className = `connection-status ${type}`
    }
  }

  storeConnectionId(connectionId) {
    if (connectionId) {
      localStorage.setItem('unifiedConnectionId', connectionId)
      console.log('Connection ID stored:', connectionId)
    }
  }

  checkConnectionStatus() {
    const connectionId = localStorage.getItem('unifiedConnectionId')
    if (connectionId) {
      this.updateConnectionStatus(`Connected! ID: ${connectionId}`, 'success')
    } else {
      this.updateConnectionStatus('No active connection', 'neutral')
    }
  }

  // Test the Zendesk connection
  testZendeskConnection() {
    // Read from data attribute instead of hardcoding
    // Note: data-integrations-connection-id becomes integrationsConnectionId in Stimulus
    const connectionId = this.element.dataset.integrationsConnectionId || this.element.dataset.connectionId
    
    // Debug: Log what we're reading
    console.log('🔍 Element dataset:', this.element.dataset)
    console.log('🔍 Connection ID from dataset:', connectionId)
    console.log('🔍 Element:', this.element)
    
    if (!connectionId) {
      this.updateConnectionStatus('❌ No connection ID found. Please check environment variables.', 'error')
      return
    }
    
    this.updateConnectionStatus('Testing connection...', 'neutral')
    
    // Make a test API call to Unified.to
    fetch(`/test_zendesk_connection?connection_id=${connectionId}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.updateConnectionStatus(`✅ Connection working! ${data.message}`, 'success')
        localStorage.setItem('unifiedConnectionId', connectionId)
      } else {
        this.updateConnectionStatus(`❌ Connection failed: ${data.message}`, 'error')
      }
    })
    .catch(error => {
      this.updateConnectionStatus(`❌ Test failed: ${error.message}`, 'error')
    })
  }

  // Step 7: Fetch and display data (following tutorial pattern)
  setupDataFetching() {
    // Note: data-integrations-connection-id becomes integrationsConnectionId in Stimulus
    const connectionId = this.element.dataset.integrationsConnectionId || this.element.dataset.connectionId || '68a3859ee3ce4f6f8273b550'
    
    // Fetch Employees
    const fetchEmployeesBtn = document.getElementById('fetch-employees')
    if (fetchEmployeesBtn) {
      fetchEmployeesBtn.addEventListener('click', () => this.fetchEmployees(connectionId))
    }
    
    // Fetch Tickets
    const fetchTicketsBtn = document.getElementById('fetch-tickets')
    if (fetchTicketsBtn) {
      fetchTicketsBtn.addEventListener('click', () => this.fetchTickets(connectionId))
    }
    
    // Fetch Contacts
    const fetchContactsBtn = document.getElementById('fetch-contacts')
    if (fetchContactsBtn) {
      fetchContactsBtn.addEventListener('click', () => this.fetchContacts(connectionId))
    }
    
    // Fetch Candidates
    const fetchCandidatesBtn = document.getElementById('fetch-candidates')
    if (fetchCandidatesBtn) {
      fetchCandidatesBtn.addEventListener('click', () => this.fetchCandidates(connectionId))
    }
    
    // Debug API Response
    const debugApiBtn = document.getElementById('debug-api')
    if (debugApiBtn) {
      debugApiBtn.addEventListener('click', () => this.debugApiResponse(connectionId))
    }
    
    // Raw API Test
    const rawTestBtn = document.getElementById('raw-test')
    if (rawTestBtn) {
      rawTestBtn.addEventListener('click', () => this.rawApiTest(connectionId))
    }
    
    // Test API Key
    const testApiKeyBtn = document.getElementById('test-api-key')
    if (testApiKeyBtn) {
      testApiKeyBtn.addEventListener('click', () => this.testApiKey(connectionId))
    }
  }

  async fetchEmployees(connectionId) {
    this.showLoading('employees-list')
    
    try {
      console.log('🔍 Fetching employees for connection:', connectionId)
      const response = await fetch(`/fetch_employees?connection_id=${connectionId}`)
      const data = await response.json()
      
      console.log('📡 API Response:', data)
      
      if (data.success) {
        console.log('✅ Success! Employees data:', data.employees)
        this.displayEmployees(data.employees)
      } else {
        console.error('❌ API Error:', data.message)
        this.showError('employees-list', data.message)
      }
    } catch (error) {
      console.error('❌ Fetch Error:', error)
      this.showError('employees-list', `Error: ${error.message}`)
    }
  }

  async fetchTickets(connectionId) {
    this.showLoading('tickets-list')
    
    try {
      const response = await fetch(`/fetch_tickets?connection_id=${connectionId}`)
      const data = await response.json()
      
      if (data.success) {
        this.displayTickets(data.tickets)
      } else {
        this.showError('tickets-list', data.message)
      }
    } catch (error) {
      this.showError('tickets-list', `Error: ${error.message}`)
    }
  }

  async fetchContacts(connectionId) {
    this.showLoading('contacts-list')
    
    try {
      const response = await fetch(`/fetch_contacts?connection_id=${connectionId}`)
      const data = await response.json()
      
      if (data.success) {
        this.displayContacts(data.contacts)
      } else {
        this.showError('contacts-list', data.message)
      }
    } catch (error) {
      this.showError('contacts-list', `Error: ${error.message}`)
    }
  }

  async fetchCandidates(connectionId) {
    this.showLoading('candidates-list')
    
    try {
      const response = await fetch(`/fetch_candidates?connection_id=${connectionId}`)
      const data = await response.json()
      
      if (data.success) {
        this.displayCandidates(data.candidates)
      } else {
        this.showError('candidates-list', data.message)
      }
    } catch (error) {
      this.showError('candidates-list', `Error: ${error.message}`)
    }
  }

  // Display methods (following tutorial pattern)
  displayEmployees(employees) {
    const container = document.querySelector('#employees-list .list-content')
    const list = document.getElementById('employees-list')
    
    if (employees && employees.length > 0) {
      container.innerHTML = '<h4>Employee List:</h4>'
      
      employees.forEach((employee) => {
        const employeeElement = document.createElement('div')
        employeeElement.className = 'employee-item'
        employeeElement.innerHTML = `
          <div class="employee-avatar-container">
            <img class="employee-avatar" src="https://ui-avatars.com/api/?name=${encodeURIComponent(
              employee.name || 'na'
            )}&background=random" alt="${employee.name || 'Employee'} avatar">
            <div class="employee-info">
              <p class="employee-name">${employee.name || 'N/A'}</p>
              <p class="employee-email">${
                employee.emails?.[0]?.email || 'No email provided'
              }</p>
            </div>
          </div>
        `
        container.appendChild(employeeElement)
      })
    } else {
      container.innerHTML = '<p>No employees found or an error occurred.</p>'
    }
    
    list.style.display = 'block'
  }

  displayTickets(tickets) {
    const container = document.querySelector('#tickets-list .list-content')
    const list = document.getElementById('tickets-list')
    
    if (tickets && tickets.length > 0) {
      container.innerHTML = '<h4>Ticket List:</h4>'
      
      tickets.forEach((ticket) => {
        const ticketElement = document.createElement('div')
        ticketElement.className = 'ticket-item'
        ticketElement.innerHTML = `
          <div class="ticket-info">
            <p class="ticket-title">${ticket.title || 'N/A'}</p>
            <p class="ticket-status">Status: ${ticket.status || 'Unknown'}</p>
            <p class="ticket-priority">Priority: ${ticket.priority || 'Unknown'}</p>
          </div>
        `
        container.appendChild(ticketElement)
      })
    } else {
      container.innerHTML = '<p>No tickets found or an error occurred.</p>'
    }
    
    list.style.display = 'block'
  }

  displayContacts(contacts) {
    const container = document.querySelector('#contacts-list .list-content')
    const list = document.getElementById('contacts-list')
    
    if (contacts && contacts.length > 0) {
      container.innerHTML = '<h4>Contact List:</h4>'
      
      contacts.forEach((contact) => {
        const contactElement = document.createElement('div')
        contactElement.className = 'contact-item'
        contactElement.innerHTML = `
          <div class="contact-info">
            <p class="contact-name">${contact.name || 'N/A'}</p>
            <p class="contact-email">${contact.emails?.[0]?.email || 'No email'}</p>
            <p class="contact-phone">${contact.telephones?.[0]?.telephone || 'No phone'}</p>
          </div>
        `
        container.appendChild(contactElement)
      })
    } else {
      container.innerHTML = '<p>No contacts found or an error occurred.</p>'
    }
    
    list.style.display = 'block'
  }

  displayCandidates(candidates) {
    const container = document.querySelector('#candidates-list .list-content')
    const list = document.getElementById('candidates-list')
    
    if (candidates && candidates.length > 0) {
      container.innerHTML = '<h4>Candidate List:</h4>'
      
      candidates.forEach((candidate) => {
        const candidateElement = document.createElement('div')
        candidateElement.className = 'candidate-item'
        candidateElement.innerHTML = `
          <div class="candidate-avatar-container">
            <img class="candidate-avatar" src="https://ui-avatars.com/api/?name=${encodeURIComponent(
              candidate.name || 'na'
            )}&background=random" alt="${candidate.name || 'Candidate'} avatar">
            <div class="candidate-info">
              <p class="candidate-name">${candidate.name || 'N/A'}</p>
              <p class="candidate-email">${
                candidate.emails?.[0]?.email || 'No email provided'
              }</p>
            </div>
          </div>
        `
        container.appendChild(candidateElement)
      })
    } else {
      container.innerHTML = '<p>No candidates found or an error occurred.</p>'
    }
    
    list.style.display = 'block'
  }

  showLoading(listId) {
    const container = document.querySelector(`#${listId} .list-content`)
    container.innerHTML = '<p>Loading...</p>'
    document.getElementById(listId).style.display = 'block'
  }

  showError(listId, message) {
    const container = document.querySelector(`#${listId} .list-content`)
    container.innerHTML = `<p class="error">Error: ${message}</p>`
    document.getElementById(listId).style.display = 'block'
  }

  // Debug method to see raw API responses
  async debugApiResponse(connectionId) {
    try {
      const response = await fetch(`/debug_api_response?connection_id=${connectionId}`)
      const data = await response.json()
      
      if (data.success) {
        console.log('🔍 Debug API Response:', data)
        
        // Display debug info in a new section
        this.displayDebugInfo(data)
      } else {
        console.error('❌ Debug failed:', data.error)
        alert(`Debug failed: ${data.error}`)
      }
    } catch (error) {
      console.error('❌ Debug error:', error)
      alert(`Debug error: ${error.message}`)
    }
  }

  displayDebugInfo(debugData) {
    // Create or update debug display
    let debugSection = document.getElementById('debug-section')
    if (!debugSection) {
      debugSection = document.createElement('div')
      debugSection.id = 'debug-section'
      debugSection.className = 'debug-section'
      document.querySelector('.data-display').appendChild(debugSection)
    }
    
    debugSection.innerHTML = `
      <h3>🐛 Debug API Response</h3>
      <div class="debug-content">
        <p><strong>Connection ID:</strong> ${debugData.connection_id}</p>
        <h4>Response Types:</h4>
        <pre>${JSON.stringify(debugData.response_types, null, 2)}</pre>
        <h4>Response Keys:</h4>
        <pre>${JSON.stringify(debugData.response_keys, null, 2)}</pre>
        <h4>Full Responses:</h4>
        <pre>${JSON.stringify(debugData.responses, null, 2)}</pre>
      </div>
    `
    debugSection.style.display = 'block'
  }

  // Raw API Test - test through Rails backend to see raw response
  async rawApiTest(connectionId) {
    try {
      console.log('🔬 Starting raw API test through Rails backend...')
      
      // Test through Rails backend (which has the API key)
      const response = await fetch(`/fetch_employees?connection_id=${connectionId}`)
      
      console.log('📡 Rails Response:', response)
      console.log('📊 Response Status:', response.status)
      
      const data = await response.json()
      console.log('📦 Rails Response Data:', data)
      
      // Display raw response
      this.displayRawResponse(data)
      
    } catch (error) {
      console.error('❌ Raw API Test Error:', error)
      alert(`Raw API Test failed: ${error.message}`)
    }
  }

  displayRawResponse(data) {
    let rawSection = document.getElementById('raw-section')
    if (!rawSection) {
      rawSection = document.createElement('div')
      rawSection.id = 'raw-section'
      rawSection.className = 'raw-section'
      document.querySelector('.data-display').appendChild(rawSection)
    }
    
    rawSection.innerHTML = `
      <h3>🔬 Raw API Response</h3>
      <div class="raw-content">
        <h4>Response Type: ${typeof data}</h4>
        <h4>Is Array: ${Array.isArray(data)}</h4>
        <h4>Response Keys:</h4>
        <pre>${typeof data === 'object' ? JSON.stringify(Object.keys(data), null, 2) : 'Not an object'}</pre>
        <h4>Full Response:</h4>
        <pre>${JSON.stringify(data, null, 2)}</pre>
      </div>
    `
    rawSection.style.display = 'block'
  }

  // Test API Key functionality
  async testApiKey(connectionId) {
    try {
      console.log('🔑 Testing API Key...')
      
      // Test a simple endpoint to verify API key works
      const response = await fetch(`/test_zendesk_connection?connection_id=${connectionId}`)
      const data = await response.json()
      
      console.log('🔑 API Key Test Result:', data)
      
      if (data.success) {
        alert('✅ API Key is working! Connection successful.')
      } else {
        alert(`❌ API Key test failed: ${data.message}`)
      }
      
    } catch (error) {
      console.error('❌ API Key Test Error:', error)
      alert(`API Key test failed: ${error.message}`)
    }
  }
}
