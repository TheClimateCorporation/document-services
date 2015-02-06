dev_license = DotProperties.fetch('windward.developer.license') { nil }
Java::WindwardTemplateRenderer.license = DotProperties.fetch('windward.v13.license', dev_license)
