
live_loop :rewind do
  min_speed = 1.8 + get(:sendA_3)
  max_speed = 3.8 + get(:sendA_3)
  
  speed = rrand(min_speed, max_speed)
  
  sustain_time = 1
  release_time = 2
  current_section = get(:song_section)
  use_bpm get(:master_bpm)
  if current_section == :A
    direction = [-1, 1].choose
  elsif current_section == :B
    direction = [1, 1].choose
  elsif current_section == :C
    direction = [-1, -1].choose
  end
  f_rate1 = direction * speed
  
  if get(:part_3_on)
    sample :perc_bell, rate: f_rate1, attack: 0.1, release: release_time, sustain: sustain_time, amp: get(:amp_3)*rrand(2.5, 4), pan: get(:pan_3)
  end
  sleep sample_duration(:perc_bell) + sustain_time + release_time / (f_rate1.abs + 0.01)
  sleep (one_in(8) ? 1 : 4)
end
