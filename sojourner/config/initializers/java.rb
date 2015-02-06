# Load java jars
Dir["#{Rails.root}/lib/java/jars/**/*.jar"].each { |jar| $CLASSPATH << jar }
