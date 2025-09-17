# BUFFER 2 - GENERATIVE BASS (Corrected)

set :sendA_2, 0.69
set :sendB_2,  0.96
set :current_chord_notes, chord(:c4, :major)
set :pan_2, -0.5

with_fx :reverb, room: 0.8 do |rev|
  with_fx :hpf do |lp|
    live_loop :bass do
      use_bpm get(:master_bpm)
      
      # --- GENERATIVE SECTION ---
      current_section = get(:song_section)
      
      # --- GENERATIVE SECTION ---
      
      # Use an 'if' statement to change the pattern based on the section
      if current_section == :A
        rhythm_pattern = spread(rrand(4, 8), 16)
      elsif current_section == :B
        rhythm_pattern = spread(12, 16)
      elsif current_section == :C
        rhythm_pattern = spread(rrand(10, 13), 16)
      end
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
        control lp, cutoff: (get(:pan_2)+1.1)*60
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
              cutoff: rrand(get(:sendB_2) * 99, get(:sendB_2) * 130)
          end
        end
        
        sleep choose([0.25, 0.5, 0.5, 0.25])
      end
    end
  end
end