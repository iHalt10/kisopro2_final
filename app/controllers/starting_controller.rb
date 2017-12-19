class StartingController < ApplicationController
  def index
    render :text => "StartingServerOK"
  end

  def initial
    $PreRegister = {
                        "iswaiting" => false,
                        "game_key"  => "",
                        "userPF"    => "",
                        "expire_at" => Time.parse("2030/01/01 00:00:00"),
                   }
    Redis.current.flushdb
    render :text => "InitializationOK"
  end
end
