require 'gettext'
require 'gettext/rgettext'

module As3gettext
  module As3Parser
    module_function
    def parse(file, targets = [])  # :nodoc:
      lines = IO.readlines(file)
      parse_lines(file, lines, targets)
    end

    def parse_lines(file_name, lines, targets)  # :nodoc:
      begin
        lines.each_with_index do |line, i|
          if m = (line.match(/_\('([^']+)'\)/) || line.match(/_\("([^"]+)"\)/) )
            name = m[1].gsub(/\n/, '\n')
            if t = targets.detect{|a| a[0] == name}
              t[1] << ', ' + file_name + ":" + (i+1).to_s
            else
              targets << [name, file_name + ":" + (i+1).to_s]
            end
          end
        end
      rescue
        $stderr.print "\n\nError: #{$!.inspect} "
        $stderr.print " in #{file_name}:#{tk.line_no}\n\t #{lines[tk.line_no - 1]}" if tk
        $stderr.print "\n"
        exit
      end
      targets
    end

    def target?(file)
      ['.as', '.mxml'].include? File.extname(file)
    end
  end
end
