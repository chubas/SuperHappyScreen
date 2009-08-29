require 'mechanize'

class PagesController < ApplicationController

  include SuperHappyScreen
  include ActionView::Helpers::TextHelper

  def main
    get_pages 
  end

  def register
    if request.post?
      twitter   = (params[:twitter_same_as_nickname]  == '1' and params[:nickname])  || params[:twitter]
      twitter.gsub! /^@/, ''
      facebook  = (params[:facebook_same_as_name]     == '1' and params[:name])      ||
                  (params[:facebook_same_as_nickname] == '1' and params[:nickname])  ||
                   params[:facebook]
      facebook = facebook.gsub(/[^A-Za-z]/, '').downcase if facebook
      valid_params = [:name, :nickname, :project_name, :project_description].inject({}) do |hash, param|
        hash[param] = params[param]
        hash
      end
      if Assistant.find_by_name(params[:name])
        render :update do |page|
          page << "$.jGrowl('Parece que ya te habías registrado!', {theme:'error'});"
          page << "$.fn.fancybox.close();"
        end
        return
      end
      @assistant = Assistant.new(valid_params.merge(
                :devhouse => SHDH_SETTINGS[:number],
                :twitter => twitter,
                :facebook => facebook
              ))
      if @assistant.save
        twitter_follow(@assistant)
        twitter_update_status(@assistant)
        wiki_make_project_page(@assistant)
        render :update do |page|
          page << "$.jGrowl('Bienvenido!')"
          page << "$.fn.fancybox.close();"
        end
      else
        render :update do |page|
          page << "$.jGrowl('Oooops. Algo salió mal. No te preocupes, creo que aún no has roto el internet...', {theme:'error'});"
        end
      end
    else
      redirect_to :action => main
    end
  end

  def wiki
    page_name = URI.encode(params[:page])
    agent     = WWW::Mechanize.new
    page_url  = "http://#{SHDH_SETTINGS[:wiki][:name]}.pbworks.com/#{page_name}"
    agent.get(page_url)
    content   = agent.page.search('#wikipage')
    render :update do |page|
      page.replace_html '#wiki_content', content
    end
  end

  def projects
    get_pages
    render :partial => 'pbwiki_widget', :locals => { :pages => @pages }  
  end

  protected

  def get_pages
    # @pages = %w( Foo Bar Baz )
    pages_or_files = WIKI.folder_objects :folder => SHDH_SETTINGS[:folder_name]
    @pages = pages_or_files.objects.reject do |page|
      (WIKI.page :page => page).error_string
    end
  end

  def twitter_follow(who)
    TWITTER.friendship_create(who.twitter)  
  rescue => e
    RAILS_DEFAULT_LOGGER.warn("Could not follow user #{who.twitter}")
    RAILS_DEFAULT_LOGGER.error(e)
  end

  def twitter_update_status(who)
    hashtag = SHDH_SETTINGS[:hashtag]
    name = who.twitter ? "@#{who.twitter}" : who.name
    tweet = "#{name} ha llegado! "
    tweet += "para trabajar en #{who.project_name}" if who.project_name
    tweet = truncate(tweet, 140 - (hashtag.size + 1))
    tweet += " #{hashtag}"
    TWITTER.update(tweet)
  rescue => e
    RAILS_DEFAULT_LOGGER.warn("Could not update status for arrival of #{who.name}")
    RAILS_DEFAULT_LOGGER.error(e)
  end

  def wiki_make_project_page(who)
    if who.project_name
      twitter_image = <<-TWITTER
        <a href="http://twitter.com/#{who.twitter}">
          <img src="http://farm4.static.flickr.com/3129/2636923069_1d4f797479.jpg?v=0" />
        </a>&nbsp;
      TWITTER
      facebook_image = <<-FB
        <a href="http://facebook.com/#{who.facebook}">
          <img src="http://lh4.ggpht.com/_hQQrHaPJQt0/SSBVWhDhdiI/AAAAAAAACiE/Ph6JkWctLDY/facebook.png" />
        </a>
      FB
      description = <<-HTML
        <span style="font-size: 200%;"><strong>#{who.project_name}</strong></span>
        <p>&nbsp;</p>
        <p><strong><span style="font-size: 130%;">
          SuperHappyDevHouse #{SHDH_SETTINGS[:number]}, by #{who.nickname || who.name} &nbsp;&nbsp;
          #{twitter_image if who.twitter} #{facebook_image if who.facebook}<br />
        </span></strong></p>
        <p>&nbsp;</p>
        <p> #{who.project_description || 'Add your description here'} </p>
      HTML
      new_page = WIKI.append_page :page => who.project_name, :html => description, :create_if_missing => true
      if new_page and new_page.success
        WIKI.set_page_folder :page => who.project_name, :folder => SHDH_SETTINGS[:folder_name]
        RAILS_DEFAULT_LOGGER.info("Succesfully created page #{who.project_name}")
        RAILS_DEFAULT_LOGGER.info(description)
      else
        RAILS_DEFAULT_LOGGER.warn("Could not create page for #{who.project_name}")
        RAILS_DEFAULT_LOGGER.info("Response was: #{new_page.inspect}")
      end
    end
  rescue => e
    RAILS_DEFAULT_LOGGER.warn("Could not create page for #{who.project_name}")
    RAILS_DEFAULT_LOGGER.error(e)
  end

end
