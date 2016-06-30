require 'spec_helper'

require 'epic/patient'

describe Epic::Patient do
  let(:id) { rand(10_000) }
  let(:type) { 'EXTERNAL' }
  let(:username) { 'username' }
  let(:password) { 'password' }

  let(:url) { 'https://maestro.daftmill.test/sim/v1' }

  subject(:patient) {
    described_class.new(
      id: id,
      type: type,
      username: username,
      password: password,
      url: url,
    )
  }

  describe '.new' do
    let(:env) { {} }

    let(:options) {
      {
        id: id,
        username: username,
        password: password,
        type: type,
        url: url,
      }
    }

    before do
      stub_const('ENV', env)
    end

    it 'accepts an options hash' do
      described_class.new(options)
    end

    it 'requires a patient ID' do
      expect { described_class.new(options_without(:id)) }.to raise_error
    end

    it 'requires a username' do
      expect { described_class.new(options_without(:username)) }.to raise_error
    end

    it 'requires a password' do
      expect { described_class.new(options_without(:password)) }.to raise_error
    end

    it 'requires a type' do
      expect { described_class.new(options_without(:type)) }.to raise_error
    end

    it 'requires a URL' do
      expect { described_class.new(options_without(:url)) }.to raise_error
    end

    context 'with an EPIC_URL environment variable' do
      before do
        env['EPIC_URL'] = url
      end

      it 'reads the URL from the environment variable' do
        patient = described_class.new(options_without(:url))
        expect(patient.url).to eq url
      end
    end

    def options_without(key)
      options.dup.tap { |options| options.delete(key) }
    end
  end

  describe '#authenticate' do
    let(:json) { File.read('spec/fixtures/patient.json') }

    let(:appointment_date) { '' }
    let(:department_id) { '' }

    let(:options) {
      {
        appointment_date: appointment_date,
        department_id: department_id
      }
    }

    before do
      stub_request(:get, /PatientAuthentication.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'AppointmentDate' => appointment_date,
            'DepartmentID' => department_id,
            'Username' => username,
            'Password' => password,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the user info' do
      response = patient.authenticate(options)

      expect(response.patient_id).to eq '8521'
      expect(response.medical_record_number).to eq '25001343'
      expect(response.given_name).to eq 'Rddooc'
      expect(response.middle_initial).to be_nil
      expect(response.family_name).to eq 'Zztest'
      expect(response.suffix).to be_nil
      expect(response.title).to be_nil
      expect(response.date_of_birth).to eq Date.new(1950, 1, 25)
      expect(response.sex).to eq :female
      expect(response.appointments[0].date).to eq Date.new(2014, 8, 5)
      expect(response.appointments[0].department).to eq 'PMPA RHEUM PALO ALTO'
      expect(response.appointments[0].status).to eq 'Scheduled'
      expect(response.appointments[0].time).to eq Time.new(2014, 8, 5, 10, 40)
      expect(response.appointments[0].type).to eq 'Appointment'
      expect(response.appointments[0].csn).to eq '400040984'
    end

    it 'uses the specified ID and type' do
      csn = rand(100_000_000).to_s

      expect(patient)
        .to receive(:get)
        .with(
          'PatientAuthentication.svc/rest/',
          ID: csn,
          Type: 'CSN',
          Username: username,
          Password: password,
        )
        .and_return(double(body: json))

      patient.authenticate(id: csn, type: 'CSN')
    end

    context 'when the CSN is invalid' do
      before do
      stub_request(:get, /PatientAuthentication.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'AppointmentDate' => appointment_date,
            'DepartmentID' => department_id,
            'Username' => username,
            'Password' => password,
          },
        )
        .to_return(
          status: [400, 'Invalid CSN was provided'],
          headers: { 'Content-Type' => 'text/html; charset=UTF-8' },
          body: '<p class="heading1">Request Error</p>',
        )
      end

      it 'raises an error' do
        expect { patient.authenticate(options) }
          .to raise_error Epic::BadRequest
      end
    end
  end

  describe '#demographics' do
    let(:json) { File.read('spec/fixtures/patient_demographics.json') }

    before do
      stub_request(:get, /GetPatientDemographics.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the patient demographics' do
      demographics = patient.demographics

      expect(demographics.patient_id).to eq '8521'
      expect(demographics.medical_record_number).to eq '7942'
      expect(demographics.name).to eq 'Zztest, Rddooc'
      expect(demographics.given_name).to eq 'Rddooc'
      expect(demographics.middle_initial).to be_nil
      expect(demographics.family_name).to eq 'Zztest'
      expect(demographics.date_of_birth).to eq Date.new(1950, 1, 25)
      expect(demographics.sex).to eq :female
      expect(demographics.insurance).to eq 'Blue Cross Federal Emp'
    end
  end

  describe '#encounters' do
    let(:json) { File.read('spec/fixtures/encounters.json') }

    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }

    let(:options) { { start_date: start_date, end_date: end_date } }

    before do
      stub_request(:get, /GetEncounter.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' => end_date,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the encounters' do
      encounters = patient.encounters(options)

      expect(encounters[7].csn).to eq '400027100'

      expect(encounters[7].type.id).to eq '101'
      expect(encounters[7].type.name).to eq 'Office Visit'

      expect(encounters[7].date).to eq Date.new(2014, 1, 23)
      expect(encounters[7].appointment_time).to eq Time.new(2014, 1, 23, 10, 0)
      expect(encounters[7].check_in_time).to eq Time.new(2014, 1, 23, 9, 58, 0)
      expect(encounters[7].showed).to eq true

      expect(encounters[7].reasons_for_visit).to eq ['FOLLOW UP']
      expect(encounters[7].chief_complaint).to be_nil

      expect(encounters[7].clinic.id).to eq '15058'
      expect(encounters[7].clinic.name)
        .to eq 'PMPA PALO ALTO 795 EL CAMINO REAL'

      expect(encounters[7].department.id).to eq '203'
      expect(encounters[7].department.name).to eq 'PMPA RHEUM PALO ALTO'

      expect(encounters[7].provider.id).to eq '3011'
      expect(encounters[7].provider.name).to eq 'BOBROVE, ARTHUR M'

      expect(encounters[6].referral_diagnoses[0].icd9).to eq '724.02'
      expect(encounters[6].referral_diagnoses[0].name)
        .to eq 'Lumbar spinal stenosis'

      expect(encounters[7].diagnoses[0].icd9).to eq '714.0'
      expect(encounters[7].diagnoses[0].name)
        .to eq 'Rheumatoid arthritis(714.0) (HCC)'
      expect(encounters[7].diagnoses[1].icd9).to eq '721.0'
      expect(encounters[7].diagnoses[1].name)
        .to eq 'Cervical spondylosis without myelopathy'

      expect(encounters[7].closed_at).to eq Time.new(2014, 1, 23, 13, 29, 53)
      expect(encounters[7].closed_by_user_id).to eq '3011'
      expect(encounters[7].closed).to eq true
    end
  end

  describe '#labs' do
    let(:json) { File.read('spec/fixtures/labs.json') }

    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }
    let(:min_values) { '4' }

    let(:options) {
      { start_date: start_date, end_date: end_date, min_values: min_values }
    }

    before do
      stub_request(:get, /GetAllLabs.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' => end_date,
            'minNumberOfValues' => min_values,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the patient labs' do
      labs = patient.labs(options)

      expect(labs[1].name).to eq 'CBC WITH AUTOMATED DIFFERENTIAL'
      expect(labs[1].order_date).to eq Date.new(2012, 7, 20)
      expect(labs[1].collection_date).to eq Date.new(2012, 7, 20)
      expect(labs[1].result_date).to eq Date.new(2012, 7, 20)
      expect(labs[1].status).to eq 'Completed'
      expect(labs[1].abnormal).to eq true
      expect(labs[1].results[2].component).to eq 'HEMOGLOBIN'
      expect(labs[1].results[2].value).to eq 10.8
      expect(labs[1].results[2].display_value).to eq '10.8'
      expect(labs[1].results[2].in_range).to eq false
      expect(labs[1].results[2].reference_high).to eq 15.5
      expect(labs[1].results[2].reference_low).to eq 12.0
      expect(labs[1].results[2].reference_normal).to be_nil
      expect(labs[1].results[2].flag).to eq 'Low'

      expect(labs[13].results[2].value).to eq 5
      expect(labs[13].results[2].display_value).to eq '<5'
    end
  end

  describe '#medication_orders' do
    let(:json) { File.read('spec/fixtures/medication_orders.json') }

    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }

    let(:options) { { start_date: start_date, end_date: end_date } }

    before do
      stub_request(:get, /GetMedicationOrders.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' => end_date,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the patient medication orders' do
      medication_orders = patient.medication_orders(options)

      expect(medication_orders[0].id).to eq '42006'
      expect(medication_orders[0].klass.id).to eq '27'
      expect(medication_orders[0].klass.name).to eq 'Antidiabetic'
      expect(medication_orders[0].subklass.id).to eq '2750'
      expect(medication_orders[0].subklass.name).to eq 'Alpha-Glucosidase Inhibitors'
      expect(medication_orders[0].name_dose_sig).to eq 'ACARBOSE 100 MG PO TABS'
      expect(medication_orders[0].metric).to eq 'HBA1C'
      expect(medication_orders[0].associated_diagnoses).to eq ['Secondary diabetes mellitus with unspecified complication, uncontrolled (HCC)']
      expect(medication_orders[0].order_date).to eq Date.new(2013, 9, 24)
      expect(medication_orders[0].end_date).to eq Date.new(2013, 9, 27)
      expect(medication_orders[0].patient_reported).to eq false

      expect(medication_orders[9].id).to eq '88600'
      expect(medication_orders[9].klass.id).to eq '33'
      expect(medication_orders[9].klass.name).to eq 'Beta blockers'
      expect(medication_orders[9].subklass.id).to eq '3330'
      expect(medication_orders[9].subklass.name).to eq 'Alpha-Beta Blockers'
      expect(medication_orders[9].name_dose_sig).to eq 'CARVEDILOL PHOSPHATE ER 80 MG PO CP24'
      expect(medication_orders[9].metric).to eq 'BP'
      expect(medication_orders[9].associated_diagnoses).to eq ['Secondary diabetes mellitus with unspecified complication, uncontrolled (HCC)']
      expect(medication_orders[9].order_date).to eq Date.new(2013, 9, 24)
      expect(medication_orders[9].end_date).to be_nil
      expect(medication_orders[9].patient_reported).to eq false

      expect(medication_orders[22].id).to eq '26225'
      expect(medication_orders[22].klass.id).to eq '39'
      expect(medication_orders[22].klass.name).to eq 'Antihyperlipidemic'
      expect(medication_orders[22].subklass.id).to eq '3910'
      expect(medication_orders[22].subklass.name).to eq 'Bile Acid Sequestrants'
      expect(medication_orders[22].name_dose_sig).to eq 'CHOLESTYRAMINE 4 G PO PACK'
      expect(medication_orders[22].metric).to eq 'LDL'
      expect(medication_orders[22].associated_diagnoses).to eq ['Hypertension, accelerated']
      expect(medication_orders[22].order_date).to eq Date.new(2013, 10, 2)
      expect(medication_orders[22].end_date).to be_nil
      expect(medication_orders[22].patient_reported).to eq false
    end
  end

  describe '#orders' do
    let(:json) { File.read('spec/fixtures/orders.json') }

    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }

    let(:options) { { start_date: start_date, end_date: end_date } }

    before do
      stub_request(:get, /GetOrders.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' => end_date,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the orders' do
      orders = patient.orders(options)

      expect(orders[0].date).to eq Date.new(2013, 9, 23)
      expect(orders[0].id).to eq '213283080'
      expect(orders[0].name).to eq 'LIPID PROFILE'
      expect(orders[0].status).to be_nil
      expect(orders[0].type).to eq 'LAB CHEMISTRY'
      expect(orders[0].procedure.category_code).to eq '62'
      expect(orders[0].procedure.category_name).to eq 'LAB HEMATOLOGY'
      expect(orders[0].procedure.master_number).to eq 'LABLIPID'
      expect(orders[0].result_date).to be_nil

      expect(orders[4].date).to eq Date.new(2013, 9, 23)
      expect(orders[4].id).to eq '213283084'
      expect(orders[4].name).to eq 'HEMOGLOBIN A1C'
      expect(orders[4].status).to eq 'Completed'
      expect(orders[4].type).to eq 'LAB CHEMISTRY'
      expect(orders[4].procedure.category_code).to eq '62'
      expect(orders[4].procedure.category_name).to eq 'LAB HEMATOLOGY'
      expect(orders[4].procedure.master_number).to eq 'LABGLYCO'
      expect(orders[4].result_date).to eq Date.new(2010, 1, 1)
    end
  end

  describe '#problem_list' do
    let(:json) { File.read('spec/fixtures/problem_list_diagnosis.json') }

    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }

    let(:options) { { start_date: start_date, end_date: end_date } }

    before do
      stub_request(:get, /GetProblemListDiagnosis.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' => end_date,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the patient problem list diagnosis' do
      diagnoses = patient.problem_list(options)

      expect(diagnoses[0].date).to eq Date.new(2005, 06, 30)
      expect(diagnoses[0].icd9).to eq 'V72.3'
      expect(diagnoses[0].name).to eq 'Gynecological examination'
      expect(diagnoses[0].type).to eq 'Problem List'

      expect(diagnoses[1].date).to eq Date.new(2005, 06, 30)
      expect(diagnoses[1].icd9).to eq '714.0'
      expect(diagnoses[1].name).to eq 'Rheumatoid arthritis(714.0) (HCC)'
      expect(diagnoses[1].type).to eq 'Problem List'

      expect(diagnoses[24].date).to eq Date.new(2012, 3, 22)
      expect(diagnoses[24].icd9).to be_nil
      expect(diagnoses[24].name).to eq 'METHYLPREDNISOLONE'
      expect(diagnoses[24].type).to eq 'Immunization'
    end
  end

  describe '#providers' do
    let(:json) { File.read('spec/fixtures/provider.json') }

    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }

    let(:options) { { start_date: start_date, end_date: end_date } }

    before do
      stub_request(:get, /GetProvider.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' => end_date,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the patient providers' do
      providers = patient.providers(options)

      expect(providers[0].no_show_count).to eq 0
      expect(providers[0].visit_count).to be_nil
      expect(providers[0].last_visit_date).to be_nil
      expect(providers[0].id).to eq '1964'
      expect(providers[0].name).to eq 'BERGER MD, BRUCE E'
      expect(providers[0].role).to eq 'Nephrologist'
      expect(providers[0].type.id).to eq '1'
      expect(providers[0].type.name).to eq 'Physician'
      expect(providers[0].specialties[0].id).to eq '18'
      expect(providers[0].specialties[0].name).to eq 'Nephrology'

      expect(providers[1].no_show_count).to eq 0
      expect(providers[1].visit_count).to eq 12
      expect(providers[1].last_visit_date).to eq Date.new(2013, 10, 14)
      expect(providers[1].id).to eq '5437'
      expect(providers[1].name).to eq 'ZZTEST, MYCHART'
      expect(providers[1].role).to eq 'PCP - General'
      expect(providers[1].type.id).to eq '1'
      expect(providers[1].type.name).to eq 'Physician'
      expect(providers[1].specialties[0].id).to eq '17'
      expect(providers[1].specialties[0].name).to eq 'Internal Medicine'

      expect(providers[3].no_show_count).to eq 0
      expect(providers[3].visit_count).to eq 3
      expect(providers[3].last_visit_date).to eq Date.new(2013, 8, 1)
      expect(providers[3].id).to eq 'AMBMD'
      expect(providers[3].name).to eq 'AMBULATORY, PHYSICIAN'
      expect(providers[3].role).to be_nil
      expect(providers[3].type.id).to eq '1'
      expect(providers[3].type.name).to eq 'Physician'
      expect(providers[3].specialties[0].id).to eq '9'
      expect(providers[3].specialties[0].name).to eq 'Family Medicine'
      expect(providers[3].specialties[1].id).to eq '17'
      expect(providers[3].specialties[1].name).to eq 'Internal Medicine'
      expect(providers[3].specialties[2].id).to eq '22'
      expect(providers[3].specialties[2].name).to eq 'Obstetrics/Gynecology'
    end
  end

  describe '#vitals' do
    let(:json) { File.read('spec/fixtures/vitals.json') }
    let(:start_date) { '10/17/2011' }
    let(:end_date) { '10/17/2013' }
    let(:min_values) { '4' }

    let(:options) {
      { start_date: start_date, end_date: end_date, min_values: min_values }
    }

    before do
      stub_request(:get, /GetVitals.svc/)
        .with(
          headers: { 'Accept' => 'application/json' },
          query: {
            'ID' => id.to_s,
            'Type' => type,
            'Username' => username,
            'Password' => password,
            'StartDate' => start_date,
            'EndDate' =>  end_date,
            'minNumberOfValues' => min_values,
          },
        )
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: json,
        )
    end

    it 'returns the patient vitals' do
      vitals = patient.vitals(options)

      expect(vitals[0].name).to eq 'bmi'
      expect(vitals[0].readings[0].date).to eq Date.new(2013, 10, 2)

      expect(vitals[0].readings[0].value).to eq 33.114
      expect(vitals[0].readings[1].date).to eq Date.new(2013, 9, 30)
      expect(vitals[0].readings[1].value).to eq 60.165
      expect(vitals[0].readings[2].date).to eq Date.new(2013, 9, 27)
      expect(vitals[0].readings[2].value).to eq 39.937

      expect(vitals[2].name).to eq 'ht'
      expect(vitals[2].readings[0].date).to eq Date.new(2013, 11, 7)
      expect(vitals[2].readings[0].value).to eq 65

      expect(vitals[3].name).to eq 'diabp'
      expect(vitals[3].readings[0].date).to eq Date.new(2013, 10, 2)
      expect(vitals[3].readings[0].value).to eq 96
      expect(vitals[3].readings[1].date).to eq Date.new(2013, 9, 30)
      expect(vitals[3].readings[1].value).to eq 240
      expect(vitals[3].readings[2].date).to eq Date.new(2013, 9, 27)
      expect(vitals[3].readings[2].value).to eq 90

      expect(vitals[4].name).to eq 'sysbp'
      expect(vitals[4].readings[0].date).to eq Date.new(2013, 10, 2)
      expect(vitals[4].readings[0].value).to eq 139
      expect(vitals[4].readings[1].date).to eq Date.new(2013, 9, 30)
      expect(vitals[4].readings[1].value).to eq 240
      expect(vitals[4].readings[2].date).to eq Date.new(2013, 9, 27)
      expect(vitals[4].readings[2].value).to eq 141

      expect(vitals[1].name).to eq 'wt'
      expect(vitals[1].readings[0].date).to eq Date.new(2013, 10, 2)
      expect(vitals[1].readings[0].value).to eq 3184
      expect(vitals[1].readings[1].date).to eq Date.new(2013, 9, 30)
      expect(vitals[1].readings[1].value).to eq 5784.87
      expect(vitals[1].readings[2].date).to eq Date.new(2013, 9, 27)
      expect(vitals[1].readings[2].value).to eq 3840
    end
  end
end
