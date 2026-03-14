# frozen_string_literal: true

RSpec.describe Legion::Extensions::Qualia::Helpers::Quale do
  subject(:quale) { described_class.new(content: 'warmth of recognition') }

  describe '#initialize' do
    it 'assigns a UUID id' do
      expect(quale.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'stores content' do
      expect(quale.content).to eq('warmth of recognition')
    end

    it 'defaults modality to :abstract' do
      expect(quale.modality).to eq(:abstract)
    end

    it 'defaults quality to :smooth' do
      expect(quale.quality).to eq(:smooth)
    end

    it 'defaults texture to :fluid' do
      expect(quale.texture).to eq(:fluid)
    end

    it 'defaults vividness' do
      expect(quale.vividness).to eq(0.5)
    end

    it 'defaults valence to 0.0' do
      expect(quale.valence).to eq(0.0)
    end

    it 'clamps vividness' do
      high = described_class.new(content: 'x', vividness: 5.0)
      expect(high.vividness).to eq(1.0)
    end

    it 'clamps valence' do
      extreme = described_class.new(content: 'x', valence: -5.0)
      expect(extreme.valence).to eq(-1.0)
    end

    it 'validates modality' do
      bad = described_class.new(content: 'x', modality: :nonexistent)
      expect(bad.modality).to eq(:abstract)
    end

    it 'validates quality' do
      bad = described_class.new(content: 'x', quality: :nonexistent)
      expect(bad.quality).to eq(:smooth)
    end

    it 'validates texture' do
      bad = described_class.new(content: 'x', texture: :nonexistent)
      expect(bad.texture).to eq(:fluid)
    end
  end

  describe '#intensify!' do
    it 'increases vividness' do
      original = quale.vividness
      quale.intensify!
      expect(quale.vividness).to be > original
    end

    it 'clamps at 1.0' do
      20.times { quale.intensify! }
      expect(quale.vividness).to eq(1.0)
    end
  end

  describe '#fade!' do
    it 'decreases vividness' do
      original = quale.vividness
      quale.fade!
      expect(quale.vividness).to be < original
    end

    it 'clamps at 0.0' do
      50.times { quale.fade! }
      expect(quale.vividness).to eq(0.0)
    end
  end

  describe '#vivid?' do
    it 'is false at default vividness' do
      expect(quale.vivid?).to be false
    end

    it 'is true when vivid' do
      vivid = described_class.new(content: 'x', vividness: 0.8)
      expect(vivid.vivid?).to be true
    end
  end

  describe '#faint?' do
    it 'is false at default vividness' do
      expect(quale.faint?).to be false
    end

    it 'is true when faint' do
      faint = described_class.new(content: 'x', vividness: 0.1)
      expect(faint.faint?).to be true
    end
  end

  describe '#intense?' do
    it 'is true when very vivid' do
      intense = described_class.new(content: 'x', vividness: 0.9)
      expect(intense.intense?).to be true
    end
  end

  describe '#pleasant?' do
    it 'is true for positive valence' do
      pleasant = described_class.new(content: 'x', valence: 0.5)
      expect(pleasant.pleasant?).to be true
    end

    it 'is false for negative valence' do
      expect(quale.pleasant?).to be false
    end
  end

  describe '#unpleasant?' do
    it 'is true for negative valence' do
      unpleasant = described_class.new(content: 'x', valence: -0.5)
      expect(unpleasant.unpleasant?).to be true
    end
  end

  describe '#neutral_valence?' do
    it 'is true at default valence' do
      expect(quale.neutral_valence?).to be true
    end
  end

  describe '#phenomenal_richness' do
    it 'returns a value between 0 and 1' do
      expect(quale.phenomenal_richness).to be_between(0.0, 1.0)
    end
  end

  describe '#persistence' do
    it 'is 1.0 initially' do
      expect(quale.persistence).to eq(1.0)
    end

    it 'decreases after fading' do
      quale.fade!
      expect(quale.persistence).to be < 1.0
    end
  end

  describe '#to_h' do
    it 'includes all fields' do
      hash = quale.to_h
      expect(hash).to include(
        :id, :content, :modality, :quality, :texture, :vividness,
        :original_vividness, :valence, :phenomenal_richness,
        :vivid, :faint, :intense, :vividness_label, :valence_label,
        :persistence, :created_at
      )
    end
  end
end
