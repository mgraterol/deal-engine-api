# config/initializers/content_security_policy.rb

Rails.application.config.content_security_policy do |policy|
  # ... other directives
  policy.connect_src :self, "https://#{ENV['RAILS_HOST'] || 'localhost:3000'}", 'wss://localhost:3000'
  # ... other directives
end
