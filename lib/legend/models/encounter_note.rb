require 'legend/model'

module Legend
  module Models
    class EncounterNote < Model
      attribute :encounter_note, String
      attribute :encounter_note_date, String
      attribute :encounter_note_format, String

      attribute :encounter_note_type, String
      attribute :encounter_note_author, String
      attribute :provider_id, String
      attribute :provider_role, String
      attribute :encounter_note_entry_date, String
      attribute :encounter_note_entry_time, String
      attribute :visit_date, String
    end
  end
end
