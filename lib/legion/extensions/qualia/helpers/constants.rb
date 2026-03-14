# frozen_string_literal: true

module Legion
  module Extensions
    module Qualia
      module Helpers
        module Constants
          MAX_EXPERIENCES = 500
          MAX_PALETTE_SIZE = 100

          # Phenomenal dimensions
          DEFAULT_VIVIDNESS = 0.5
          DEFAULT_VALENCE = 0.0
          DEFAULT_TEXTURE = 0.5
          VIVIDNESS_DECAY = 0.03
          VIVIDNESS_BOOST = 0.1

          # Thresholds
          VIVID_THRESHOLD = 0.7
          FAINT_THRESHOLD = 0.2
          INTENSE_THRESHOLD = 0.8

          PHENOMENAL_QUALITIES = %i[
            sharp smooth warm cool heavy light
            bright dark flowing rigid pulsing still
          ].freeze

          TEXTURE_TYPES = %i[
            crystalline fluid granular electric
            velvet metallic organic ethereal
          ].freeze

          MODALITIES = %i[
            visual auditory tactile gustatory
            olfactory kinesthetic emotional abstract
          ].freeze

          VIVIDNESS_LABELS = {
            (0.8..)     => :overwhelming,
            (0.6...0.8) => :vivid,
            (0.4...0.6) => :moderate,
            (0.2...0.4) => :faint,
            (..0.2)     => :ghost
          }.freeze

          VALENCE_LABELS = {
            (0.5..)       => :pleasant,
            (0.2...0.5)   => :mildly_pleasant,
            (-0.2...0.2)  => :neutral,
            (-0.5...-0.2) => :mildly_unpleasant,
            (..-0.5)      => :unpleasant
          }.freeze

          RICHNESS_LABELS = {
            (0.8..)     => :synesthetic,
            (0.6...0.8) => :rich,
            (0.4...0.6) => :moderate,
            (0.2...0.4) => :sparse,
            (..0.2)     => :flat
          }.freeze

          def self.label_for(labels, value)
            labels.each { |range, label| return label if range.cover?(value) }
            :unknown
          end
        end
      end
    end
  end
end
