# frozen_string_literal: true

module Del
  # Executes shell commands and pipes the
  # results back to the caller.
  class ShellCommand
    def initialize(command)
      @command = Array(command).flatten.join(' ')
    end

    def run
      Open3.popen3(@command) do |_stdin, stdout, stderr, wait_thr|
        stdout.each_line { |line| yield line }
        stderr.each_line { |line| yield line }
        wait_thr.value.success?
      end
    end
  end
end
