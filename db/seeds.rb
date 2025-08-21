# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database with demo data..."

# Create demo integrations
puts "🔗 Creating demo integrations..."

integrations = [
  {
    name: "Zendesk Support",
    platform_type: "ticketing",
    unified_connection_id: "demo_zendesk_001",
    status: "active",
    connection_metadata: {
      description: "Customer support platform for WhatsApp users",
      api_version: "v2",
      features: ["tickets", "customers", "agents"]
    },
    api_endpoints: {
      tickets: "/ticketing/demo_zendesk_001/tickets",
      customers: "/ticketing/demo_zendesk_001/customers",
      agents: "/ticketing/demo_zendesk_001/agents"
    },
    is_demo_data: true
  },
  {
    name: "HR1 System",
    platform_type: "hris",
    unified_connection_id: "demo_hr1_001",
    status: "active",
    connection_metadata: {
      description: "HR system for some YouTube users",
      api_version: "v1",
      features: ["employees", "departments", "roles"]
    },
    api_endpoints: {
      employees: "/hris/demo_hr1_001/employee",
      departments: "/hris/demo_hr1_001/department",
      roles: "/hris/demo_hr1_001/role"
    },
    is_demo_data: true
  },
  {
    name: "HR2 System",
    platform_type: "hris",
    unified_connection_id: "demo_hr2_001",
    status: "active",
    connection_metadata: {
      description: "HR system for other YouTube users",
      api_version: "v1",
      features: ["employees", "departments", "roles"]
    },
    api_endpoints: {
      employees: "/hris/demo_hr2_001/employee",
      departments: "/hris/demo_hr2_001/department",
      roles: "/hris/demo_hr2_001/role"
    },
    is_demo_data: true
  },
  {
    name: "HR3 System",
    platform_type: "hris",
    unified_connection_id: "demo_hr3_001",
    status: "active",
    connection_metadata: {
      description: "HR system for other YouTube users",
      api_version: "v1",
      features: ["employees", "departments", "roles"]
    },
    api_endpoints: {
      employees: "/hris/demo_hr3_001/employee",
      departments: "/hris/demo_hr3_001/department",
      roles: "/hris/demo_hr3_001/role"
    },
    is_demo_data: true
  },
  {
    name: "YouTube Analytics",
    platform_type: "passthrough",
    unified_connection_id: "demo_youtube_001",
    status: "active",
    connection_metadata: {
      description: "YouTube content platform for all users",
      api_version: "v3",
      features: ["users", "channels", "analytics"]
    },
    api_endpoints: {
      users: "/passthrough/demo_youtube_001/youtube/users",
      channels: "/passthrough/demo_youtube_001/youtube/channels",
      analytics: "/passthrough/demo_youtube_001/youtube/analytics"
    },
    is_demo_data: true
  }
]

integrations.each do |integration_data|
  Integration.find_or_create_by!(unified_connection_id: integration_data[:unified_connection_id]) do |integration|
    integration.assign_attributes(integration_data)
  end
end

puts "✅ Created #{Integration.count} integrations"

# Create demo platform users
puts "👥 Creating demo platform users..."

