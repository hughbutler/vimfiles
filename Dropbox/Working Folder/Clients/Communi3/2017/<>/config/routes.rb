Rails.application.routes.draw do

    # Logins
    devise_for :users
    post '/logins' => 'logins#create'
    put '/logins/:id' => 'logins#update'
    delete '/logins/:id' => 'logins#destroy'
    get "account/login"
    get "account/register"
    get "dashboard/index", :as => :dashboard

    namespace :settings do
        resources :attributes

        scope '/' do
            get '', to: 'communities#edit', as: :community
            patch '', to: 'communities#update'
        end

        resources :positions
        resources :roles, :only => [:index, :create, :destroy]
        resources :mail_templates, :only => [:index, :edit, :update]
    end

    namespace :directory do
        resources :people do
            resources :attribute_answers
            resources :outside_position_logs, :only => [:index] do
                put :bulk_create, :on => :collection
            end

            collection do
                get "filter/:type/(:alpha)" => "people#filter", :as => "filter"
            end

            member do
                put :toggle_sd
                get 'access', to: 'users#edit'
                get 'experience', to: 'people#experience'
                get 'remove', to: 'people#remove'
            end
        end
    end

    resources :weekends do

        # resources :event_attendees, controller: 'weekends/financial_assistance', as: :financial_assistances do
        #   put :update_bulk_attenders, :on => :collection
        #   put :update_bulk_volunteers, :on => :collection
        #   get :roster, :on => :collection
        # end
        resources :meetings, controller: 'weekends/meetings' do
            member do
                post :toggle_attendance
            end
        end
        resources :attendees, controller: 'weekends/attendees', as: :attendees
        # get "meetings" => 'meeting_attendees#index', :as => :meeting_attendance
        # # post "meetings" => 'meeting_attendees#create', :as => :meeting_attendance
        # delete "meetings/:meeting_id/:person_id" => 'meeting_attendees#destroy', :as => 'meeting_attendee'

        resources :payments, controller: 'weekends/payments', as: :payments

        #
        member do
            get :closeout

            scope '/financial_assistance' do
                get '/', to: 'weekends/financial_assistance#index', as: :financial_assistance
                post '/:attendee_id', to: 'weekends/financial_assistance#update', as: :attendee_for
            end
            #   put :update_bulk_attenders, :on => :collection
            #   put :update_bulk_volunteers, :on => :collection
            #   get :roster, :on => :collection
        end
        # get "closeout" => "events#closeout"
        # get "ledger" => "events#ledger"
        # post "process_candidates" => "events#process_candidates"
        # # resources :meeting_attendees do
        # #   put :update_attendance, :on => :member
        # # end
        # resources :general_funds

    end
    get "events/archived" => "events#archived", :as => :archived_events
    resources :event_attendees, :only => :create

    # scope '/' do
    #   get '/' => 'dashboard#index'
    # end

    # scope '/reports' do
    #   get 'transactions', to: 'reports#transactions', as: :transaction_report
    # end

    ###########################################
    ########################################### MARKER
    ###########################################

    # Mail
    get '/mail_templates/deliver' => 'mail_templates#deliver'
    get '/mail_templates/find_by_context/:context' => 'mail_templates#find_by_context'

    # Queue
    get "/queue/:id" => 'queue#update', :via => :put, :as => :update_candidate
    get "/queue/invited" => 'queue#invited', :as => :invited_queue
    get "/queue/confirmed" => 'queue#confirmed', :as => :confirmed_queue
    get "/queue/protected" => 'queue#protected', :as => :protected_queue
    get "/queue" => 'queue#index', :as => :queue

    # Reports
    get "reports/rector" => "reports#rector", :as => :rector_report
    get "reports/experience" => "reports#experience", :as => :experience_report
    get "reports/index" => "reports#rector", :as => :reports

    resources :team_apps
    resources :attribute_values
    resources :marriages
    resources :notifiers

    resources :nominations do
        member do
            get 'activate'
        end
        collection do
            get 'responsibilities'
        end
    end

    resources :payments do
        post "pay_online" => 'payments#pay_online', :as => :pay_online, :on => :collection
    end

    resources :attribute_answers do
        put :update_individual, :on => :collection
    end

    # root :to => redirect("/users/sign_in")
    root 'dashboard#index'
end
