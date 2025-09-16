set :sendA_7, 0.2
set :sendB_7,  0.2

# --- The "DNA" of our beat ---
kick_base = (ring 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1)
snare_base = (ring 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0)
# --- NEW: The driving 8th-note hi-hat pattern ---
driving_hat_pattern = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)


with_fx :reverb do |rev|
  with_fx :distortion do |dist|
    live_loop :dnbs do
      use_bpm get(:master_bpm)
      
      # --- GENERATIVE SECTION ---
      kick_pattern = kick_base.shuffle
      # I've renamed this variable for clarity
      syncopated_hat_pattern = spread(rrand_i(7, 13), 16)
      
      
      # --- SEQUENCER SECTION ---
      16.times do
        step = tick
        
        control rev, mix: get(:sendA_7)
        control dist, distort: 0.9, mix: get(:sendB_7)
        
        if get(:part_7_on)
          
          # --- KICK (from shuffled pattern) ---
          if kick_pattern[step] == 1
            sample :drum_bass_soft, amp: get(:amp_7) * 3, rate: 2, pan: get(:pan_7), sustain: 0.05, release: 0.1
            sample :bd_808, amp: get(:amp_7) * 2, sustain: 0.1, release: 0.1
          end
          
          # --- SNARE (with probability for ghost notes) ---
          if snare_base[step] == 1
            sample :drum_snare_soft, amp: get(:amp_7) * 2, rate: 1, pan: get(:pan_7)
          elsif one_in(8)
            sample :drum_snare_soft, amp: get(:amp_7) * 0.5, rate: 1.2, pan: get(:pan_7)
          end
          
          # --- DRIVING HI-HAT (The new part) ---
          # This provides the steady pulse.
          if driving_hat_pattern[step] == 1
            # A different sample, and slightly quieter to sit in the mix.
            sample :hat_tap, amp: get(:amp_7) * 2, pan: get(:pan_7)
          end
          
          # --- SYNCOPATED HI-HAT (from euclidean pattern) ---
          # This is the old hi-hat, now acting as a syncopated layer.
          if syncopated_hat_pattern[step]
            sample :hat_raw, amp: get(:amp_7) * 3, rate: 2, pan: get(:pan_7) * -1 # Pan opposite
          end
          
        end
        
        sleep 0.25
      end
    end
  end
end
