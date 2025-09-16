# BUFFER 2 - GENERATIVE BASS (Corrected)

set :sendA_2, 0.69
set :sendB_2,  0.96
set :current_chord_notes, chord(:c4, :major)

with_fx :reverb, room: 0.8 do |rev|
  live_loop :bass do
    use_bpm get(:master_bpm)
    
    # --- GENERATIVE SECTION ---
    rhythm_pattern = spread(rrand_i(3, 7), 16)
    current_notes = get(:current_chord_notes)
    
    # --- FIX IS HERE: Generate a new NOTE pattern for this bar ---
    temp_list = [] # Start with an empty, normal list (Array)
    16.times do |i|
      if i == 0
        temp_list.push(current_notes.first) # Use .push on the normal list
      else
        temp_list.push(current_notes.choose)
      end
    end
    # Now, convert the final list into a ring for .tick to use
    note_pattern = temp_list.ring
    
    
    # --- SEQUENCER SECTION (This part remains the same) ---
    16.times do
      control rev, mix: get(:sendA_2)
      step = tick
      
      if get(:part_2_on)
        if rhythm_pattern[step]
          note_to_play = note_pattern[step]
          octave_jump = one_in(6) ? 12 : 0
          
          use_synth :fm
          play note_to_play - 12 + octave_jump,
            attack: 0.01,
            release: 0.4,
            amp: 4 * get(:amp_2),
            pan: get(:pan_2),
            cutoff: rrand(get(:sendB_2) * 99, get(:sendB_2) * 130)
        end
      end
      
      sleep 0.25
    end
  end
end
