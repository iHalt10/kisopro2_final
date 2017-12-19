class MatchUp
  def self.save(match_up_key, userPF, userDF)
    match_up = {
                "userPF"       => userPF,
                "userDF"       => userDF,
                "turnState" => 0,
                "turnInfo"     => ""
              }
    match_up_hash = Redis::HashKey.new( "MatchUp:" + match_up_key )
    match_up_hash.bulk_set( match_up )
    match_up_hash.expire( 6.hour )
  end
end
