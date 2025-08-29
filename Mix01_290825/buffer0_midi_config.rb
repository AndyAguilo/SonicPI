# ===================================================================
# ==  MASTER MIDI CONTROLLER - FULL MAPPING v1.0 (for Buffer 0)    ==
# ===================================================================

# --- CONFIGURATION ---
MIDI_PORT = "launch_control_xl"
STATUS_BYTE_CH1 = 0xB0           # The raw status byte for CC on Channel 1

# --- LED COLOR DEFINITIONS (sent as the CC Value) ---
LED_OFF = 0
LED_RED = 15
LED_GREEN = 60

# --- INITIAL SETUP ---
puts "Initializing 8 parts with full controls and setting LED states..."
8.times do |i|
  part_number = i + 1
  
  # --- Initialize all variables for each part ---
  set "part_#{part_number}_on", false
  set "amp_#{part_number}", 0.2
  set "sendA_#{part_number}", 0.6
  set "sendB_#{part_number}", 0.5
  set "pan_#{part_number}", 0
  
  play_button_cc = i + 33
  
  # Set the initial state of the play buttons to RED
  midi_raw STATUS_BYTE_CH1, play_button_cc, LED_RED, port: MIDI_PORT
end
puts "Initialization complete. Ready for action."


# --- MAIN MIDI LISTENER LOOP ---
live_loop :midi_master_controller do
  use_real_time
  controller_number, value = sync "/midi:launch_control_xl:1/control_change"
  
  # ============================================
  # ==            KNOB CONTROLS               ==
  # ============================================
  
  # --- NEW: Handle Send A Knobs (Top Row, CC 1-8) ---
  if controller_number.between?(1, 8)
    part_number = controller_number
    # Scale MIDI 0-127 to a standard FX mix range of 0.0 to 1.0
    scaled_value = value / 127.0
    set "sendA_#{part_number}", scaled_value
    puts "PART #{part_number} SEND A: #{scaled_value.round(2)}"
  end
  
  # --- NEW: Handle Send B Knobs (Middle Row, CC 9-16) ---
  if controller_number.between?(9, 16)
    part_number = controller_number - 8
    scaled_value = value / 127.0
    set "sendB_#{part_number}", scaled_value
    puts "PART #{part_number} SEND B: #{scaled_value.round(2)}"
  end
  
  # --- NEW: Handle Pan Knobs (Bottom Row, CC 17-24) ---
  # Note: The Launch Control XL has 8 knobs in this row (17-24)
  if controller_number.between?(17, 24)
    part_number = controller_number - 16
    # Scale MIDI 0-127 to a pan range of -1.0 (L) to 1.0 (R)
    scaled_value = (value / 127.0) * 2.0 - 1.0
    set "pan_#{part_number}", scaled_value
    puts "PART #{part_number} PAN: #{scaled_value.round(2)}"
  end
  
  # ============================================
  # ==           SLIDER & BUTTONS             ==
  # ============================================
  
  # --- Handle Amplitude Sliders (CC 25-32) ---
  if controller_number.between?(25, 32)
    part_number = controller_number - 24
    scaled_amp = (value / 127.0) * 1.5
    set "amp_#{part_number}", scaled_amp
  end
  
  # --- Handle Play/Stop Buttons (only on press, value 127) ---
  if value == 127
    
    # Handle PLAY buttons (CC 33-40)
    if controller_number.between?(33, 40)
      part_number = controller_number - 32
      set "part_#{part_number}_on", true
      puts "PART #{part_number}: ON"
      
      play_button_cc = controller_number
      midi_raw STATUS_BYTE_CH1, play_button_cc, LED_GREEN, port: MIDI_PORT
    end
    
    # Handle STOP buttons (CC 41-48)
    if controller_number.between?(41, 48)
      part_number = controller_number - 40
      set "part_#{part_number}_on", false
      puts "PART #{part_number}: OFF"
      
      play_button_cc = controller_number - 8
      midi_raw STATUS_BYTE_CH1, play_button_cc, LED_RED, port: MIDI_PORT
    end
  end
end