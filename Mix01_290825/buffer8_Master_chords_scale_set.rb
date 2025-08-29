# --- The Jazzy Cheat Sheet for C Major ---
#prog_notes = scale(:c3, :major)
#chord_pattern = [:major7, :minor7, :minor7, :major7, :dom7, :minor7, :m7b5]
# The palette of notes for C Minor
prog_notes = scale(:c3, :minor) # => (ring :c4, :d4, :eb4, :f4, :g4, :ab4, :bb4)
chord_pattern = [:minor7, :m7b5, :major7, :minor7, :minor7, :major7, :dom7]
# The palette of notes for C Minor
#prog_notes = scale(:c3, :minor) # => (ring :c4, :d4, :eb4, :f4, :g4, :ab4, :bb4)
#chord_pattern = [:minor, :diminished, :major, :minor, :minor, :major, :major]
# --- The "Deck of Cards" ---
# Create a list of our positions (indices 0 through 6)
# and shuffle it to create our first random progression.
set :shuffled_indices, (range 0, 6).shuffle

with_fx :reverb, room: get(:sendB_8), mix: get(:sendA_8) do
  live_loop :jazzy_shuffled_progression do
    use_bpm get(:master_bpm)
    if get(:part_8_on)
      # --- The "Non-Repeating" Logic ---
      # .tick moves through our shuffled deck one card at a time
      current_idx = get(:shuffled_indices).tick
      
      # This is a check to see if we've dealt all the cards (ticked 7 times).
      # If so, we "re-shuffle the deck" for the next time around.
      if tick % 7 == 0
        set :shuffled_indices, (range 0, 6).shuffle
        puts "--- Reshuffling the progression ---"
      end
      
      # Use the current index from our shuffled deck to get the root and type
      root = prog_notes[current_idx]
      type = chord_pattern[current_idx]
      
      puts "Playing from shuffled deck: #{root} #{type}"
      
      # --- Broadcast for other loops to use ---
      set :current_chord_notes, chord(root, type)
      
      # --- Play the music ---
      synth :fm, note: chord(root, type), cutoff: rrand(80, 110), sustain: rrand(1.3, 4.6), realease: rrand(1.3, 1.6), amp: get(:amp_8)*rrand(1, 2)
      synth :fm, note: root - 12, release: 2
    end
    
    human = rrand(-0.01, 0.01)
    slp = [1, 1.25, 1.5, 1.75].choose
    sleep 7 + slp + human
  end
end

=begin
live_loop :prog_player do

  # --- LISTEN FOR THE NOTES ---
  # Get the list of notes that the first loop broadcasted.
  notes_to_play = get(:current_chord_notes)

  # Check to make sure we actually got the notes before we use them.
  if notes_to_play

    puts "The chord notes I can play are: #{notes_to_play}"

    # Choose a random note directly from the list we received.
    # This is much more flexible than a hard-coded list of numbers!
    note_p = notes_to_play.choose

    synth :prophet, note: note_p + 12, release: 2, amp: 1*get(:amp_8), cutoff: 80

    # To play a bass note, get the first note of the chord (the root)
    # and play it an octave lower.
    root_of_chord = notes_to_play.first
    synth :fm, note: root_of_chord - 12, release: 4, amp: 1*get(:amp_8), cutoff: 50

  end
  human = rrand(-0.01, 0.1)
  sleep get(:sendA_2)* 3 * choose([1, 1.25, 0.75, 0.25, 1, 0.5, 0.5]) + human
end
=end