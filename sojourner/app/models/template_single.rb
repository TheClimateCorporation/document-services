class TemplateSingle < Template
  has_many :versions,
           foreign_key: "template_id",
           class_name: "TemplateSingleVersion"

  private

  def version_from_options(opts = {})
    raise ArgumentError, "schema_id was not provided" unless opts[:schema_id]

    vs = versions.where(template_schema_id: opts[:schema_id])
    unless vs.exists?
      raise ActiveRecord::RecordNotFound, "doesn't exist for schema_id #{opts[:schema_id]}"
    end

    if opts[:version]
      unless versions.where(version: opts[:version]).exists?
        raise ActiveRecord::RecordNotFound, "doesn't exist for version #{opts[:version]}"
      end

      vs = vs.where(version: opts[:version])
      unless vs.where(version: opts[:version]).exists?
        raise ActiveRecord::RecordNotFound, "doesn't exist for version #{opts[:version]} and schema_id #{opts[:schema_id]}"
      end
    end

    if opts[:as_production]
      vs = vs.select(&:ready_for_production?)
      if vs.empty?
        raise ActiveRecord::RecordNotFound, "is not available in production"
      end
    end

    vs.last
  end
end
