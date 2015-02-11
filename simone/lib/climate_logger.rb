# CustomLogger is simply a wrapper around the Logger
# It supports all Logger methods
# Using this wrapper allows us to overload method calls to Logger
class CustomLogger < DelegateClass(Logger)

  # @param file_path [String, IO] defaults to STDOUT
  def initialize(file_path = STDOUT)
    logger = Logger.new(file_path)
    logger.formatter = CustomLogger::Formatter.new
    super(logger)
  end

  # Format logs, including information about the last exception
  #
  # Example:
  #  [1] pry(main)> Rails.logger.info { "Hello" }
  #  [INFO] | time=2014-08-12 16:11:48 -0700 | request_id= | msg=Hello
  #  => true
  #
  # Error example:
  #  [1] pry(main)> begin
  #  [1] pry(main)*   raise "EXCEPTION AHHH"
  #  [1] pry(main)* rescue
  #  [1] pry(main)*   Rails.logger.error { "An error occured" }
  #  [1] pry(main)* end
  #  [ERROR] | time=2014-08-12 16:09:58 -0700 | request_id= | exception=EXCEPTION AHHH | backtrace=(pry):2:in `<main>'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:328:in `eval'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:328:in `evaluate_ruby'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:278:in `re'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:254:in `rep'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:234:in `block (3 levels) in repl'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:232:in `loop'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:232:in `block (2 levels) in repl'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:231:in `catch'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:231:in `block in repl'
  #  /home/ubuntu/.rvm/gems/ruby-1.9.3-p125@pro/gems/pry-0.9.12/lib/pry/pry_instance.rb:230:in `catch'
  #  -e:1:in `<main>' | msg=An error occured
  #
  class Formatter
    def call(severity, time, progname, msg)
      # $! and $@ are thread locals that hold the last exception message and backtrace, respectively
      # See: https://github.com/ruby/ruby/blob/trunk/lib/English.rb

      severity   = "[#{severity}] | "
      time       = "time=#{time} | "
      request_id = "request_id=#{Thread.current[:request_id]} | "
      exception  = $! && "exception=#{$!} | "
      backtrace  = $! && "backtrace=#{$@.take(10).join("
")} | "
      message    = "#{msg}
"

      [severity, time, request_id, exception, backtrace, message].join
    end
  end
end
