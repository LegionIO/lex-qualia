# frozen_string_literal: true

RSpec.describe Legion::Extensions::Qualia::Client do
  subject(:client) { described_class.new }

  it 'responds to runner methods' do
    expect(client).to respond_to(:create_quale, :fade_all, :qualia_status)
  end

  it 'runs a full qualia lifecycle' do
    result = client.create_quale(content: 'sharp insight', modality: :emotional,
                                 quality: :sharp, texture: :crystalline, vividness: 0.8)
    quale_id = result[:quale][:id]

    client.intensify_quale(quale_id: quale_id)
    client.fade_all

    status = client.qualia_status
    expect(status[:total_experiences]).to eq(1)
  end
end
