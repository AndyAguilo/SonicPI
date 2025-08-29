samp36 = "/Volumes/C001/samples/r-36.wav"
samp37 = "/Volumes/C001/samples/r-37.wav"
samp38 = "/Volumes/C001/samples/r-38.wav"


with_fx :slicer do |s|
  
  live_loop :sample_mio  do
    control s, phase: (get(:sendA_6)+0.01)
    
    if get(:part_6_on)
      sample samp38, amp: get(:amp_6), pan: get(:pan_6), rate: 1 + get(:sendA_2)
    end
    
    sleep get(:sendA_2) * sample_duration(samp38)/2
  end
end