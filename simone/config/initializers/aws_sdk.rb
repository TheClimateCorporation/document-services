#in ec2, credentials are supplied through instance roles

AWS.config(access_key_id: DotProperties.fetch('aws.access_key') { nil },
           secret_access_key: DotProperties.fetch('aws.secret_access_key') { nil },
           region: 'us-east-1')
