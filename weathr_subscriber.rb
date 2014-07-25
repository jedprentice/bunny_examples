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

# Subscribers
subscribe(
  channel,
  exchange, {
    queue: '',
    exclusive: true,
    routing_key: 'americas.north.#',
    message: 'an update for North America'
  }
)

subscribe(
  channel,
  exchange, {
    queue: 'americas.south',
    routing_key: 'americas.south.#',
    message: 'an update for South America'
  }
)

subscribe(
  channel,
  exchange, {
    queue: 'us.california',
    routing_key: 'americas.north.us.ca',
    message: 'an update for US/California'
  }
)

subscribe(
  channel,
  exchange, {
    queue: 'us.tx.austin',
    routing_key: '#.tx.austin',
    message: 'an update for Austin, TX'
  }
)

subscribe(
  channel,
  exchange, {
    queue: 'it.rome',
    routing_key: 'europe.italy.rome',
    message: 'an update for Rome, Italy'
  }
)

subscribe(
  channel,
  exchange, {
    queue: 'asia.hk',
    routing_key: 'asia.southeast.hk.#',
    message: 'an update for Hong Kong'
  }
)

puts "#{__FILE__} started with pid #{Process.pid}"

loop do
  # wait for events
end
