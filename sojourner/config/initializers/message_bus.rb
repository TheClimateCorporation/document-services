MESSAGE_BUS_CONFIG = YAML.load_file("#{Rails.root}/config/message_bus.yml")[Rails.env]
