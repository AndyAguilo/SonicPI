set :current_note, :c4
set :sendB_4,  0.9
set :sendA_4,  0.6

live_loop :elmio do
  current_section = get(:song_section)
  use_bpm get(:master_bpm)
  
  if get(:part_4_on)
    note4 = get(:current_chord_notes).choose +  (one_in(4) ? 24 : 12)
    synth :prophet, note: note4, release: 2, cutoff: rrand(get(:sendA_4)*80, get(:sendA_4)*130), pan: get(:pan_4), amp: get(:amp_4)
    synth :prophet, note: note4 - 12, release: 8, cutoff: rrand(get(:sendB_4)*75, get(:sendB_4)*130), amp: (get(:amp_4))*2
    
  end
  
  if current_section == :A
    slp = choose([1.25, 1, 0.75, 0.75, 1, 1.5, 2, 2.25])
    human = rrand(-0.03, 0.03)
    sleep (3 * slp) + human
  elsif current_section == :B
    slp = choose([0.125, 0.25, 0.25, 0.5, 0.5, 0.75, 1, 1.25])
    human = rrand(-0.03, 0.03)
    sleep (3 * slp) + human
  elsif current_section == :C
    slp = choose([0.25, 0.125, 0.125, 0.25, 0.25])
    human = rrand(-0.03, 0.03)
    sleep (3 * slp) + human
  else
    sleep 1
  end
  
end