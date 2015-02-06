class LocalDocument < Document

  DEFAULT_DIRECTORY = File.join(Rails.root, Rails.env.test? ? 'tmp' : 'public', 'documents')

  def file_saved?
    File.exists?(uri)
  end

  def read_link
    "documents/#{document_id}/#{name}#{file_extension}"
  end

  private

  def set_uri
    self.uri ||= File.join(default_directory, document_id,
      "#{name}#{file_extension}")
  end

  def default_directory
    DEFAULT_DIRECTORY
  end

  def put!
    FileUtils.mkdir_p(File.dirname(uri))
    File.open(uri, 'wb') { |dest| dest.write(file.read) }
  end

end
