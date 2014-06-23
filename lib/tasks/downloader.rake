desc "download Stanford CoreNLP dependencies files"
namespace :corenlp do
  task :download_deps do
    zip_file_url = ENV['CORENLP_DOWNLOAD_URL'] || "http://nlp.stanford.edu/software/stanford-corenlp-full-2014-06-16.zip"
    destination = File.join(ENV['CORENLP_DEPS_DIR'] || './lib/ext/')
    Downloader.new(zip_file_url, destination).download
  end
end
