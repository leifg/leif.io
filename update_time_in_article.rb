require 'bundler/inline'

gemfile do
  source "https://rubygems.org"

  gem "front_matter_parser"
  gem "activesupport"
end

require "time"
require "fileutils"
require "active_support/all"
require "front_matter_parser"

module TypeMapper
  extend self

  def to_line(key, value)
    return ["#{key}: #{value.inspect}"] if key == "title"

    serialized_value = case value
    when Array
      "[#{value.join(",")}]"
    else
      value
    end

    "#{key}: #{serialized_value}"
  end
end

module FileLocationUtils
  extend self

  INITIAL_ACC = {
    prefixes: [].freeze,
    year: nil,
    month: nil,
    day: nil,
    slug: nil,
    file_name: nil,
    last_parsed: :prefixes
  }.freeze

  def parse_location(dir)
    dir.split("/").reduce(INITIAL_ACC) do |acc, elem|
      if acc[:last_parsed] == :prefixes && elem =~ /^\d{4}$/
        acc.merge(last_parsed: :year, year: elem)
      elsif acc[:last_parsed] == :year
        acc.merge(last_parsed: :month, month: elem)
      elsif acc[:last_parsed] == :month
        acc.merge(last_parsed: :day, day: elem)
      elsif acc[:last_parsed] == :day
        acc.merge(last_parsed: :slug, slug: elem)
      elsif acc[:last_parsed] == :slug
        acc.merge(last_parsed: :file_name, file_name: elem)
      else
        acc.merge(prefixes: acc[:prefixes] + [elem])
      end
    end.except(:last_parsed)
  end

  def to_path(location)
    location[:prefixes].join("/") +
    "/" + location[:year] +
    "/" + location[:month] +
    "/" + location[:day] +
    "/" + location[:slug] +
    "/" + location[:file_name]
  end
end

class ContentRewriter
  def initialize(parsed_markdown, timezone)
    @parsed_markdown = parsed_markdown
    @timezone = timezone
  end

  def replace_front_matter(key, value)
    @parsed_markdown.front_matter[key] = value
  end

  def write_to_file(filename)
    file_content = <<~CONTENT
    ---
    #{@parsed_markdown.front_matter.map{|key, value| TypeMapper.to_line(key, value)}.join("\n")}
    ---

    #{@parsed_markdown.content}
    CONTENT

    File.write(filename, file_content)
  end

  def self.parse_file(filename, timezone)
    unsafe_loader = ->(string) { YAML.load(string, permitted_classes: [Time]) }

    new(FrontMatterParser::Parser.parse_file(filename, loader: unsafe_loader), timezone)
  end
end

filename = ARGV[0]
timezone = ARGV[1] || "America/Los_Angeles"

raise "Invalid Timezone '#{timezone}'" unless TZInfo::Timezone.all_identifiers.include?(timezone)
raise "File #{filename} does not exist" unless File.exist?(filename)

rewriter = ContentRewriter.parse_file(filename, timezone)
current_time = Time.now.utc.in_time_zone(timezone)

puts "Setting date in '#{filename}' to '#{current_time.iso8601}'"
rewriter.replace_front_matter("date", current_time.iso8601)

puts "Writing File"
rewriter.write_to_file(filename)

current_location = FileLocationUtils.parse_location(filename)

new_location = current_location.merge(
  year: current_time.year.to_s,
  month: current_time.month.to_s.rjust(2, "0"),
  day: current_time.day.to_s.rjust(2, "0"),
)

new_filename = FileLocationUtils.to_path(new_location)

if new_filename != filename
  puts "date changed, moving directory"
  old_path = File.dirname(filename)
  new_path = File.dirname(new_filename)

  puts "Creating: #{File.dirname(new_path)}"
  FileUtils.mkdir_p(File.dirname(new_path))
  FileUtils.mv(old_path, new_path)
end
