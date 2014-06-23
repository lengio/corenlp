require "nokogiri"
require "bundler"
Bundler.require

module Corenlp
  class Treebank
    attr_accessor :raw_text, :filenames, :output_directory, :summary_file, :threads_to_use, :java_max_memory, :sentences

    def initialize(attrs = {})
      self.raw_text = attrs[:raw_text] || ""
      self.filenames = []
      self.output_directory = attrs[:output_directory] || "./tmp/language_processing"
      self.summary_file = "#{output_directory}/summary_file_#{object_id}_#{Time.now.to_i}.txt"
      self.filenames = []
      self.threads_to_use = attrs[:threads_to_use] || 4
      self.java_max_memory = attrs[:java_max_memory] || "-Xmx3g"
      self.sentences = []
    end

    def write_output_file_and_summary_file
      input_file = File.join(output_directory, "text_#{object_id}_#{Time.now.to_i}.txt")
      filenames << input_file
      File.open(input_file, "w"){|f| f.write(raw_text)}
      File.open(summary_file, "w"){|f| f.write(filenames.join("\n"))}
    end

    def process_files_with_stanford_corenlp
      deps = "./lib/ext" # dependencies directory: JARs, model files, taggers, etc.
      classpath = "#{deps}/stanford-corenlp-3.4.jar:#{deps}/stanford-corenlp-3.4-models.jar:#{deps}/xom.jar:#{deps}/joda-time.jar:#{deps}/jollyday.jar:#{deps}/ejml-0.23.jar"
      stanford_bin = "edu.stanford.nlp.pipeline.StanfordCoreNLP"
      annotators = "tokenize,ssplit,pos,lemma,parse,ner"

      options = []
      options << ["-cp", classpath]
      options << [java_max_memory, stanford_bin]
      options << ["-annotators", annotators]
      options << ["-ner.useSUTime", 0] # turn this off
      #options << ["-sutime.binders", 0]
      options << ["-outputDirectory", output_directory]
      options << ["-nthreads", threads_to_use]
      options << ["-filelist", summary_file] # a file with one zone file per line

      command = "java #{options.map{|x| x.join(" ")}.join(" ")}"
      puts "Running command: \n\n#{command}\n\n"
      `#{command}`
    end

    def build_treebank
      filenames.each do |filename|
        xml_file = "#{filename}.xml"
        doc = Nokogiri.XML(File.open(xml_file))
        doc.xpath("//sentences/sentence").each_with_index do |sentence_node, idx|
          sentence = Sentence.new(index: idx)
          self.sentences << sentence
          sentence_node.xpath(".//token").each_with_index do |token_node, index|
            text = token_node.children.at('word').text
            text = Token.clean_stanford_text(text)
            cleaned_stanford_lemma = Token.clean_stanford_text(token_node.children.at('lemma').text)
            token_attrs = {
              index: index,
              text: text,
              penn_treebank_tag: token_node.children.at('POS').text,
              stanford_lemma: cleaned_stanford_lemma,
              type: Token.token_subclass_from_text(text),
              ner: token_node.children.at('NER').text
            }
            token = Token.token_subclass_from_text(text).new(token_attrs)
            sentence.tokens << token
          end
          sentence_node.xpath(".//dependencies[@type='collapsed-dependencies']/dep").each do |dep_node|
            dependent_index = dep_node.children.at('dependent').attr('idx').to_i - 1
            governor_index = dep_node.children.at('governor').attr('idx').to_i - 1
            if dependent_index >= 0 && governor_index >= 0
              dependent = sentence.get_dependency_token_by_index(dependent_index),
              governor  = sentence.get_dependency_token_by_index(governor_index),
              relation = dep_node.attr('type')
              if dependent && governor && relation
                token_dep = TokenDependency.new({
                  dependent: sentence.get_dependency_token_by_index(dependent_index),
                  governor: sentence.get_dependency_token_by_index(governor_index),
                  relation: dep_node.attr('type')
                })
                sentence.token_dependencies << token_dep
              end
            end
          end
          sentence_node.xpath(".//parse").each do |parse_node|
            sentence.parse_tree_raw = parse_node.text
          end
        end
      end
    end

    def parse
      write_output_file_and_summary_file
      process_files_with_stanford_corenlp
      build_treebank
      self
    end
  end
end

require "corenlp/version"
require "corenlp/sentence"
require "corenlp/token"
require "corenlp/token_dependency"
require "corenlp/enclitic"
require "corenlp/word"
require "corenlp/punctuation"
require "corenlp/number"
require "corenlp/downloader"
