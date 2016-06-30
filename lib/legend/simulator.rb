require 'date'
require 'factory_girl'
require 'faker'

module Legend
  class Simulator
    module Fake
      extend self

      def boolean
        [true, false].sample
      end

      def company
        Faker::Company.name
      end

      def date(minimum=(Date.today - 365 * 2), maximum=Date.today)
        rand(minimum...maximum)
      end

      def decimal(scale=3, precision=1)
        number(scale) / (10 ** precision)
      end

      def icd9
        "#{number(3)}.#{rand(30)}"
      end

      def id
        number(5)
      end

      def name
        [Faker::Name.last_name, Faker::Name.first_name].join(', ')
      end

      def number(digits=6)
        offset = 10 ** (digits - 1)
        rand((10 ** digits) - offset) + offset
      end

      def phrase(words=3)
        Faker::Lorem.words(words).join(' ')
      end

      def reason_for_visit
        [
          'ALCOHOL DEPENDENCE',
          'DEPRESSION',
          'DIABETES - DISEASE MANAGEMENT',
          'DIABETES EDUCATION',
          'DIABETES, CONSULT',
          'DIABETES, FOLLOW UP',
          'DIABETIC EYE EVALUATION',
          'DIABETIC FOOT',
          'HIGH BLOOD PRESSURE',
          'OPIOID DEPENDENCE',
          'PROBLEM, DIABETES',
        ].sample
      end
       
       def enc_note
           Faker::Lorem.paragraph(6)
       end
       
       def enc_note_format
           ["Plain Text","Rich Text"].sample
       end
       
       def prov_role 
           ['PCP - General','Psychologist','Primary Care Cross Coverage Provider'].sample
       end
       
       def enc_note_type
           ["Progress Notes","Telephone Encounter", "Sticky Note"].sample
       end
       
       def 
       
      def sex
        %w(M F).sample
      end

      def status
        (%w(Canceled Completed Sent) << '').sample
      end

      def time(minimum=(Time.now - 86_400 * 365 * 2), maximum=Time.now)
        rand(minimum...maximum)
      end

      def time_for_date(date)
        time(date.to_time, (date + 1).to_time - 1)
      end
    end

    def self.build(overrides={}, &block)
      new.build(overrides, &block)
    end

    def self.build_list(count, overrides={}, &block)
      count.times.collect { build(overrides, &block) }
    end

    def initialize(model, options={}, &block)
      self.model = model
      self.strategy = options.fetch(:strategy) { FactoryGirl::Strategy::Build }
      self.factory = define(&block)
    end

    def build(overrides={}, &block)
      factory.run(strategy, overrides, &block)
    end

  private

    attr_accessor :model
    attr_accessor :strategy
    attr_accessor :factory

    def define(&block)
      FactoryGirl::Factory.new(nil, class: model).tap do |factory|
        proxy = FactoryGirl::DefinitionProxy.new(factory.definition)
        proxy.instance_eval &block
      end
    end
  end
end
