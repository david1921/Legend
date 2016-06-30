require 'hashie/mash'

module Legend
  class Mash < Hashie::Mash
  protected

    def convert_value(value, duping=false)
      case value
        when /^$/ then nil
        when String then super.strip
        else super
      end
    end
  end
end
