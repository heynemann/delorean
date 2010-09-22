require 'sinatra/base'

module Sinatra
  module Authorization

    def auth
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
    end

    def unauthorized!(realm="delorean database")
      halt 401, {'WWW-Authenticate' => %(Basic realm="#{realm}")}, 'Authorization Required'
    end

    def bad_request!
      halt 400, 'Bad Request'
    end

    def authorized?
      request.env['REMOTE_USER']
    end

    def logout
      request.env.delete('REMOTE_USER')
    end

    def authorize(username, password, right_username, right_password)
      username == right_username and password == right_password
    end

    def require_administrative_privileges(right_username, right_password)
      return if authorized?
      unauthorized! unless auth.provided?
      bad_request! unless auth.basic?
      username, password = *auth.credentials
      unauthorized! unless authorize(username, password, right_username, right_password)
      request.env['REMOTE_USER'] = auth.username
    end

    def admin?
      authorized?
    end

  end
end