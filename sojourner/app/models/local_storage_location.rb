class LocalStorageLocation < StorageLocation

  def file_saved?
    File.exists?(uri)
  end

  def read_link
    @read_link ||= "/#{storable.key_prefix}/#{key}"
  end

  def open(&block)
    File.open(uri, 'rb', &block)
  end

  private

  def set_uri
    self.uri ||= "#{storable_directory}/#{key}"
  end

  def storable_directory
    dir = File.join(Rails.root, Rails.env.test? ? 'tmp' : 'public', storable.key_prefix)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    dir
  end

  def put!
    File.open(uri, 'wb') { |dest| dest.write(file.read) }
  end

end
