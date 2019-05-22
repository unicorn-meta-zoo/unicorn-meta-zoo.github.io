require 'minitest/autorun'
require 'digest/md5'

class TestDocsDump < Minitest::Test
  def setup
    if !Dir.exist?('feedvalidator-master')      
      #system("git clone https://github.com/jericson/feedvalidator.git")
      if !File.exist?('master.zip')
        system("wget https://github.com/jericson/feedvalidator/archive/master.zip")
        assert_equal $?, 0
      end
      system("unzip master.zip")
      assert_equal $?, 0
    end
  end

  def test_valid_feed
    system("python feedvalidator-master/src/demo.py https://unicorn-meta-zoo.github.io/index.rss")
    assert_equal $?, 0
  end
end

