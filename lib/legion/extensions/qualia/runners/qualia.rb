# frozen_string_literal: true

module Legion
  module Extensions
    module Qualia
      module Runners
        module Qualia
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def create_quale(content:, modality: :abstract, quality: :smooth, texture: :fluid, vividness: nil,
                           valence: nil, engine: nil, **)
            eng = engine || @default_engine
            quale = eng.create_quale(content: content, modality: modality, quality: quality,
                                     texture: texture,
                                     vividness: vividness || Helpers::Constants::DEFAULT_VIVIDNESS,
                                     valence: valence || Helpers::Constants::DEFAULT_VALENCE)
            { success: true, quale: quale.to_h }
          end

          def intensify_quale(quale_id:, amount: nil, engine: nil, **)
            eng = engine || @default_engine
            quale = eng.intensify(quale_id: quale_id,
                                  amount:   amount || Helpers::Constants::VIVIDNESS_BOOST)
            return { success: false, error: 'quale not found' } unless quale

            { success: true, quale: quale.to_h }
          end

          def fade_all(engine: nil, **)
            eng = engine || @default_engine
            result = eng.fade_all!
            { success: true, **result }
          end

          def vivid_experiences(engine: nil, **)
            eng = engine || @default_engine
            qualia = eng.vivid_experiences
            { success: true, count: qualia.size, qualia: qualia.map(&:to_h) }
          end

          def by_modality(modality:, engine: nil, **)
            eng = engine || @default_engine
            qualia = eng.by_modality(modality: modality)
            { success: true, count: qualia.size, qualia: qualia.map(&:to_h) }
          end

          def phenomenal_richness(engine: nil, **)
            eng = engine || @default_engine
            richness = eng.phenomenal_richness
            label = Helpers::Constants.label_for(Helpers::Constants::RICHNESS_LABELS, richness)
            { success: true, richness: richness, label: label }
          end

          def qualia_status(engine: nil, **)
            eng = engine || @default_engine
            report = eng.qualia_report
            { success: true, **report }
          end
        end
      end
    end
  end
end
