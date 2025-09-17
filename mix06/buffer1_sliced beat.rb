# BUFFER 1 - DRUMS

# BUFFER 1 - HAUNTING FUNKY DRUMS

# We wrap the loops in the FX blocks for efficiency.
with_fx :reverb, mix: 0.5, room: 0.6 do |rev|
  # --- The Main Slicer Loop ---
  live_loop :drums_slicer do
    current_section = get(:song_section)
    
    
    use_bpm get(:master_bpm)
    
    # Use the master on/off switch for this part
    if get(:part_1_on)
      
      # --- DYNAMIC MIDI CONTROL ---
      # Remap SendB to control the Reverb mix, making it more atmospheric
      control rev, mix: 0.5, room: 0.5 # sendA_1 is now BPM
      
      # Play 8 slices over 2 beats to create a funky, syncopated rhythm
      8.times do
        s = rrand_i(1, 20)
        s1 = [10, 9, 10, 9, 10, 9, 10, 11, 12, 13, 14, 15].choose
        s2 = [1, 3, 5, 7,  9, 11, 13, 15].choose
        r = one_in(4) ? -1 : 1
        if current_section == :A
          sgen = s1
          rp = 0
          wait = 1
        elsif current_section == :B
          sgen = s
          rp = -1
          wait = 0.5
        elsif current_section == :C
          sgen = s2
          rp = -1.2
          wait = 0.25
        end
        
        sample :loop_amen,
          beat_stretch: 2,
          num_slices: 15,
          slice: sgen,
          amp: get(:amp_1)*rrand(1, 1.5),
          pan: get(:pan_1),
          rate: r * (((get(:sendB_1)-1)*6)+0.1)+rp
        
        human = rrand(-0.01, 0.01)
        slp = one_in(4) ? wait : 0.25
        sleep slp  + human
      end
      
    else
      sleep 2
    end
    
    
  end
end