demo_users = [
  # HR1 Users
  {
    email: "john.doe@abc.com",
    name: "John Doe",
    phone: "+1-555-0101",
    platform_source: "hr1",
    employment_status: "ACTIVE",
    department: "Engineering",
    job_title: "Senior Software Developer",
    platform_data: {
      employee_id: "EMP001",
      hire_date: "2023-01-15",
      salary: "$95,000",
      skills: ["Ruby", "Rails", "JavaScript", "React"],
      manager: "Sarah Johnson",
      location: "San Francisco, CA"
    },
    unified_profile: {
      email: "john.doe@abc.com",
      name: "John Doe",
      phone: "+1-555-0101",
      employment_status: "ACTIVE",
      department: "Engineering",
      job_title: "Senior Software Developer",
      hr_systems: ["hr1"],
      support_tickets: [],
      youtube_channel: "TechWithJohn"
    },
    is_demo_user: true
  },
  {
    email: "alice.chen@abc.com",
    name: "Alice Chen",
    phone: "+1-555-0102",
    platform_source: "hr1",
    employment_status: "ACTIVE",
    department: "Engineering",
    job_title: "Frontend Developer",
    platform_data: {
      employee_id: "EMP002",
      hire_date: "2023-03-20",
      salary: "$85,000",
      skills: ["JavaScript", "React", "Vue.js", "CSS"],
      manager: "John Doe",
      location: "San Francisco, CA"
    },
    unified_profile: {
      email: "alice.chen@abc.com",
      name: "Alice Chen",
      phone: "+1-555-0102",
      employment_status: "ACTIVE",
      department: "Engineering",
      job_title: "Frontend Developer",
      hr_systems: ["hr1"],
      support_tickets: [],
      youtube_channel: "AliceCodes"
    },
    is_demo_user: true
  },
  
  # HR2 Users
  {
    email: "jane.smith@abc.com",
    name: "Jane Smith",
    phone: "+1-555-0201",
    platform_source: "hr2",
    employment_status: "ACTIVE",
    department: "Marketing",
    job_title: "Marketing Manager",
    platform_data: {
      employee_id: "EMP101",
      hire_date: "2022-11-10",
      salary: "$110,000",
      skills: ["Digital Marketing", "SEO", "Social Media", "Analytics"],
      manager: "Mike Wilson",
      location: "New York, NY"
    },
    unified_profile: {
      email: "jane.smith@abc.com",
      name: "Jane Smith",
      phone: "+1-555-0201",
      employment_status: "ACTIVE",
      department: "Marketing",
      job_title: "Marketing Manager",
      hr_systems: ["hr2"],
      support_tickets: [],
      youtube_channel: "MarketingWithJane"
    },
    is_demo_user: true
  },
  {
    email: "david.brown@abc.com",
    name: "David Brown",
    phone: "+1-555-0202",
    platform_source: "hr2",
    employment_status: "ACTIVE",
    department: "Marketing",
    job_title: "Content Creator",
    platform_data: {
      employee_id: "EMP102",
      hire_date: "2023-06-15",
      salary: "$75,000",
      skills: ["Content Creation", "Video Editing", "Copywriting", "SEO"],
      manager: "Jane Smith",
      location: "New York, NY"
    },
    unified_profile: {
      email: "david.brown@abc.com",
      name: "David Brown",
      phone: "+1-555-0202",
      employment_status: "ACTIVE",
      department: "Marketing",
      job_title: "Content Creator",
      hr_systems: ["hr2"],
      support_tickets: [],
      youtube_channel: "DavidCreates"
    },
    is_demo_user: true
  },
  
  # HR3 Users
  {
    email: "emma.wilson@abc.com",
    name: "Emma Wilson",
    phone: "+1-555-0301",
    platform_source: "hr3",
    employment_status: "ACTIVE",
    department: "Sales",
    job_title: "Sales Director",
    platform_data: {
      employee_id: "EMP201",
      hire_date: "2022-08-05",
      salary: "$130,000",
      skills: ["Sales Management", "CRM", "Negotiation", "Team Leadership"],
      manager: "CEO",
      location: "Chicago, IL"
    },
    unified_profile: {
      email: "emma.wilson@abc.com",
      name: "Emma Wilson",
      phone: "+1-555-0301",
      employment_status: "ACTIVE",
      department: "Sales",
      job_title: "Sales Director",
      hr_systems: ["hr3"],
      support_tickets: [],
      youtube_channel: "SalesWithEmma"
    },
    is_demo_user: true
  },
  
  # Zendesk Users
  {
    email: "bob.wilson@abc.com",
    name: "Bob Wilson",
    phone: "+1-555-0401",
    platform_source: "zendesk",
    platform_data: {
      customer_id: "CUST001",
      organization: "ABC Corp",
      tags: ["enterprise", "premium"],
      last_contact: "2024-01-15",
      total_tickets: 5
    },
    unified_profile: {
      email: "bob.wilson@abc.com",
      name: "Bob Wilson",
      phone: "+1-555-0401",
      employment_status: nil,
      department: nil,
      job_title: nil,
      hr_systems: [],
      support_tickets: 5,
      youtube_channel: "BobTechSupport"
    },
    is_demo_user: true
  },
  {
    email: "sarah.johnson@abc.com",
    name: "Sarah Johnson",
    phone: "+1-555-0402",
    platform_source: "zendesk",
    platform_data: {
      customer_id: "CUST002",
      organization: "XYZ Inc",
      tags: ["sme", "standard"],
      last_contact: "2024-01-10",
      total_tickets: 3
    },
    unified_profile: {
      email: "sarah.johnson@abc.com",
      name: "Sarah Johnson",
      phone: "+1-555-0402",
      employment_status: nil,
      department: nil,
      job_title: nil,
      hr_systems: [],
      support_tickets: 3,
      youtube_channel: "SarahTech"
    },
    is_demo_user: true
  }
]

demo_users.each do |user_data|
  PlatformUser.find_or_create_by!(email: user_data[:email], platform_source: user_data[:platform_source]) do |user|
    user.assign_attributes(user_data)
  end
end

puts "✅ Created #{PlatformUser.count} platform users"

# Note: Support tickets table removed - focusing on user data collection only
puts "✅ Skipping support tickets creation (table removed)"

# Create demo data sync logs
puts "📊 Creating demo data sync logs..."

# Get the first integration for demo sync logs
integration = Integration.first

if integration
  demo_sync_logs = [
    {
      integration: integration,
      sync_type: "users",
      status: "success",
      records_processed: 8,
      records_created: 8,
      records_updated: 0,
      records_failed: 0,
      sync_metadata: {
        source: "demo_data",
        duration_minutes: 2,
        api_calls: 5
      },
      started_at: 1.hour.ago,
      completed_at: 1.hour.ago,
      duration_seconds: 120
    },
    {
      integration: integration,
      sync_type: "tickets",
      status: "success",
      records_processed: 2,
      records_created: 2,
      records_updated: 0,
      records_failed: 0,
      sync_metadata: {
        source: "demo_data",
        duration_minutes: 1,
        api_calls: 3
      },
      started_at: 2.hours.ago,
      completed_at: 2.hours.ago,
      duration_seconds: 60
    }
  ]

  demo_sync_logs.each do |log_data|
    DataSyncLog.create!(log_data)
  end

  puts "✅ Created #{DataSyncLog.count} sync logs"
end

puts "🎉 Database seeding completed successfully!"
puts ""
puts "📊 Summary:"
puts "   🔗 Integrations: #{Integration.count}"
puts "   👥 Platform Users: #{PlatformUser.count}"
puts "   📊 Sync Logs: #{DataSyncLog.count}"
puts ""
puts "🚀 Your demo database is ready for customer presentations!"
puts "   Visit: http://localhost:3000/multi-platform"
puts "   Visit: http://localhost:3000/integrations"
