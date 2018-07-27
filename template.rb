=begin
Template Name: Application Wizard
Author: John Espinosa
Instructions: $ rails new myapp -m template.rb
=end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'frontend-generators'
  gem 'jquery-rails'
  gem_group :development, :test do
    gem 'better_errors'
  end
end

def set_application_name
  # Ask user for application name
  application_name = ask("What is the name of your application?")

  # Checks if application name is empty and add default Jumpstart.
  application_name = application_name.present? ? application_name : "Newerest App"

  # Add Application Name to Config
  environment "config.application_name = '#{application_name}'"

  # Announce the user where he can change the application name in the future.
  puts "Your application name is #{application_name}. You can change this later on: ./config/application.rb"
end

# Main setup
add_gems

after_bundle do
  set_application_name
  route "get 'creatives/index'"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }
end

inject_into_file 'Rakefile', :after => "Rails.application.load_tasks\n" do
  "\nrequire 'frontend_generators'\nload 'tasks/add_assets.rake'\n\n"
end

rake "add_assets:bootstrap"
rake "add_assets:font_awesome"
rake "add_assets:creative"

inject_into_file 'config/initializers/assets.rb', :after => "# Rails.application.config.assets.precompile += %w( admin.js admin.css )\n" do
  "\nRails.application.config.assets.precompile += %w( creative/manifest.js creative/manifest.css )\n\n"
end



