live_loop :haunt do
  use_bpm get(:master_bpm)
  if get(:part_3_on)
    sample :perc_bell, rate: rrand(-2.5, 1.5), attack: 0.75, release: 0.75, amp: get(:amp_3)*rrand(0.5, 1.5), pan: get(:pan_3)
  end
  s = one_in(8) ? 2.5 : 1.5
  sleep s
end