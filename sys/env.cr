Environment = ENV.fetch("ENV") { "development" }

def run?
  Environment != "test"
end
