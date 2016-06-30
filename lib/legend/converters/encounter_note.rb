require 'legend/converter'
require 'legend/models/encounter_note'

module Legend
  module Converters
    class EncounterNote < Converter
      URL = %r(/GetEncounterNote\.svc/rest/)

      def to_object
        enc_note_date.collect.with_index do |enc_date,index|
        Models::EncounterNote.new(
          encounter_note: data.Note(index),
          encounter_note_date: enc_date,
          encounter_note_format: data.encNoteFormat[index],
          encounter_note_type: data.encNoteTy[index],
          encounter_note_author: data.noteAuthor[index],
          provider_id: data.provID[index],
          provider_role: data.provRole[index],
          encounter_note_entry_date: data.encNoteEntryDate[index],
          encounter_note_entry_time: data.encNoteEntryTime[index],
          visit_date: data.visitDate[index]
        )

      end

       
      end
      
      def enc_note_date
          data.encNoteDate
      end
      
      def build_encounter_note index
          data.Note.each do |note|
           note.encNote[index]
       end
      end
    end
  end
end
