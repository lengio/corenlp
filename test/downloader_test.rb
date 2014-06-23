require "test_helper"

class DownloaderTest < Minitest::Test
  def test_initialized_ok
    zip_file_url = "http://nlp.stanford.edu/software/stanford-corenlp-full-2014-06-16.zip"
    destination = File.join('./lib/ext/')
    assert Downloader.new(zip_file_url, destination)
  end
end
