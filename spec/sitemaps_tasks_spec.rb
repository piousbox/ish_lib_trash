require 'spec_helper'
describe Utils::SitemapsController do

  before :each do
    setup_cities

    Report.all.each { |c| c.remove }

    Tag.all.each { |c| c.remove }

    User.all.each { |u| u.remove }
    @user = User.all[0]

    Gallery.all.each { |g| g.remove }
    @g = FactoryGirl.create :gallery
    @g1 = FactoryGirl.create :g1
    @g2 = FactoryGirl.create :g2

    Venue.all.each { |v| v.remove }
    @venue1 = FactoryGirl.create :venue
    @venue2 = FactoryGirl.create :cac

  end

  describe 'travel sitemap' do
    it 'has cities' do
      init_sitemap
      n_cities = City.all.length
      n_cities.should be >= 1
      assigns(:cities).should_not eql nil
      assigns(:cities).length.should eql n_cities
    end

    it 'all links to reports should have domain travel-guide.mobi in the link address' do
      init_sitemap
      result = Hash.from_xml(@response.body)

      result['urlset']['url'].each do |url|
        url['loc'].include?('travel-guide.mobi').should eql true
        url['loc'].include?('/en/').should eql true
      end
      result['urlset']['url'].length.should be >= 2
      
      cities = assigns(:cities)
      cities.length.should eql City.all.length
      City.all.length.should_not eql 0
    end

    it 'has the entry for cities index' do
      false.should eql true
      locs.include?('http://travel-guide.mobi/en/cities').should eql true
    end

    it 'only has galleries of travel-guide.mobi' do
    end

    it 'has venues' do
    end

  end

  private

  def init_sitemap
      @request.host = 'travel-guide.mobi'
      get :sitemap, :domainname => 'travel-guide.mobi', :locale => :en, :format => :xml
      response.should be_success
  end

end
