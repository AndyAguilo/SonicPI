
live_loop :rewind do
  min_speed = 0.5 + get(:sendA_3)
  max_speed = 2.3 + get(:sendB_3)
  direction = [-1, 1].choose
  speed = rrand(min_speed, max_speed)
  f_rate1 = direction * speed
  sustain_time = 1
  release_time = 1
  #
  use_bpm get(:master_bpm)
  if get(:part_3_on)
    sample :perc_bell, rate: f_rate1, attack: 0.2, release: release_time, sustain: sustain_time, amp: get(:amp_3)*rrand(2.5, 4), pan: get(:pan_3)
  end
  sleep sample_duration(:tabla_ghe6) + sustain_time + release_time / (f_rate1.abs + 0.01)
  sleep one_in(8) ? 1 : 4
end
