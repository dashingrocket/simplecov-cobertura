require 'simplecov'

require 'rexml/document'
require 'rexml/element'
require 'pathname'

require_relative 'simplecov-cobertura/version'

module SimpleCov
  module Formatter
    class CoberturaFormatter
      RESULT_FILE_NAME = 'coverage.xml'
      DTD_URL = 'http://cobertura.sourceforge.net/xml/coverage-04.dtd'

      def initialize(result_file_name: RESULT_FILE_NAME)
        @result_file_name = result_file_name
      end

      def format(result)
        xml_doc = result_to_xml result
        result_path = File.join(SimpleCov.coverage_path, @result_file_name)

        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        string_io = StringIO.new
        formatter.write(xml_doc, string_io)

        xml_str = string_io.string
        File.write(result_path, xml_str)
        puts "Coverage report generated for #{result.command_name} to #{result_path}. #{coverage_output(result)}"
        xml_str
      end

      private

        def result_to_xml(result)
          doc = REXML::Document.new set_xml_head
          doc.context[:attribute_quote] = :quote
          doc.add_element REXML::Element.new('coverage')
          coverage = doc.root

          set_coverage_attributes(coverage, result)

          coverage.add_element(sources = REXML::Element.new('sources'))
          sources.add_element(source = REXML::Element.new('source'))
          source.text = SimpleCov.root

          coverage.add_element(packages = REXML::Element.new('packages'))

          if result.groups.empty?
            groups = {File.basename(SimpleCov.root) => result.files}
          else
            groups = result.groups
          end

          groups.each do |name, files|
            next if files.empty?
            packages.add_element(package = REXML::Element.new('package'))
            set_package_attributes(package, name, files)

            package.add_element(classes = REXML::Element.new('classes'))

            files.each do |file|
              classes.add_element(class_ = REXML::Element.new('class'))
              set_class_attributes(class_, file)

              class_.add_element(REXML::Element.new('methods'))
              class_.add_element(lines = REXML::Element.new('lines'))

              branched_lines = file.branches.map(&:start_line)
              branched_lines_covered = file.covered_branches.map(&:start_line)

              file.lines.each do |file_line|
                if file_line.covered? || file_line.missed?
                  lines.add_element(line = REXML::Element.new('line'))
                  set_line_attributes(line, file_line)
                  set_branch_attributes(line, file_line, branched_lines, branched_lines_covered) if SimpleCov.branch_coverage?
                end
              end
            end
          end

          doc
        end

        def set_coverage_attributes(coverage, result)
          ls = result.coverage_statistics[:line]
          bs = result.coverage_statistics[:branch]

          coverage.attributes['line-rate'] = extract_rate(ls.percent)
          coverage.attributes['lines-covered'] = ls.covered.to_s.to_s
          coverage.attributes['lines-valid'] = ls.total.to_s.to_s
          if SimpleCov.branch_coverage?
            coverage.attributes['branches-covered'] = bs.covered.to_s
            coverage.attributes['branches-valid'] = bs.total.to_s
            coverage.attributes['branch-rate'] = extract_rate(bs.percent)
          end
          coverage.attributes['complexity'] = '0'
          coverage.attributes['version'] = '0'
          coverage.attributes['timestamp'] = Time.now.to_i.to_s
        end

        def set_package_attributes(package, name, result)
          ls = result.coverage_statistics[:line]
          bs = result.coverage_statistics[:branch]

          package.attributes['name'] = name
          package.attributes['line-rate'] = extract_rate(ls.percent)
          if SimpleCov.branch_coverage?
            package.attributes['branch-rate'] = extract_rate(bs.percent)
          end
          package.attributes['complexity'] = '0'
        end

        def set_class_attributes(class_, file)
          ls = file.coverage_statistics[:line]
          bs = file.coverage_statistics[:branch]

          filename = file.filename
          class_.attributes['name'] = File.basename(filename, '.*')
          class_.attributes['filename'] = resolve_filename(filename)
          class_.attributes['line-rate'] = extract_rate(ls.percent)
          if SimpleCov.branch_coverage?
            class_.attributes['branch-rate'] = extract_rate(bs.percent)
          end
          class_.attributes['complexity'] = '0'
        end

        def set_line_attributes(line, file_line)
          line.attributes['number'] = file_line.line_number.to_s
          line.attributes['hits'] = file_line.coverage.to_s
        end

        def set_branch_attributes(line, file_line, branched_lines, branched_lines_covered)
          if branched_lines.include? file_line.number
            pct_coverage, branches_covered = branched_lines_covered.include?(file_line.number) ? [100, '1/1'] : [0, '0/1']
            line.attributes['branch'] = 'true'
            line.attributes['condition-coverage'] = "#{pct_coverage}% (#{branches_covered})"
          else
            line.attributes['branch'] = 'false'
          end
        end

        def set_xml_head(lines=[])
          lines << "<?xml version=\"1.0\"?>"
          lines << "<!DOCTYPE coverage SYSTEM \"#{DTD_URL}\">"
          lines << "<!-- Generated by simplecov-cobertura version #{VERSION} (https://github.com/dashingrocket/simplecov-cobertura) -->"
          lines.join("\n")
        end

        def coverage_output(result)
          ls = result.coverage_statistics[:line]
          bs = result.coverage_statistics[:branch]

          if SimpleCov.branch_coverage?
            "%d / %d LOC (%.2f%%) covered; %d / %d BC (%.2f%%) covered" % [ls.covered, ls.total, ls.percent, bs.covered, bs.total, bs.percent]
          else
            "%d / %d LOC (%.2f%%) covered" % [ls.covered, ls.total, ls.percent]
          end
        end

        def resolve_filename(filename)
          Pathname.new(filename).relative_path_from(project_root).to_s
        end

        def extract_rate(percent)
          (percent / 100).round(2).to_s
        end

        def project_root
          @project_root ||= Pathname.new(SimpleCov.root)
        end
    end
  end
end
