class Template < ActiveRecord::Base
  validates :name, :type, :created_by, presence: true

  scope :singles, -> { where(type: 'TemplateSingle') }
  scope :bundles, -> { where(type: 'TemplateBundle') }

  def version(*args)
    begin
      version!(*args)
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def version!(num_or_opts = {})
    return version_from_options(num_or_opts) if num_or_opts.is_a?(Hash)

    versions.find_by_version(num_or_opts).tap do |v|
      if v.nil?
        raise ActiveRecord::RecordNotFound, "not found for version #{num_or_opts}"
      end
    end
  end

  def versions
    raise "The subclass needs to have an implementation of this"
  end

  private

  def version_from_options(opts = {})
    raise "The subclass needs to have an implementation of this"
  end
end
