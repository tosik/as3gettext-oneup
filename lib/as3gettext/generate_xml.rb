require 'gettext'
require 'gettext/poparser'
require 'gettext/mo'
require 'builder'
require 'pathname'

$KCODE = 'u'
$DEBUG = false

module As3gettext
  class GenerateXml
    include GetText
    include Builder

    def initialize
      @parser = PoParser.new
      @xml_declaration = false
    end
    attr_accessor :xml_declaration

    def generate(files)
      files.map! {|f| Pathname.new(f) }
      res = ''
      xml = XmlMarkup.new(:indent => 2, :target => res)
      xml.instruct! :xml, :version=>"1.0", :encoding=> "UTF-8" if xml_declaration
      xml.langs do
        files.each do |file|
          langname = file.basename('.po').to_s
          unless langname.empty?
            data = MOFile.new
            @parser.parse(file.read, data)
            xml.lang(:lang => langname) {
              data.each do |msgid, msgstr|
                next if msgid.length == 0
                xml.message {
                  xml.msgid(msgid)
                  xml.msgstr(msgstr)
                }
              end
            }
          end
        end
      end

      res.gsub(/&#([\d+]+);/){[$1.to_i].pack("U")}
    end
  end
end
