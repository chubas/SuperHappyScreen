require 'pbruby/client'
require 'twitter'

module SuperHappyScreen

  SHDH_SETTINGS = HashWithIndifferentAccess.new(
          YAML::load_file(File.join(RAILS_ROOT, 'config', 'devhouse.yml')))

  WIKI = PBWiki::Client.new(SHDH_SETTINGS[:wiki][:name],
            :read   => SHDH_SETTINGS[:wiki][:read_key],
            :write  => SHDH_SETTINGS[:wiki][:write_key],
            :admin  => SHDH_SETTINGS[:wiki][:admin_key])
 
  folder_name = SHDH_SETTINGS[:folder_name]
  unless WIKI.folders.folders.include?(folder_name)
    WIKI.create_folder :folder => folder_name
    RAILS_DEFAULT_LOGGER.info("Folder #{folder_name} created")
  end

  TWITTER = Twitter::Base.new(Twitter::HTTPAuth.new(
          SHDH_SETTINGS[:twitter][:account],
          SHDH_SETTINGS[:twitter][:password]))

end