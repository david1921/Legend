require 'legend/models/encounter_note'
require 'legend/simulator'

module Legend
  module Simulators
    class EncounterNote < Simulator
      def initialize
        super(Models::EncounterNote) do
        encounter_note {Fake.enc_note}
        encounter_note_date { Fake.date }
        encounter_note_format {Fake.enc_note_format}
        encounter_note_type {Fake.enc_note_type}
        encounter_note_author{Fake.name}
        provider_id {Fake.id}
        provider_role {Fake.prov_role}
        encounter_note_entry_date {Fake.date}
        encounter_note_entry_time {Fake.number}
        visit_date {Fake.date}
        
        end
      end
    end
  end
end
