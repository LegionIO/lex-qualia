# frozen_string_literal: true

RSpec.describe Legion::Extensions::Qualia::Runners::Qualia do
  let(:engine) { Legion::Extensions::Qualia::Helpers::QualiaEngine.new }
  let(:runner) do
    obj = Object.new
    obj.extend(described_class)
    obj.instance_variable_set(:@default_engine, engine)
    obj
  end

  describe '#create_quale' do
    it 'returns success with quale hash' do
      result = runner.create_quale(content: 'test', engine: engine)
      expect(result[:success]).to be true
      expect(result[:quale][:content]).to eq('test')
    end
  end

  describe '#intensify_quale' do
    it 'returns success for known quale' do
      quale = engine.create_quale(content: 'test')
      result = runner.intensify_quale(quale_id: quale.id, engine: engine)
      expect(result[:success]).to be true
    end

    it 'returns failure for unknown quale' do
      result = runner.intensify_quale(quale_id: 'bad', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '#fade_all' do
    it 'returns success' do
      result = runner.fade_all(engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#vivid_experiences' do
    it 'returns vivid list' do
      engine.create_quale(content: 'vivid', vividness: 0.8)
      result = runner.vivid_experiences(engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#by_modality' do
    it 'filters by modality' do
      engine.create_quale(content: 'a', modality: :visual)
      result = runner.by_modality(modality: :visual, engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#phenomenal_richness' do
    it 'returns richness level' do
      result = runner.phenomenal_richness(engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#qualia_status' do
    it 'returns comprehensive status' do
      result = runner.qualia_status(engine: engine)
      expect(result[:success]).to be true
      expect(result).to include(:total_experiences, :phenomenal_richness)
    end
  end
end
