require 'faraday'
require 'faraday/conductivity'

require 'legend/errors'
require 'legend/mash'
require 'legend/models/bmi'
require 'legend/models/bp'
require 'legend/middleware/convert_response'
require 'legend/middleware/handle_errors'
require 'legend/middleware/mashify'
require 'legend/middleware/parse_json'

module Legend
  class Patient
    ACCEPT = 'application/json'

    attr_accessor :id
    attr_accessor :username
    attr_accessor :password
    attr_accessor :type
    attr_accessor :url

    def initialize(options={})
      self.id = options.fetch(:id)
      self.username = options.fetch(:username)
      self.password = options.fetch(:password)
      self.type = options.fetch(:type)
      self.url = options.fetch(:url) { ENV.fetch('EPIC_URL') }
    end

    def authenticate(options={})
      params = params(
        options,
        appointment_date: :AppointmentDate,
        department_id: :DepartmentID
      )

      get('PatientAuthentication.svc/rest/', params).body
    end

    def data(options={})
         params = params(options)
         get('GetPatientData.svc/rest/', params).body
      #raise NotImplmentedError
    end

    def demographics(options={})
      params = params(options, department_id: :DepID, user_id: :UserId)
      get('GetPatientDemographics.svc/rest/', params).body
    end

    def encounters(options={})
      params = params_with_dates(options)
      get('GetEncounter.svc/rest/', params).body
    end

    def encounter_notes(options={})
       params = params_with_dates(options)
       get('GetEncounterNote.svc/rest/', params).body
    end

    def all_labs(options={})
      params = params_with_dates(options, min_values: :minNumberOfValues)
      get('GetAllLabs.svc/rest/', params).body
    end
    
     def labs(options={})
      params = params_with_dates(options)
      get('GetLabs.svc/rest/', params).body
    end

    def medication_orders(options={})
      params = params_with_dates(options)
      get('GetMedicationOrders.svc/rest/', params).body
    end

    def orders(options={})
      params = params_with_dates(options)
      get('GetOrders.svc/rest/', params).body
    end

    def problem_list(options={})
      params = params_with_dates(options)
      get('GetProblemListDiagnosis.svc/rest/', params).body
    end

    def providers(options={})
      params = params_with_dates(options)
      get('GetProvider.svc/rest/', params).body
    end

    def vitals(options={})
      params = params_with_dates(options, min_values: :minNumberOfValues)
      get('GetVitals.svc/rest/', params).body
    end
    
    def vitals_filter param
        case param
        when "bmi"
        get_bmi.compact.flatten
        when "bp"
        get_bp
      end
    end
    
    def get_bmi
        vitals.collect.with_index do |vital, index|
          if vital.name == "bmi"
            vital.readings.map do |bmi|
             Legend::Models::Bmi.new(bmi.value,bmi.date)
          end
         end
        end
    end
    
    def get_bp
        obj_array = []
        vitals.collect.with_index do |vital, index|
           case vital.name
           when "diabp"
            obj_array = vital.readings.map { |bp|
            Legend::Models::Bp.new(bp.value, nil, bp.date)
            }
          when "sysbp"
            vital.readings.collect.with_index do |bp,index|
             obj_array[index].sysbp = bp.value
           end
         end
        end 
        obj_array
    end

  private

    def connection
      Faraday.new(url: url, ssl: {verify: false}) do |faraday|
        faraday.use Middleware::ConvertResponse
        faraday.use Middleware::Mashify, mash_class: Mash
        faraday.use Middleware::ParseJSON
        faraday.use Middleware::HandleErrors
        faraday.use :extended_logging, logger: Rails.logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def get(path, options)
      connection.get(path, options) do |request|
        request['Accept'] = ACCEPT
      end
    end

    def params(options, extra={})
      params = {}

      params[:ID] = options.fetch(:id, id)
      params[:Type] = options.fetch(:type, type)
      params[:Username] = username
      params[:Password] = password

      extra.each do |key, param_name|
        params[param_name] = options[key] if options[key]
      end

      params
    end

    def params_with_dates(options, extra={})
      params(options, extra.merge(start_date: :StartDate, end_date: :EndDate))
    end
  end
end
