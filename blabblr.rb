#!/usr/bin/env ruby

require 'bunny'

def subscribe(channel, exchange, queue_name)
  channel.queue(queue_name, auto_delete: true).bind(exchange).subscribe do |delivery_info, metadata, payload|
    puts "#{payload} => #{queue_name}" 
  end
end

conn = Bunny.new('amqp://guest:guest@localhost:5672')
conn.start

channel = conn.create_channel
exchange = channel.fanout('nba.scores')

subscribe(channel, exchange, 'joe')
subscribe(channel, exchange, 'aaron')
subscribe(channel, exchange, 'bob')

exchange.publish('BOS 101, NYK 89').publish('ORL 85, ALT 88')

conn.close

