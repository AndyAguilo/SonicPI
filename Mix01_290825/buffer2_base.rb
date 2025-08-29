# BUFFER 2 - BASS

live_loop :bass do
  note2 = get(:current_chord_notes)
  if get(:part_2_on)
    with_fx :reverb, room: get(:sendB_2) do
      use_synth :fm
      play note2, release: rrand(0.1, 0.3), amp: 2* get(:amp_2), pan: get(:pan_2), cutoff: rrand(40, 80)
    end
  end
  human = rrand(-0.03, 0.03)
  
  slp = choose([1, 2, 1, 1, 1])
  sleep slp * (get(:sendA_2)+0.04) + human
end