module MyLocalPutio
  class Configuration
    attr_reader :token, :local_destination, :silent, :debug
    def initialize
      read_args_from_envs!
      parse_args!
      validate_args!
    end

    private
    def parse_args!
      OptionParser.new do |opt|
        opt.on("-t", "--token TOKEN", "Put.io access token [REQUIRED]") { |v| @token = v }
        opt.on("-l", "--local-destination PATH", "Local destination path [REQUIRED]") { |v| @local_destination = v }
        opt.on("-v", "--version", "Print my-local-putio version") do
          puts MyLocalPutio::VERSION
          exit
        end

        opt.on("-s", "--silent", "Hide all messages and progress bar") { |v| @silent = true }
        opt.on("-d", "--debug", "Debug mode [Developer mode]") { |v| @debug = true }
      end.parse!
    end

    def validate_args!
      unless @token
        puts "Missing token"
        exit
      end

      unless @local_destination
        puts "Missing local destination"
        exit
      end

      unless File.writable?(@local_destination)
        puts "Cannot write on the local destination path '#{@local_destination}'"
        exit
      end
      end
    end

    def read_args_from_envs!
      @token ||= ENV["PUTIO_TOKEN"]
    end
  end
end
