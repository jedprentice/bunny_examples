#!/usr/bin/env ruby

require 'bunny'

def subscribe(channel, exchange, options)
  exclusive = options[:exclusive] || false
  queue = channel.queue(options[:queue], exclusive: exclusive)
  binding = queue.bind(exchange, routing_key: options[:routing_key])
  binding.subscribe do |delivery_info, metadata, payload|
    puts "#{options[:message]}: #{payload}, routing key is #{delivery_info.routing_key}"
  end
end

connection = Bunny.new
connection.start

channel = connection.create_channel

# Topic exchange name can be any string
exchange = channel.topic('weathr', auto_delete: true)

exchange.publish('San Diego update', routing_key: 'americas.north.us.ca.sandiego').
  publish('Berkeley update', routing_key: 'americas.north.us.ca.berkeley').
  publish('San Francisco update', routing_key: 'americas.north.us.ca.sanfrancisco').
  publish('New York update', routing_key: 'americas.north.us.ny.newyork').
  publish('Sao Paolo update', routing_key: 'americas.south.brazil.saopaolo').
  publish('Hong Kong update', routing_key: 'asia.southeast.hk.hongkong').
  publish('Kyoto update', routing_key: 'asia.southeast.japan.kyoto').
  publish('Shanghai update', routing_key: 'asia.southeast.prc.shanghai').
  publish('Rome update', routing_key: 'europe.italy.roma').
  publish('Paris update', routing_key: 'europe.paris.france')

sleep 1.0

connection.close

