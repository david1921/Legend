require 'virtus'
require 'legend/coercions/epic_boolean'
require 'legend/coercions/epic_date'
require 'legend/coercions/epic_decimal'

module Legend
  class Model
    include Virtus.model
  end
end
