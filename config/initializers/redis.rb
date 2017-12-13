namespace = [Rails.application.class.parent_name, Rails.env].join ':'
case Rails.env
  when 'production'
    if ENV["REDISCLOUD_URL"]
      Redis.current = Redis::Namespace.new(namespace, redis: Redis.new(:url => ENV["REDISCLOUD_URL"]))
    end
  when 'test'
    Redis.current = Redis::Namespace.new(namespace, redis: Redis.new(host: '127.0.0.1', port: 6379))
  when 'development'
    Redis.current = Redis::Namespace.new(namespace, redis: Redis.new(host: '127.0.0.1', port: 6379))
end
Redis.current.ping

$GameRegister = Mutex.new
$PreRegister = {
                    "iswaiting" => false,
                    "game_key"  => "",
                    "userPF"    => "",
                    "expire_at" => Time.parse("2030/01/01 00:00:00"),
                }
