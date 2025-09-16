# BUFFER 1 - DRUMS

# BUFFER 1 - HAUNTING FUNKY DRUMS

# We wrap the loops in the FX blocks for efficiency.
with_fx :reverb, mix: 0.5, room: 0.6 do |rev|
  # --- The Main Slicer Loop ---
  live_loop :drums_slicer do
    use_bpm get(:master_bpm)
    # Use the master on/off switch for this part
    if get(:part_1_on)
      
      # --- DYNAMIC MIDI CONTROL ---
      # Remap SendB to control the Reverb mix, making it more atmospheric
      control rev, mix: 0.5, room: 0.5 # sendA_1 is now BPM
      
      # Play 8 slices over 2 beats to create a funky, syncopated rhythm
      8.times do
        s = rrand_i(1, 3)
        s2 = [1, 3, 5, 7,  9, 11, 13, 15].choose
        r = one_in(8) ? -0.6 : 0.6
        
        sample :loop_amen,
          beat_stretch: 2,
          num_slices: 16,
          slice: s2,
          amp: get(:amp_1)*rrand(2, 3),
          pan: get(:pan_1),
          rate: r * (get(:sendB_1)*3.2)+0.2
        
        human = rrand(-0.02, 0.02)
        slp = one_in(4) ? 1 : 0.5
        sleep slp  + human
      end
      
    else
      sleep 2
    end
    
    
  end
end
