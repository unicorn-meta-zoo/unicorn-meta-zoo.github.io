require 'minitest/autorun'
require 'digest/md5'

class TestDocsDump < Minitest::Test
  def setup
    #system("ls -l *")
    if !File.exist?('feedvalidator/src/demo.py')      
      system("git clone https://github.com/jericson/feedvalidator.git")
      assert_equal $?, 0
    end
  end

  def test_valid_feed
    system("LANGUAGE=en python feedvalidator/src/demo.py https://unicorn-meta-zoo.github.io/index.rss")
    assert_equal $?, 0
  end
end

