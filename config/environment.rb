
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
Rails::Initializer.run do |config|

  config.time_zone = 'Eastern Time (US & Canada)'
  config.action_controller.session = {
    :session_key => '_schedule_session',
    :secret      => 'c0be1ba87a37440e328797d0ab72f0e7b6597c38dcaf1a30d5bd2aa7c397744cab107fc7a3cd5d5030a0c736e043f7a66387730914291975a69922a62a48691d'
  }
  #config.gem "calendar_date_select"
end
