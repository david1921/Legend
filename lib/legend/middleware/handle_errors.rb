require 'legend/errors'
require 'faraday'

module Legend
  module Middleware
    class HandleErrors < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status]
          when 200
          when 201
          when 400 then fail with(BadRequest, env)
          when 401 then fail with(Unauthorized, env)
          when 403 then fail with(Forbidden, env)
          when 404 then fail with(NotFound, env)
          when 405 then fail with(MethodNotAllowed, env)
          when 422 then fail with(UnprocessableEntity, env)
          when 500 then fail with(InternalServerError, env)
          else fail with(RequestError, env)
        end
      end

    private

      def with(error_class, env)
        error_class.new(nil, env[:status], env[:body])
      end
    end
  end
end
