require 'bundler'
Bundler.require
require 'net/http'
require 'fileutils'
require 'uri'
require 'zip'

module Corenlp
  class Downloader
    attr_accessor :url, :destination, :local_file
    def initialize(url, destination)
      self.url = url
      self.destination = destination
      self.local_file = nil
    end

    def extract
      puts "extracting file..."
      Zip::File.open(local_file) do |zip_file|
        zip_file.each do |file|
          file_path = File.join(destination, file.name)
          zip_file.extract(file, file_path) unless File.exist?(file_path)
        end

        puts "moving files into directory..."
        dirname = local_file[0...-4]
        dir = File.join(destination, dirname)
        if File.exists?(dir)
          Dir.glob(File.join(dir, "*")).each do |file|
            FileUtils.mv(file, File.join(destination, File.basename(file)))
          end
          FileUtils.rm_rf(dir)
        end

        puts "deleting original zip file..."
        FileUtils.rm(local_file)
        puts "done."
      end
    end

    def download
      return unless url
      puts "downloading zip file from url #{url}. Extracting files to #{destination}..."
      self.local_file = File.basename(url)
      uri = URI.parse(url)
      if local_file && uri
        Net::HTTP.start(uri.host) do |http|
          resp = http.get(uri.request_uri)
          open(local_file, "wb") do |file|
            file.write(resp.body)
          end
        end
        puts "done. Downloaded file #{local_file}."
        extract
      end
    end
  end
end
