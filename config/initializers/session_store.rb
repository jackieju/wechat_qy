# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wechat_qyh_session',
  :secret      => '1eac21f13cdb4740e8ae8147543078531f4a71814ffd2a0ee8e64215e969c01821b50c615929fd5f2bea0ad139327cf067fb5501ca110e021e07539eb68f2f6c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
