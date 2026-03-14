# frozen_string_literal: true

module Legion
  module Extensions
    module Qualia
      module Helpers
        class QualiaEngine
          include Constants

          def initialize
            @experiences = {}
          end

          def create_quale(content:, modality: :abstract, quality: :smooth, texture: :fluid,
                           vividness: DEFAULT_VIVIDNESS, valence: DEFAULT_VALENCE)
            prune_faint
            quale = Quale.new(content: content, modality: modality, quality: quality,
                              texture: texture, vividness: vividness, valence: valence)
            @experiences[quale.id] = quale
            quale
          end

          def intensify(quale_id:, amount: VIVIDNESS_BOOST)
            quale = @experiences[quale_id]
            return nil unless quale

            quale.intensify!(amount: amount)
            quale
          end

          def fade_all!
            @experiences.each_value(&:fade!)
            prune_faint
            { remaining: @experiences.size }
          end

          def vivid_experiences = @experiences.values.select(&:vivid?)
          def faint_experiences = @experiences.values.select(&:faint?)
          def intense_experiences = @experiences.values.select(&:intense?)

          def by_modality(modality:)
            @experiences.values.select { |q| q.modality == modality.to_sym }
          end

          def by_quality(quality:)
            @experiences.values.select { |q| q.quality == quality.to_sym }
          end

          def by_texture(texture:)
            @experiences.values.select { |q| q.texture == texture.to_sym }
          end

          def pleasant_experiences = @experiences.values.select(&:pleasant?)
          def unpleasant_experiences = @experiences.values.select(&:unpleasant?)

          def most_vivid(limit: 5) = @experiences.values.sort_by { |q| -q.vividness }.first(limit)

          def average_vividness
            return 0.0 if @experiences.empty?

            (@experiences.values.sum(&:vividness) / @experiences.size).round(10)
          end

          def average_valence
            return 0.0 if @experiences.empty?

            (@experiences.values.sum(&:valence) / @experiences.size).round(10)
          end

          def phenomenal_richness
            return 0.0 if @experiences.empty?

            (@experiences.values.sum(&:phenomenal_richness) / @experiences.size).round(10)
          end

          def modality_distribution
            MODALITIES.to_h do |mod|
              [mod, @experiences.values.count { |q| q.modality == mod }]
            end
          end

          def quality_palette
            @experiences.values.map(&:quality).tally.sort_by { |_, v| -v }.to_h
          end

          def texture_palette
            @experiences.values.map(&:texture).tally.sort_by { |_, v| -v }.to_h
          end

          def experiential_diversity
            return 0.0 if @experiences.empty?

            modalities_used = @experiences.values.map(&:modality).uniq.size
            (modalities_used.to_f / MODALITIES.size).clamp(0.0, 1.0).round(10)
          end

          def qualia_report
            {
              total_experiences:      @experiences.size,
              vivid_count:            vivid_experiences.size,
              faint_count:            faint_experiences.size,
              pleasant_count:         pleasant_experiences.size,
              unpleasant_count:       unpleasant_experiences.size,
              average_vividness:      average_vividness,
              average_valence:        average_valence,
              phenomenal_richness:    phenomenal_richness,
              experiential_diversity: experiential_diversity,
              richness_label:         Constants.label_for(RICHNESS_LABELS, phenomenal_richness),
              most_vivid:             most_vivid(limit: 3).map(&:to_h)
            }
          end

          def to_h
            {
              total_experiences: @experiences.size,
              vivid:             vivid_experiences.size,
              avg_vividness:     average_vividness,
              avg_valence:       average_valence,
              richness:          phenomenal_richness
            }
          end

          private

          def prune_faint
            return if @experiences.size < MAX_EXPERIENCES

            @experiences.reject! { |_, q| q.vividness <= 0.0 }
            return unless @experiences.size >= MAX_EXPERIENCES

            weakest = @experiences.values.min_by(&:vividness)
            @experiences.delete(weakest.id) if weakest
          end
        end
      end
    end
  end
end
