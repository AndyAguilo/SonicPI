# We use 'set' to initialize the start position for our slicer.
# This is better than a global variable.
set :slicer_pos, 0.0

with_fx :panslicer, wave: 1, mix: 0.5 do
  live_loop :slicer do
    use_bpm get(:master_bpm)
    if get(:part_5_on)
      
      # Get the current start position
      s = get(:slicer_pos)
      
      # The main granulation loop
      32.times do
        
        sample :loop_breakbeat,
          beat_stretch: 8,
          start: s,
          finish: s + 0.01,
          amp: get(:amp_5)*rrand(2, 3),
          cutoff: rrand(60, 120),
          pan: get(:pan_5),
          hpf: 130*get(:sendB_5)
        
        sleep 0.025
      end
      
      # Update the start position for the next pass
      if s < 0.95
        set :slicer_pos, s + 0.01
      else
        set :slicer_pos, 0.0 # Reset to the beginning
      end
      
    end
    
    sleep 2 * [get(:sendA_5), 0.01].max
    
  end
end
