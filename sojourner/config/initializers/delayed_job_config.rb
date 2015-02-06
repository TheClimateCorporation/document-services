Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.default_queue_name = 'docgen'
Delayed::Worker.delay_jobs = true # !Rails.env.test?
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
