require 'sinatra'
require 'json'
require 'ohm'
set :bind, '0.0.0.0'


get '/room.json' do
  room = Room.find(name: 'room').first
  if room.nil?
    room = Room.create(name: 'room', current_temperature: 22, set_temperature: 23)
  end
  content_type :json
  room.to_hash.to_json
end

post '/room.json' do
  room = Room.find(name: 'room').first
  room.update(set_temperature: JSON.parse(request.env["rack.input"].read)['set_temperature'])
  content_type :json
  {result: :ok}.to_json
end

post 'rooms' do
  room = Room.find(name: params[:room]).first
  if room.nil?
    room = Room.create(name: params[:room])
  end
  room.update
end

class Room < Ohm::Model
  attribute :name
  attribute :current_temperature
  attribute :set_temperature
  unique :name

  def to_hash
    { name: name, current_temperature: current_temperature, set_temperature: set_temperature }
  end

  index :name
end
