task default: [:run]

task :debug do
  sh "shards build -d && lldb bin/game"
end

task :run do
  sh "shards build && bin/game"
end

task :test do
  sh "ENV=test crystal spec"
end
