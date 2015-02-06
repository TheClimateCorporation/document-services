DocumentGenerationJob = Struct.new(:generation_metadata_id) do

  def perform
    DocumentProcessor.new(
      generation_metadata: GenerationMetadata.find(generation_metadata_id)
    ).process
  end

  def error(job, exception)
    generation_metadata_id = stored_generation_metadata_id(job)

    msg = "An error occured while processing DocumentGenerationJob " \
      "for GenerationMetadata #{generation_metadata_id}: "
    Rails.logger.error msg + exception.message
  end

  #TODO: add failure hook to notify message bus

  def queue_name
    'docgen'
  end

  def stored_generation_metadata_id(job)
    YAML.load(job.handler).generation_metadata_id
  end
end
