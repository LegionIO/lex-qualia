# lex-qualia

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-qualia`
- **Version**: 0.1.0
- **Namespace**: `Legion::Extensions::Qualia`

## Purpose

Phenomenal experience registry. Represents the subjective "what it is like" quality of the agent's processing. Each quale is defined by modality, quality, texture, vividness, and valence. Vividness decays; intense experiences are retained longer. Provides phenomenal richness scoring, experiential diversity, and qualitative classification of the agent's experience palette.

## Gem Info

- **Homepage**: https://github.com/LegionIO/lex-qualia
- **License**: MIT
- **Ruby**: >= 3.4

## File Structure

```
lib/legion/extensions/qualia/
  version.rb
  client.rb
  helpers/
    constants.rb       # MODALITIES, PHENOMENAL_QUALITIES, TEXTURE_TYPES, thresholds, labels
    quale.rb           # Quale class — single phenomenal experience
    qualia_engine.rb   # QualiaEngine — experience registry and analysis
  runners/
    qualia.rb          # Runner module
spec/
  helpers/quale_spec.rb
  helpers/qualia_engine_spec.rb
  runners/qualia_spec.rb (runners_spec.rb)
  client_spec.rb
```

## Key Constants

From `Helpers::Constants`:
- `MAX_EXPERIENCES = 500`, `MAX_PALETTE_SIZE = 100`
- `DEFAULT_VIVIDNESS = 0.5`, `DEFAULT_VALENCE = 0.0`, `DEFAULT_TEXTURE = 0.5`
- `VIVIDNESS_DECAY = 0.03`, `VIVIDNESS_BOOST = 0.1`
- `VIVID_THRESHOLD = 0.7`, `FAINT_THRESHOLD = 0.2`, `INTENSE_THRESHOLD = 0.8`
- `MODALITIES = %i[visual auditory tactile gustatory olfactory kinesthetic emotional abstract]`
- `PHENOMENAL_QUALITIES = %i[sharp smooth warm cool heavy light bright dark flowing rigid pulsing still]`
- `TEXTURE_TYPES = %i[crystalline fluid granular electric velvet metallic organic ethereal]`
- `VIVIDNESS_LABELS`: `:overwhelming` (0.8+), `:vivid`, `:moderate`, `:faint`, `:ghost`
- `VALENCE_LABELS`: `:pleasant` (>= 0.5), `:mildly_pleasant`, `:neutral`, `:mildly_unpleasant`, `:unpleasant`
- `RICHNESS_LABELS`: `:synesthetic` (0.8+), `:rich`, `:moderate`, `:sparse`, `:flat`
- `Constants.label_for(labels_hash, value)` module-level lookup method

## Runners

| Method | Key Parameters | Returns |
|---|---|---|
| `create_quale` | `content:`, `modality:`, `quality:`, `texture:`, `vividness:`, `valence:` | `{ success:, quale: }` |
| `intensify_quale` | `quale_id:`, `amount:` | `{ success:, quale: }` |
| `fade_all` | — | `{ success:, remaining: }` (decay + prune faint) |
| `vivid_experiences` | — | `{ success:, count:, qualia: }` |
| `by_modality` | `modality:` | `{ success:, count:, qualia: }` |
| `phenomenal_richness` | — | `{ success:, richness:, label: }` |
| `qualia_status` | — | full report: totals, vivid/faint/pleasant/unpleasant counts, avg vividness/valence, richness, most vivid |

## Helpers

### `Helpers::Quale`
Single experience: `id`, `content`, `modality`, `quality`, `texture`, `vividness` (clamped 0–1), `valence` (clamped -1–1). `vivid?` = vividness >= 0.7. `faint?` = vividness <= 0.2. `intense?` = vividness >= 0.8. `pleasant?` = valence > 0.2. `unpleasant?` = valence < -0.2. `intensify!(amount:)` adds to vividness. `fade!` subtracts `VIVIDNESS_DECAY`. `phenomenal_richness` = vividness*0.5 + quality_bonus + texture_bonus.

### `Helpers::QualiaEngine`
Manages `@experiences` hash. `create_quale` prunes faint/weakest when at `MAX_EXPERIENCES`. `intensify(quale_id:, amount:)` delegates to quale. `fade_all!` decays all and prunes faint. `vivid_experiences`, `faint_experiences`, `intense_experiences`, `pleasant_experiences`, `unpleasant_experiences` filter by thresholds. `most_vivid(limit:)` sorts by vividness desc. `average_vividness`, `average_valence` mean over all. `phenomenal_richness` mean richness score. `modality_distribution` counts per modality. `quality_palette`, `texture_palette` tally by attribute. `experiential_diversity` = unique modalities / total modalities.

## Integration Points

- `create_quale` can accept perceptual binding output from `lex-phenomenal-binding`
- Quale `valence` feeds `lex-emotion` as a secondary affective signal
- `phenomenal_richness` can feed `lex-narrator` for prose richness modulation
- `vivid_experiences` with negative valence feed `lex-cognitive-reappraisal` as reappraisal candidates
- `fade_all` called each tick for natural experience fading

## Development Notes

- `phenomenal_richness` per quale = vividness*0.5 + quality_bonus + texture_bonus (texture/quality diversity bonuses)
- Prune on capacity: first removes entries with vividness <= 0, then removes weakest if still over capacity
- `qualia_status` uses `QualiaEngine#qualia_report` which calls `Constants.label_for` for richness label
- `experiential_diversity` = unique modalities used / `MODALITIES.size`
- All state is in-memory; reset on process restart
