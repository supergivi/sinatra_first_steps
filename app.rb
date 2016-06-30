require 'sinatra'
require 'json'
set :bind, '0.0.0.0'


get '/room.json' do
  if !File.exist?('data.json')
    File.open("data.json", 'w') {|f| f.write({current_temperature: 22, set_temperature: 23}.to_json) }
  end
  file = File.open("data.json", 'r')
  content_type :json
  data = file.read
  file.close
  data
end

post '/room.json' do
  file = File.open("data.json", 'r')
  data = JSON.parse(file.read)
  file.close
  data.merge!(JSON.parse(request.env["rack.input"].read))
  File.open("data.json", 'w') {|f| f.write(data.to_json) }
  content_type :json
  {result: :ok}.to_json
end




