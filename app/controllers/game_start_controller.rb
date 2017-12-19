class GameStartController < ApplicationController
  def request_accept
    if params["name"].nil?
      response = "error:NoNameParam"
    else
      $MatchUpRegister.synchronize {
        if $PreRegister["iswaiting"] && Time.now < $PreRegister["expire_at"]
          # 対戦相手がいる
          MatchUp.save($PreRegister["game_key"], $PreRegister["userPF"], params["name"])
          response = "START_DF," + $PreRegister["game_key"] + "," + $PreRegister["userPF"]
          $PreRegister["iswaiting"] = false
        else
          # 対戦相手がいない
          $PreRegister["game_key"]  = SecureRandom.hex
          $PreRegister["userPF"]    = params["name"]
          $PreRegister["expire_at"] = Time.now + 30.second

          response = "WAITING," + $PreRegister["game_key"]
          $PreRegister["iswaiting"] = true
        end
      }
    end
    render :text => response
  end

  def request_cancel
    $MatchUpRegister.synchronize {
      $PreRegister["iswaiting"] = false
    }
    render :text => "Cancel"
  end

  def check_wait
    if params["key"].nil?
      response = "error:NokeyParam"
    else
      $MatchUpRegister.synchronize {
        if Redis.current.type( "MatchUp:" + params["key"] ) == "hash"
          # 対戦相手が見つかっている
          response = "START_PF," + Redis.current.hget( "MatchUp:" + params["key"], "userDF")
        else
          # 対戦相手が見つかっていない
          $PreRegister["expire_at"] = Time.now + 30.second
          response = "WAITING"
        end
      }
    end
    render :text => response
  end
end
