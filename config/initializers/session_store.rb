# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_six_degrees_session',
  :secret      => '36fd280ff5ac21310f6176e43a3f63e51397bdc89d2d0da45f7993952bdbe4586b03583485efb92c8e3350dbe5783f32dcf3a639b5448b545afdf27ddb7ee297'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
