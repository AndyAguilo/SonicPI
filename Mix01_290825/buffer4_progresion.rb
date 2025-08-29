set :current_note, :c4

live_loop :elmio do
  use_bpm get(:master_bpm)
  if get(:part_4_on)
    note4 = get(:current_chord_notes).choose + choose([12, 24])
    synth :prophet, note: note4, release: 2, cutoff: rrand(get(:sendA_4)*80, get(:sendA_4)*130), pan: get(:pan_4), amp: get(:amp_4)
    synth :prophet, note: note4 - 12, release: 8, cutoff: rrand(get(:sendB_4)*75, get(:sendB_4)*130), amp: (get(:amp_4))*2
    
  end
  human = rrand(-0.03, 0.03)
  slp = choose([0.25, 0.5, 0.5, 0.75, 1, 1.5, 2, 2.25])
  sleep 3 * slp + human
  
end

