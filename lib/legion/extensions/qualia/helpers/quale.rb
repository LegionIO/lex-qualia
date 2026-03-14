# frozen_string_literal: true

require 'securerandom'

module Legion
  module Extensions
    module Qualia
      module Helpers
        class Quale
          include Constants

          attr_reader :id, :content, :modality, :quality, :texture,
                      :valence, :original_vividness, :created_at
          attr_accessor :vividness

          def initialize(content:, modality: :abstract, quality: :smooth, texture: :fluid, vividness: DEFAULT_VIVIDNESS, valence: DEFAULT_VALENCE)
            @id = SecureRandom.uuid
            @content = content.to_s
            @modality = valid_modality(modality)
            @quality = valid_quality(quality)
            @texture = valid_texture(texture)
            @vividness = vividness.to_f.clamp(0.0, 1.0).round(10)
            @original_vividness = @vividness
            @valence = valence.to_f.clamp(-1.0, 1.0).round(10)
            @created_at = Time.now
          end

          def intensify!(amount: VIVIDNESS_BOOST)
            @vividness = (@vividness + amount).clamp(0.0, 1.0).round(10)
            self
          end

          def fade!
            @vividness = (@vividness - VIVIDNESS_DECAY).clamp(0.0, 1.0).round(10)
            self
          end

          def vivid? = @vividness >= VIVID_THRESHOLD
          def faint? = @vividness <= FAINT_THRESHOLD
          def intense? = @vividness >= INTENSE_THRESHOLD
          def pleasant? = @valence > 0.2
          def unpleasant? = @valence < -0.2
          def neutral_valence? = @valence.abs <= 0.2

          def phenomenal_richness
            base = @vividness * 0.5
            quality_bonus = PHENOMENAL_QUALITIES.index(@quality).to_f / PHENOMENAL_QUALITIES.size * 0.25
            texture_bonus = TEXTURE_TYPES.index(@texture).to_f / TEXTURE_TYPES.size * 0.25
            (base + quality_bonus + texture_bonus).clamp(0.0, 1.0).round(10)
          end

          def persistence = (@vividness / [@original_vividness, 0.01].max).clamp(0.0, 1.0).round(10)
          def vividness_label = Constants.label_for(VIVIDNESS_LABELS, @vividness)
          def valence_label = Constants.label_for(VALENCE_LABELS, @valence)
          def richness_label = Constants.label_for(RICHNESS_LABELS, phenomenal_richness)

          def to_h
            {
              id:                  @id,
              content:             @content,
              modality:            @modality,
              quality:             @quality,
              texture:             @texture,
              vividness:           @vividness,
              original_vividness:  @original_vividness,
              valence:             @valence,
              phenomenal_richness: phenomenal_richness,
              vivid:               vivid?,
              faint:               faint?,
              intense:             intense?,
              vividness_label:     vividness_label,
              valence_label:       valence_label,
              persistence:         persistence,
              created_at:          @created_at.iso8601
            }
          end

          private

          def valid_modality(mod)
            sym = mod.to_sym
            MODALITIES.include?(sym) ? sym : :abstract
          end

          def valid_quality(qual)
            sym = qual.to_sym
            PHENOMENAL_QUALITIES.include?(sym) ? sym : :smooth
          end

          def valid_texture(tex)
            sym = tex.to_sym
            TEXTURE_TYPES.include?(sym) ? sym : :fluid
          end
        end
      end
    end
  end
end
