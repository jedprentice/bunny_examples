#!/usr/bin/env ruby

require 'bunny'

conn = Bunny.new
conn.start

channel = conn.create_channel
queue = channel.queue('bunny.examples.hello_world', auto_delete: true)
exchange = channel.default_exchange

queue.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end

exchange.publish('Hello!', routing_key: queue.name)
sleep 1.0
conn.close

