set :sendA_7, 0.2
set :sendB_7,  0.2

with_fx :reverb do |rev|
  with_fx :distortion do |dist|
    live_loop :dnbs do
      use_bpm get(:master_bpm)
      hh_beat = (ring 1, 0, 1)
      sn_beat = (ring 0, 0, 0, 0, 1, 0, 0)
      kk_beat = (ring 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0)
      oh_beat = (ring 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1)

      # Use .tick once at the top to get the current step for all patterns
      step = tick
      
      # Control the FX once per step. This is responsive.
      control rev, mix: get(:sendA_7)
      control dist, distort: 0.9, mix: get(:sendB_7)
      
      
      
      if get(:part_7_on)
        
        if hh_beat[step] == 1
          sample :hat_raw, amp: get(:amp_7)*3, rate: 2, pan: get(:pan_7)
        end
        if sn_beat[step]  == 1
          sample :drum_snare_soft, amp: get(:amp_7)*2, rate: 1, pan: get(:pan_7)
        end
        if oh_beat[step]  == 1
          sample :hat_gump, amp: get(:amp_7)*2, rate: 2, pan: get(:pan_7)
        end
        if kk_beat[step]  == 1
          sample :drum_bass_soft, amp: get(:amp_7)*3, rate: 2, pan: get(:pan_7), sustain: 0.05, release: 0.1
          sample :bd_808, amp: get(:amp_7)*2, sustain: 0.1, release: 0.1
        end
        
      end
      sleep 0.25
    end
  end
end
