module Del
  class ShellCommand
    def initialize(command)
      @command = Array(command).flatten.join(' ')
    end

    def run
      Open3.popen3(@command) do |stdin, stdout, stderr, wait_thr|
        stdout.each_line { |line| yield line }
        stderr.each_line { |line| yield line }
        wait_thr.value.success?
      end
    end
  end
end
