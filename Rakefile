require 'erb'
require 'date'

task :default do
  existing = Dir.glob('[0-9][0-9].rb').sort.last&.gsub('.rb', '')&.to_i || 0
  template = ERB.new(File.read('./template.rb.erb'))
  today = Date.today
  output = "#{'%02d' % (existing + 1)}.rb"

  File.open(output, 'w') do |f|
    f << template.result
  end

  File.chmod(0755, output)
end
