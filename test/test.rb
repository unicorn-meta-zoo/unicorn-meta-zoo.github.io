require 'minitest/autorun'
require 'digest/md5'

class TestDocsDump < Minitest::Test
  def setup
    if !Dir.exist?('feedvalidator')      
      system("git clone https://github.com/jericson/feedvalidator.git")
      assert_equal $?, 0
    end
  end

  def test_valid_feed
    system("python feedvalidator/src/demo.py https://unicorn-meta-zoo.github.io/index.rss")
    assert_equal $?, 0
  end
end

