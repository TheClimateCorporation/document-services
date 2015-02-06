namespace :java do
  desc "Compiles *.java files in lib/java/source using javac"
  task :build do
    cp = Dir["#{Rails.root}/lib/java/jars/**/*.jar"].join(':')
    Dir["#{Rails.root}/lib/java/source/**/*.java"].each do |java_file|
      system("javac -cp #{cp} #{java_file}")
    end
    system("jar cf lib/java/jars/sojourner.jar -C #{Rails.root}/lib/java/source .")
  end
end
