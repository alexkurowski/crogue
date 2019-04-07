Environment = ENV.fetch("ENV") { "development" }

def test?
  Environment == "test"
end
