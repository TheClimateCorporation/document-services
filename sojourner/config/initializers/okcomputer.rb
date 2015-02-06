class LockFileCheck < OkComputer::Check
  LOCK_FILE = "/tmp/wb_lock"

  def check
    if File.exists? LOCK_FILE
      mark_failure
    end
  end
end

OkComputer::Registry.register 'lock_file_check', LockFileCheck.new

