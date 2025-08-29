# We use 'set' to initialize the start position for our slicer.
# This is better than a global variable.
set :slicer_pos, 0.0

with_fx :panslicer, wave: 3, mix: get(:sendB_5) do
  live_loop :slicer do
    if get(:part_5_on)
      
      # Get the current start position
      s = get(:slicer_pos)
      
      # The main granulation loop
      32.times do
        # FIX 2: Use the correct variable name: :part_3_amp
        sample :loop_breakbeat,
          start: s,
          finish: s + 0.01,
          amp: get(:amp_5)*rrand(2, 4),
          cutoff: rrand(60, 120),
          pan: get(:pan_5)
        
        sleep 0.025
      end
      
      # Update the start position for the next pass
      if s < 0.95
        set :slicer_pos, s + 0.01
      else
        set :slicer_pos, 0.0 # Reset to the beginning
      end
      
    end
    
    
    rate_control = [get(:sendA_5), 0.01].max #Prevent division by zero.
    
    sleep (32 * 0.025) / (rate_control * 20)
    
  end
end