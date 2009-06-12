require File.join(File.dirname(__FILE__), "test_helper")

class TestFakeWebHeaders < Test::Unit::TestCase

  def setup
    FakeWeb.allow_net_connect = true
    FakeWeb.clean_registry
  end

  def test_for_symbol_header
    FakeWeb.register_uri(:get, 'http://mock/test_string.txt', :string => 'foo', :content_type => "text/html", :x_david => "Dude")
    
    Net::HTTP.start("mock") do |req|
      response = req.get("/test_string.txt")
      assert_equal 'text/html', response.get_fields('Content-Type').first
      assert_equal 'Dude', response.get_fields('X-David').first
    end  
  end

  def test_for_string_header
    FakeWeb.register_uri(:get, 'http://mock/test_string.txt', :string => 'foo', 'Content-Type' => "text/html", 'X-David' => "Awesome")
    
    Net::HTTP.start("mock") do |req|
      response = req.get("/test_string.txt")
      assert_equal 'text/html', response.get_fields('Content-Type').first
      assert_equal 'Awesome', response.get_fields('X-David').first
    end
  end

end