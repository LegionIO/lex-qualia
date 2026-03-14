# frozen_string_literal: true

RSpec.describe Legion::Extensions::Qualia::Helpers::QualiaEngine do
  subject(:engine) { described_class.new }

  describe '#create_quale' do
    it 'creates and stores a quale' do
      quale = engine.create_quale(content: 'sharpness of insight')
      expect(quale.content).to eq('sharpness of insight')
    end
  end

  describe '#intensify' do
    it 'increases vividness' do
      quale = engine.create_quale(content: 'test')
      original = quale.vividness
      engine.intensify(quale_id: quale.id)
      expect(quale.vividness).to be > original
    end

    it 'returns nil for unknown quale' do
      expect(engine.intensify(quale_id: 'bad')).to be_nil
    end
  end

  describe '#fade_all!' do
    it 'fades all qualia' do
      quale = engine.create_quale(content: 'test')
      original = quale.vividness
      engine.fade_all!
      expect(quale.vividness).to be < original
    end
  end

  describe '#vivid_experiences' do
    it 'returns vivid qualia' do
      engine.create_quale(content: 'vivid', vividness: 0.8)
      engine.create_quale(content: 'faint', vividness: 0.2)
      expect(engine.vivid_experiences.size).to eq(1)
    end
  end

  describe '#faint_experiences' do
    it 'returns faint qualia' do
      engine.create_quale(content: 'faint', vividness: 0.1)
      expect(engine.faint_experiences.size).to eq(1)
    end
  end

  describe '#by_modality' do
    it 'filters by modality' do
      engine.create_quale(content: 'a', modality: :visual)
      engine.create_quale(content: 'b', modality: :auditory)
      expect(engine.by_modality(modality: :visual).size).to eq(1)
    end
  end

  describe '#by_quality' do
    it 'filters by quality' do
      engine.create_quale(content: 'a', quality: :sharp)
      engine.create_quale(content: 'b', quality: :warm)
      expect(engine.by_quality(quality: :sharp).size).to eq(1)
    end
  end

  describe '#by_texture' do
    it 'filters by texture' do
      engine.create_quale(content: 'a', texture: :metallic)
      engine.create_quale(content: 'b', texture: :velvet)
      expect(engine.by_texture(texture: :metallic).size).to eq(1)
    end
  end

  describe '#pleasant_experiences' do
    it 'returns pleasant qualia' do
      engine.create_quale(content: 'nice', valence: 0.5)
      engine.create_quale(content: 'bad', valence: -0.5)
      expect(engine.pleasant_experiences.size).to eq(1)
    end
  end

  describe '#unpleasant_experiences' do
    it 'returns unpleasant qualia' do
      engine.create_quale(content: 'bad', valence: -0.5)
      expect(engine.unpleasant_experiences.size).to eq(1)
    end
  end

  describe '#most_vivid' do
    it 'returns sorted by vividness descending' do
      engine.create_quale(content: 'dim', vividness: 0.3)
      bright = engine.create_quale(content: 'bright', vividness: 0.9)
      expect(engine.most_vivid(limit: 1).first.id).to eq(bright.id)
    end
  end

  describe '#average_vividness' do
    it 'returns 0.0 with no qualia' do
      expect(engine.average_vividness).to eq(0.0)
    end

    it 'computes average' do
      engine.create_quale(content: 'a', vividness: 0.4)
      engine.create_quale(content: 'b', vividness: 0.6)
      expect(engine.average_vividness).to eq(0.5)
    end
  end

  describe '#average_valence' do
    it 'returns 0.0 with no qualia' do
      expect(engine.average_valence).to eq(0.0)
    end
  end

  describe '#phenomenal_richness' do
    it 'returns 0.0 with no qualia' do
      expect(engine.phenomenal_richness).to eq(0.0)
    end

    it 'returns positive with qualia' do
      engine.create_quale(content: 'test', vividness: 0.8)
      expect(engine.phenomenal_richness).to be > 0.0
    end
  end

  describe '#modality_distribution' do
    it 'returns counts per modality' do
      engine.create_quale(content: 'a', modality: :visual)
      dist = engine.modality_distribution
      expect(dist[:visual]).to eq(1)
      expect(dist[:auditory]).to eq(0)
    end
  end

  describe '#experiential_diversity' do
    it 'returns 0.0 with no qualia' do
      expect(engine.experiential_diversity).to eq(0.0)
    end

    it 'increases with diverse modalities' do
      engine.create_quale(content: 'a', modality: :visual)
      engine.create_quale(content: 'b', modality: :auditory)
      expect(engine.experiential_diversity).to be > 0.0
    end
  end

  describe '#quality_palette' do
    it 'returns quality frequencies' do
      engine.create_quale(content: 'a', quality: :sharp)
      engine.create_quale(content: 'b', quality: :sharp)
      palette = engine.quality_palette
      expect(palette[:sharp]).to eq(2)
    end
  end

  describe '#qualia_report' do
    it 'includes all report fields' do
      report = engine.qualia_report
      expect(report).to include(
        :total_experiences, :vivid_count, :faint_count,
        :pleasant_count, :unpleasant_count, :average_vividness,
        :average_valence, :phenomenal_richness, :experiential_diversity,
        :richness_label, :most_vivid
      )
    end
  end

  describe '#to_h' do
    it 'includes summary fields' do
      hash = engine.to_h
      expect(hash).to include(:total_experiences, :vivid, :avg_vividness, :avg_valence, :richness)
    end
  end
end
