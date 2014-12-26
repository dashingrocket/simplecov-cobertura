require 'test/unit'
require 'simplecov-cobertura'

require 'open-uri'
require 'libxml'
include LibXML

class CoberturaFormatterTest < Test::Unit::TestCase

  def setup
    @result = SimpleCov.result
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

    dtd_text = open(SimpleCov::Formatter::CoberturaFormatter::DTD_URL) { |io| io.read }
    dtd = XML::Dtd.new(dtd_text)
    doc = XML::Document.string(xml)
    assert_true doc.validate(dtd)
  end
end