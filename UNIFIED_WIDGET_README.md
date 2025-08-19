# Unified.to Widget Integration

This Rails application now includes a Unified.to widget that can be embedded into your pages.

## What Was Created

### 1. **Stimulus Controller** (`app/javascript/controllers/unified_widget_controller.js`)
- Converts the JavaScript `embedAuthorizationComponent()` function to a Stimulus controller
- Automatically loads the Unified.to script when the controller connects
- Configurable workspace ID and environment

### 2. **Unified Embed Widget** (Official Method)
- Direct iframe integration using Unified.to's official embed URL
- Simpler approach with no JavaScript required
- Real-time connection management through the iframe

### 3. **View Template** (`app/views/unified_widget/index.html.erb`)
- HTML structure for both widget approaches
- Includes the necessary `unified_widget` div that the Unified.to script looks for
- **NEW**: Unified.to official embed iframe for direct integration
- Displays configuration information

### 4. **Controller** (`app/controllers/unified_widget_controller.rb`)
- Handles the widget page requests

### 5. **Routes** (`config/routes.rb`)
- Added `/unified-widget` route
- Set as root route for easy testing

### 6. **Styling** (`app/assets/stylesheets/unified_widget.css`)
- Basic CSS for the widget container
- Styling for the Unified.to embed iframe

## Setup Instructions

### 1. **Add to your `.env` file:**
```bash
# Unified.to Widget Configuration
UNIFIED_WORKSPACE_ID=689afc1d4c76c2728e09b014
UNIFIED_ENVIRONMENT=Sandbox
UNIFIED_API_KEY=your_api_key_here
```

### 2. **Test the Widget:**
```bash
# Start your Rails server
bin/rails server

# Visit: http://localhost:3000
# or: http://localhost:3000/unified-widget
```

### 3. **Test the Zendesk Integration:**
```bash
# Visit: http://localhost:3000/integrations
# This is the main integration page for Zendesk
```

**Note:** The workspace ID `689afc1d4c76c2728e09b014` was extracted from your JWT token.

### 2. **Test the Widget:**
```bash
# Start your Rails server
bin/rails server

# Visit: http://localhost:3000
# or: http://localhost:3000/unified-widget
```

## How It Works

### **Approach 1: JavaScript Widget (Stimulus Controller)**
1. **Page Loads**: The Stimulus controller automatically connects
2. **Script Injection**: Creates and injects the Unified.to script tag
3. **Widget Rendering**: The script finds the `unified_widget` div and renders the component
4. **Configuration**: Uses environment variables for workspace ID and environment
5. **Connection Handling**: Automatically detects and stores connection IDs from URL parameters
6. **Local Storage**: Saves connection IDs for later use across page refreshes

### **Approach 2: Official Embed Widget (Recommended)**
1. **Direct Integration**: Uses Unified.to's official embed iframe
2. **Real-time Management**: Connection management happens directly in the iframe
3. **No JavaScript Required**: Simpler implementation with fewer moving parts
4. **Official Support**: Backed by Unified.to's official documentation

**Note**: If the embed iframe fails to load, a fallback message will be displayed, and you can use the JavaScript widget approach instead.

## Key Differences from JavaScript Version

| JavaScript | Ruby/Rails |
|------------|------------|
| `UNIFIED_WORKSPACE_ID` | `ENV['UNIFIED_WORKSPACE_ID']` |
| `document.addEventListener` | Stimulus `connect()` method |
| Manual script injection | Automatic via Stimulus controller |
| Global function | Encapsulated in controller |

## Troubleshooting

- **Widget not loading**: Check browser console for errors
- **Missing workspace ID**: Verify `UNIFIED_WORKSPACE_ID` in `.env`
- **Script errors**: Check if `https://api.unified.to/docs/unified.js` is accessible

### **Embed Widget Issues:**
- **Iframe not loading**: The embed URL might be incorrect or the service might be down
- **Fallback message**: If you see "Embed Widget Unavailable", use the JavaScript widget instead
- **Alternative URLs**: Try different embed URLs if the default one fails
- **Contact support**: Reach out to Unified.to support for the correct embed URL

## Complete Zendesk Integration Workflow

### **Step 1: Access the Integration Page**
Visit `http://localhost:3000/integrations` to see the Zendesk integration widget.

### **Step 2: Connect Zendesk Account**
1. **Click Zendesk** inside the Unified.to widget
2. **Log in** with your Zendesk account credentials
3. **Authorize** the connection between Unified.to and Zendesk

### **Step 3: Get Connection ID**
After successful connection, Unified.to will provide a connection ID that you can use in your Rails app.

### **Step 4: Use the Connection ID**
Use the `ZendeskService` class to interact with Zendesk data:

```ruby
# Initialize service with connection ID
service = ZendeskService.new("your_connection_id")

# Get Zendesk tickets
tickets = service.get_tickets

# Get Zendesk contacts
contacts = service.get_contacts

# Create a new ticket
ticket_data = {
  title: "New Support Request",
  description: "Customer needs help with...",
  priority: "high"
}
new_ticket = service.create_ticket(ticket_data)
```

## Next Steps

### **Recommended Approach: Use the Official Embed Widget**
The **Unified.to official embed iframe** is the recommended approach because:
- ✅ **Simpler implementation** - no custom JavaScript required
- ✅ **Official support** - backed by Unified.to documentation
- ✅ **Real-time updates** - connection management happens automatically
- ✅ **Better reliability** - maintained by Unified.to team

### **Customization Options:**
1. **Customize the widget appearance** by modifying the CSS
2. **Adjust iframe dimensions** (currently 600px height)
3. **Integrate with your existing Zendesk functionality**
4. **Add error handling and loading states**
5. **Use the connection ID** in your Zendesk integration logic
6. **Add webhook handling** for real-time connection updates

## Connection Handling Features

### **Automatic Detection**
- Detects connection IDs from URL parameters when users return from Unified.to
- Stores connection IDs in localStorage for persistence
- Updates UI status automatically

### **Available Methods**
- `getConnectionId()` - Retrieve stored connection ID
- `clearConnectionId()` - Remove stored connection ID
- `hasActiveConnection()` - Check if connection exists
- `handleConnectionCallback()` - Process URL parameters

### **Event Dispatching**
- Emits `connectionCreated` event when new connections are detected
- Other parts of your app can listen for these events
- Enables reactive updates across your application
