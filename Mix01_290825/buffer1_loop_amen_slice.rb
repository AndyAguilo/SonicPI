# BUFFER 1 - DRUMS

# BUFFER 1 - HAUNTING FUNKY DRUMS

# We wrap the loops in the FX blocks for efficiency.
with_fx :reverb, mix: 0.5, room: 0.6 do |rev|
  # --- The Main Slicer Loop ---
  live_loop :drums_slicer do
    # Use the master on/off switch for this part
    if get(:part_1_on)
      
      # --- DYNAMIC MIDI CONTROL ---
      # Remap SendB to control the Reverb mix, making it more atmospheric
      control rev, mix: get(:sendB_1), room: get(:sendA_1)
      
      # Play 8 slices over 2 beats to create a funky, syncopated rhythm
      8.times do
        # The 'slice' option picks one of 16 chunks of the Amen break
        # We use one_in() to add random, glitchy events.
        s = rrand_i(0, 15)
        
        # 1 time in 8, play a slice backwards for a spooky feel
        r = one_in(8) ? -0.6 : 0.6
        
        sample :loop_amen,
          beat_stretch: 2,
          num_slices: 16,
          slice: s,
          amp: get(:amp_1)*rrand(2, 4),
          pan: get(:pan_1),
          rate: r * get(:sendA_2)# Play it forwards (1) or backwards (-1)
        human = rrand(-0.02, 0.02)
        s = one_in(6) ? 4 : 1
        sleep s*(get(:sendA_2) + 0.01) + human # The time between each slice
      end
      
    else
      sleep 2
    end
    
    
    
    
    
  end
end
