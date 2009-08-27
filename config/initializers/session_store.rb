# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SuperHappyScreen_session',
  :secret      => '2b21a6902bc1642e4b7f04fcbc77666fb812e3dd474f0f493a9fad09d488aa70017c659701b6730dd434cbd733fa80b29987544387b9a0fb9b8a2866ff9c3772'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
