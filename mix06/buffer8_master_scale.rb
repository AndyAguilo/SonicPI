# --- The Chord Progression "DNA" (Unchanged) ---
prog_notes = scale(:c3, :major)
chord_pattern = [:major7, :minor7, :minor7, :major7, :dom7, :minor7, :m7b5]
# The palette of notes for C Minor
#prog_notes = scale(:c3, :minor) # => (ring :c4, :d4, :eb4, :f4, :g4, :ab4, :bb4)
#chord_pattern = [:minor7, :m7b5, :major7, :minor7, :minor7, :major7, :dom7]
# The palette of notes for C Minor
#prog_notes = scale(:c3, :minor) # => (ring :c4, :d4, :eb4, :f4, :g4, :ab4, :bb4)
#chord_pattern = [:minor, :diminished, :major, :minor, :minor, :major, :major]
set :shuffled_indices, (range 0, 6).shuffle
set :sendB_8,  0.96


with_fx :reverb do |c|
  live_loop :jazzy_shuffled_progression do
    use_bpm get(:master_bpm)
    
    # === GENERATOR SECTION ===
    current_idx = get(:shuffled_indices).tick(:deck)
    if tick(:deck) % 7 == 0
      set :shuffled_indices, (range 0, 6).shuffle
      puts "--- Reshuffling the progression ---"
    end
    root = prog_notes[current_idx]
    type = chord_pattern[current_idx]
    notes_to_play = chord(root, type)
    set :current_chord_notes, notes_to_play
    
    current_section = get(:song_section)
    
    if current_section == :A
      rhythm_pattern = spread(rrand_i(2, 4), 64)
    elsif current_section == :B
      rhythm_pattern = spread(rrand_i(32, 48), 64)
    elsif current_section == :C
      rhythm_pattern = spread(rrand_i(24, 36), 64)
    end
    
    
    # === SEQUENCER SECTION ===
    64.times do
      step = tick(:seq)
      control c, room: 0.6, mix: get(:sendA_8)
      
      if get(:part_8_on)
        if rhythm_pattern[step]
          
          # --- THE FIX: Calculate the sustain value BEFORE the synth call ---
          sustain_val = 0.2 # Start with a default
          if current_section == :A
            sustain_val = rrand(2.3, 5.6)
          elsif current_section == :B
            sustain_val = rrand(0.1, 0.3)
          elsif current_section == :C # Corrected from :B to :C
            sustain_val = rrand(0, 0.2)
          end
          
          # --- Play the main chord synth ---
          # Now we can use our clean, pre-calculated variable
          synth :fm, note: notes_to_play,
            cutoff: rrand(get(:sendB_8) * 75, get(:sendB_8) * 130),
            attack: rrand(0.7, 1.7),
            sustain: sustain_val,
            release: 0.2,
            amp: get(:amp_8)
          
          # --- Play the bass note synth ---
          # This logic is now separate for clarity
          if current_section == :A
            synth :fm, note: root - 12, release: 0.5, amp: get(:amp_8) * 0.4
          elsif current_section == :B
            synth :fm, note: root, release: 0.3, amp: get(:amp_8) * 0.8
          elsif current_section == :C
            synth :fm, note: root + 12, release: 0.5, amp: get(:amp_8) * 0.8
          end
          
        end
      end
      
      
      sleep 0.25
    end
  end
end