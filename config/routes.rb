Rails.application.routes.draw do
  root 'starting#index'
  get 'initialization', to: 'starting#initial'

  get 'start/request', to: 'game_start#request_accept'
  get 'start/cancel', to: 'game_start#request_cancel'
  get 'start/check/wait', to: 'game_start#check_wait'

  get 'play/update', to: 'play#update'
  get 'play/cancel', to: 'play#cancel'
  get 'play/check/wait', to: 'play#check_wait'

end
