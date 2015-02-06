class NullLocation < StorageLocation

  def file_saved?
    true
  end

  def read_link
    key
  end

  def open(&block)
    StringIO.open("", "rb", &block)
  end

  private

  def set_uri
    self.uri ||= key
  end

  def put!
    true
  end

end
