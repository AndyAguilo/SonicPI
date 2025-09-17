example:
https://audius.co/andyserra/algo-sexta-live-coding


 L I V E   P E R F O R M A N C E   T E M P L A T E
```

A modular, 8-part live coding environment for Sonic Pi, designed for the **Novation Launch Control XL**.

This project transforms Sonic Pi into a powerful 8-part instrument with live arrangement capabilities. It's built around a central "master controller" (`buffer0`) that handles all MIDI input and LED feedback, leaving the other 8 buffers free to be used as independent musical parts or "tracks."

<img width="535" height="482" alt="Novation Launch Control XL Custom Mapping" src="https://github.com/user-attachments/assets/89561a08-d34c-4f20-acf3-9d10b04dd549" />

## Features

*   **8 Independent Musical Parts:** Control up to 8 `live_loop`s across different buffers.
*   **Dynamic Song Structure:** Use dedicated buttons to switch between three song sections (A, B, C), allowing for live arrangement of verses, choruses, and bridges.
*   **Centralized MIDI Control:** A single "brain" buffer (`buffer0`) manages all MIDI mapping, keeping your instrument buffers clean and focused on music.
*   **Bi-Directional LED Feedback:** The controller's buttons light up to show which parts are playing and which song section is active, providing essential visual feedback.
*   **Global BPM Control:** The first knob (`Send A` on Part 1) acts as a master tempo control for the entire project.
*   **Modular and Extendable:** The architecture is designed to be easily understood and modified.

## Getting Started

To use this template, you'll need to configure your Launch Control XL with the custom mapping provided.

### Requirements

*   **Hardware:** Novation Launch Control XL
*   **Software:** Sonic Pi (v3.2.2 or later recommended)

### Setup Instructions

1.  **Configure Your Controller:** The controller needs to be loaded with the custom MIDI CC mapping.
    *   Go to the [Novation Components](https://components.novationmusic.com/) web app.
    *   Import the `sonicpi.syx` file from this repository.
    *   Use the "Send to Launch Control XL" function to upload the template. This ensures the buttons send the correct CC messages for the song structure and LED feedback to work.

2.  **Load the Buffers in Sonic Pi:**
    *   Load `buffer0_midi_config.rb` into Buffer 0 in Sonic Pi.
    *   Load the other buffer files (`buffer1.rb`, `buffer2.rb`, etc.) into their corresponding buffers.

### Performance Workflow

The order in which you run the buffers is critical.

1.  **Run the Performers First:** Press "Run" on all your musical buffers (1 through 8). They will run silently, waiting for commands.
2.  **Run the Brain Last:** Press "Run" on the master controller (Buffer 0).
3.  **You are now live!** Use your controller to arrange your song and perform.

---

## Controller Mapping Details

The `buffer0` script is pre-configured for the following MIDI CC mapping.

| Control Group       | MIDI CC Range | Mapped Variable in Sonic Pi | Description                                      |
| ------------------- | ------------- | --------------------------- | ------------------------------------------------ |
| **Send A Knobs**    | 1 - 8         | `get(:sendA_#)`             | Controls Send A for parts 1-8. **CC 1 is Global BPM.** |
| **Send B Knobs**    | 9 - 16        | `get(:sendB_#)`             | Controls Send B for parts 1-8.                   |
| **Pan/Device Knobs**| 17 - 24       | `get(:pan_#)`               | Controls Panning for parts 1-8.                  |
| **Sliders**         | 25 - 32       | `get(:amp_#)`               | Controls Amplitude (volume) for parts 1-8.       |
| **Play Buttons**    | 33 - 40       | `get(:part_#_on)` (true)    | Turns a musical part on. Lights up GREEN.        |
| **Stop Buttons**    | 41 - 48       | `get(:part_#_on)` (false)   | Turns a musical part off. Corresponding Play button lights up RED. |
| **Song Section**    | 53 / 54 / 55  | `get(:song_section)`        | if A - elsif B - elsif C...Acts like radio buttons with LED feedback. |

*(Where `#` is the part number from 1 to 8)*

## How It Works: The Architecture

The project uses a "brain/performer" model to separate concerns.

### `buffer0_midi_config.rb` (The Brain)

*   This script produces no sound.
*   It listens for all MIDI messages and uses `set` to broadcast global variables (e.g., `set :amp_1, 0.8`).
*   It now also listens for the **Song Section** buttons (CC 53-55) and sets the global `:song_section` variable to `:A`, `:B`, or `:C`.
*   It sends raw MIDI messages (`midi_raw`) back to the controller to update all button LEDs.
*   A secondary `live_loop` acts as a "BPM Conductor," translating the generic `:sendA_1` value into the global `:master_bpm`.

### `buffer1.rb` - `buffer8.rb` (The Performers)

*   These are your instruments.
*   They use `get` to listen for the global variables from the brain (e.g., `amp: get(:amp_1)`).
*   They all contain `use_bpm get(:master_bpm)` to stay in sync.
*   **To use the new song structure feature,** you can wrap musical variations inside an `if/elsif` block within your `live_loop`s.
