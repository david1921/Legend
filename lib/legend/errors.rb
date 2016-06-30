module Legend
  Error = Class.new(StandardError)

  class RequestError < Error
    attr_accessor :status
    attr_accessor :body

    def initialize(message=nil, status=nil, body=nil)
      super message
      self.status = status
      self.body = body
    end
  end

  BadRequest = Class.new(RequestError) # 400
  Unauthorized = Class.new(RequestError) # 401
  Forbidden = Class.new(RequestError) # 403
  NotFound = Class.new(RequestError) # 404
  MethodNotAllowed = Class.new(RequestError) # 405
  UnprocessableEntity = Class.new(RequestError) # 422
  InternalServerError = Class.new(RequestError) # 500
end
