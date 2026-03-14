# lex-qualia

Phenomenal experience registry for the LegionIO cognitive architecture. Represents and tracks the qualitative character of the agent's cognitive experiences.

## What It Does

Maintains a registry of qualia — the "what it is like" quality of experiences. Each quale is described by its sensory modality, phenomenal quality, texture, vividness, and emotional valence. Vividness decays naturally, with more intense experiences lasting longer. Provides richness scoring across the experience space and qualitative analysis of the agent's current phenomenal palette.

## Usage

```ruby
client = Legion::Extensions::Qualia::Client.new

# Register a phenomenal experience
q = client.create_quale(
  content:   'processing a novel algorithm',
  modality:  :abstract,
  quality:   :sharp,
  texture:   :crystalline,
  vividness: 0.8,
  valence:   0.3
)
quale_id = q[:quale][:id]

# Intensify with attention
client.intensify_quale(quale_id: quale_id, amount: 0.1)

# Query current experiences
client.vivid_experiences
client.by_modality(modality: :abstract)

# Phenomenal richness (diversity and vividness score)
client.phenomenal_richness
# => { success: true, richness: 0.42, label: :moderate }

# Full status report
client.qualia_status
# => { success: true, total_experiences: 1, vivid_count: 1, faint_count: 0,
#      average_vividness: 0.9, phenomenal_richness: 0.42, richness_label: :moderate,
#      most_vivid: [...] }

# Periodic fade (vividness decays)
client.fade_all
```

## Modalities

`:visual`, `:auditory`, `:tactile`, `:gustatory`, `:olfactory`, `:kinesthetic`, `:emotional`, `:abstract`

## Richness Labels

`:synesthetic` (>= 0.8), `:rich`, `:moderate`, `:sparse`, `:flat`

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
