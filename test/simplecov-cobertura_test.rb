require 'test/unit'
#require 'libxml'

require 'nokogiri'

require 'open-uri'
require 'simplecov-cobertura'

class CoberturaFormatterTest < Test::Unit::TestCase

  def setup
    @result = SimpleCov::Result.new("#{__FILE__}" => [1,2])
    @formatter = SimpleCov::Formatter::CoberturaFormatter.new
  end

  def teardown
    # Do nothing
  end

  def test_format_save_file
    xml = @formatter.format(@result)
    result_path = File.join(SimpleCov.coverage_path, SimpleCov::Formatter::CoberturaFormatter::RESULT_FILE_NAME)
    assert_not_empty(xml)
    assert_equal(xml, IO.read(result_path))
  end

  def test_format_dtd_validates
    xml = @formatter.format(@result)
    options = Nokogiri::XML::ParseOptions::DTDLOAD
    doc = Nokogiri::XML::Document.parse(xml, nil, nil, options)
    assert_empty doc.external_subset.validate(doc)
  end
end