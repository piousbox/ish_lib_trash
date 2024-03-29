
class Site

  include Mongoid::Document
  include Mongoid::Timestamps
  include AuxModel

  field :domain, :type => String
  field :lang, :type => String, :default => 'en'
  field :title, :type => String
  field :subhead, :type => String

  field :home_redirect_path, :type => String, :default => nil

  field :n_features, :type => Integer, :default => 4
  field :n_newsitems, :type => Integer, :default => 20

  # denormalized
  field :n_reports, :type => Integer
  field :n_galleries, :type => Integer

  field :is_video_enabled, :type => Boolean, :default => false
  field :is_resume_enabled, :type => Boolean, :default => false
  field :is_ads_enabled, :type => Boolean, :default => true
  field :is_trash, :type => Boolean, :default => false

  has_many :reports
  has_many :galleries
  has_many :tags
  has_many :videos

  embeds_many :features
  embeds_many :newsitems
  
  # in testing this I think fails everything?
  #
  # default_scope where( :is_trash => false ).order_by( :name => :asc, :lang => :asc )

  set_callback :create, :before do |doc|
    if Site.where( :lang => doc.lang, :domain => doc.domain ).length > 0
      return false
    end
  end

  set_callback :update, :before do |doc|
    possible_duplicate = Site.where( :lang => doc.lang, :domain => doc.domain ).first
    if possible_duplicate.blank?
      return true
    elsif doc.id != possible_duplicate.id
      return false
    end
  end

  LANGUAGES = [ 'en', 'ru', 'pt' ]
  
  # manager uses it.
  def self.list
    out = self.all.order_by( :domain => :asc, :lang => :asc )
    [['', nil]] + out.map { |item| [ "#{item.domain} #{item.lang}", item.id ] }
  end

  def self.mobi
    Site.where( :domain => 'travel-guide.mobi', :lang => 'en' ).first
  end

end
