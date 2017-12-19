class PlayController < ApplicationController
  def update
    if params["key"].nil? || params["turnInfo"].nil?
      response = "error:NotParam"
    else
      Redis.current.hmset( "MatchUp:" + params["key"], "turnInfo", params["turnInfo"] )
      turnState = Redis.current.hget( "MatchUp:" + params["key"], "turnState").to_i
      turnState = turnState + 1
      Redis.current.hmset( "MatchUp:" + params["key"], "turnState", turnState )
      response = "update_ok"
    end
    render :text => response
  end

  def check_wait
    if params["key"].nil? || params["Iam"].nil?
      response = "error:NotParam"
    else
      turnState = Redis.current.hget( "MatchUp:" + params["key"], "turnState").to_i
      if params["Iam"] == "DF"
        # DF 奇数か調べる 偶数だと更新されていない
        if turnState.odd?
          turnInfo = Redis.current.hget( "MatchUp:" + params["key"], "turnInfo")
          response = "YES," + turnInfo
        else
          response = "NO"
        end
      else # params["Iam"] == "PF"
        # PF 偶数か調べる 奇数だと更新されていない
        if turnState.even?
          turnInfo = Redis.current.hget( "MatchUp:" + params["key"], "turnInfo")
          response = "YES," + turnInfo
        else
          response = "NO"
        end
      end
    end
    render :text => response
  end

  def cancel
    if params["key"].nil?
      response = "error:NotParam"
    else
      Redis.current.hmset( "MatchUp:" + params["key"], "turnInfo", "Cancel" )
      response = "Cancel"
    end
    render :text => response
  end
end
