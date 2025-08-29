with_fx :reverb do |rev|
  live_loop :dnbs do
    
    control rev, room: get(:sendA_7), mix: get(:sendB_7)
    
    hihat_beat = [1, 1, 1, 1,  1, 1, 1, 1].tick
    dbass_beat = [0, 0, 1, 0,  0, 0, 1, 0].tick
    dkick_beat = [1, 1, 0, 0,  0, 1, 0, 1].tick
    
    if get(:part_7_on)
      
      if hihat_beat == 1
        sample :hat_tap, amp: get(:amp_7)*1, rate: 1, pan: get(:pan_7)
      end
      if dbass_beat == 1
        sample :drum_snare_soft, amp: get(:amp_7)*1, rate: 1, pan: get(:pan_7)
      end
      #if dkick_beat == 1
      #sample :drum_bass_soft, amp: get(:amp_7)*1, rate: 1, pan: get(:pan_7), sustain: 0.05, release: 0.1
      #sample :bd_808, amp: get(:amp_7)*1, rate: 1, pan: get(:pan_7), sustain: 0.05, release: 0.1
      #end
      if dkick_beat == 1
        with_fx :compressor, threshold: 0.5 do
          sample :drum_bass_soft, amp: get(:amp_7)*1, rate: 1, pan: get(:pan_7), sustain: 0.05, release: 0.1
          sample :bd_808, amp: get(:amp_7)*1, sustain: 0.1, release: 0.1, cutoff: 80
          
        end
      end
      
    end
    sleep get(:sendA_2)+0.01
  end
end
