require 'sinatra'
require './sanitizer'

post '/webhook' do
  payload = JSON.parse(request.body.read)
  payload = Sanitizer.traverse_and_sanitize(payload)
  # Write payload to file, pretty print it, and return it
  File.write("webhooks/#{payload['type']}.json", JSON.pretty_generate(payload))

  [201, 'OK']
end
