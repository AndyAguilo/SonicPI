samp36 = "/Volumes/C001/samples/r-36.wav"
samp37 = "/Volumes/C001/samples/r-37.wav"
samp38 = "/Volumes/C001/samples/r-38.wav"


with_fx :slicer do |s|
  
  live_loop :sample_mio  do
    use_bpm get(:master_bpm)
    control s, phase: (get(:sendA_6)+0.01)
    
    if get(:part_6_on)
      sample samp38, amp: get(:amp_6), pan: get(:pan_6), beat_stretch: 8
    end
    
    sleep 8
  end
end