module CLITool
  require 'readline'

  $internal_state = {
    :prompt => Proc.new {"> "},
    :commands => {}
  }

  def prompt(&block)
    if block_given? then
      $internal_state[:prompt] = block
    else
      $internal_state[:prompt].call
    end
  end

  def command(regex, &block)
    buf = regex
    if block_given? then
      $internal_state[:commands][regex] = block
    else
      $internal_state[:commands].each do |regex, proc|
        if buf =~ regex then
          proc.call(Regexp.last_match)
          break
        end
      end
    end
  end

  def clitool
    while buf = Readline.readline(prompt, true)
      command(buf)
    end
  end
end
