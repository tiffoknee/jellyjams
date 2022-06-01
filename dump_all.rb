# make this be on button press?
sample "~/Github/jellyjams/icebreaker-idling.wav"

# BASS 1

use_sample_bpm :loop_compus, num_beats: 8

live_loop :weirdo do
  sample :loop_weirdo if one_in(3)
  sleep 8
end

live_loop :compus do
  sample :loop_compus if one_in(3)
  sleep 8
end


define :bd do |beats=0,amp=0.8|
  sample :drum_bass_hard, amp: amp
  sleep beats
end

define :sn do |beats=0,amp=0.3|
  sample :drum_snare_hard, amp: amp
  sleep beats
end

if one_in(4)
  live_loop :droomz do
    bd 1
    sn 1
    bd 0.25
    bd 0.75, 0.5
    sn 1
  end
end


if one_in(6)
  
  # BASS 2
  
  # NEW SECTION
  
  live_loop :yeah do
    use_bpm 33
    with_fx :slicer, phase: 0.5, wave: 0, mix: 1 do
      
      sample :loop_amen, beat_stretch: 2, amp: 0.5
    end
    
    sleep 2
  end
  
  live_loop :billie_jean do
    use_bpm 33
    use_synth :tb303
    use_random_seed 889999
    notes = (scale :c1, :major_pentatonic)
    8.times do
      play notes.choose, release: 0.125, cutoff: 100,
        res: 0.5, wave: 0, amp: 0.4
      sleep 0.125
    end
    
  end
end


# NEW SECTION

# Coded by Sam Aaron

if one_in(10)
  with_fx :reverb, mix: 0.5 do
    live_loop :oceans do
      s = synth [:bnoise, :cnoise, :gnoise].choose, amp: rrand(0.5, 1.5), attack: rrand(0, 4), sustain: rrand(0, 2), release: rrand(1, 5), cutoff_slide: rrand(0, 5), cutoff: rrand(60, 100), pan: rrand(-1, 1), pan_slide: rrand(1, 5), amp: rrand(0.5, 1)
      control s, pan: rrand(-1, 1), cutoff: rrand(60, 110)
      sleep rrand(2, 4)
    end
  end
end


# Ambient Experiment

# Coded by Darin Wilson
#
# The piece consists of three long loops, each of which
# plays one of two randomly selected pitches. Each note
# has different attack, release and sleep values, so that
# they move in and out of phase with each other. This can
# play for quite awhile without repeating itself :)

use_synth choose([:hollow, :dark_ambiance])
with_fx :reverb, mix: 0.7 do
  
  live_loop :note1 do
    play choose([:D4,:E4]), attack: 6, release: 6
    sleep 8
  end
  
  live_loop :note2 do
    play choose([:Fs4,:G4]), attack: 4, release: 5
    sleep 10
  end
  
  live_loop :note3 do
    play choose([:A4, :Cs5]), attack: 5, release: 5
    sleep 11
  end
  
end# Welcome to Sonic Pi

# NEW SECTION

live_loop :attenborough do
  sample "~/Github/jellyjams/dodo-is-dead.wav" if one_in(20)
  sample "~/Github/jellyjams/ww-we-do-with-the-coelacanth.wav" if one_in(21)
  sample "~/Github/jellyjams/story-of-life-on-earth.wav" if one_in(22)
  sample "~/Github/jellyjams/modify-underwater-use.wav" if one_in(18)
  sleep 20
end

live_loop :whales do
  sample "~/Github/jellyjams/hmpback1.wav" if one_in(18)
  sample "~/Github/jellyjams/hmpback2.wav" if one_in(17)
  sample "~/Github/jellyjams/hmpback3.wav" if one_in(16)
  sample "~/Github/jellyjams/hmpback4.wav" if one_in(20)
  sleep 20
end



# NEW SECTION

# not sure about this one

# Ambient

# Coded by Sam Aaron
if one_in(2)
  load_samples(sample_names :ambi)
  sleep 2
  
  with_fx :reverb, mix: 0.8 do
    live_loop :foo do
      # try changing the sp_ vars..
      sp_name = choose sample_names :ambi
      # sp_name = choose sample_names :drum
      sp_time = [1, 2].choose
      #sp_time = 0.5
      sp_rate = 2
      #sp_rate = 4
      
      s = sample sp_name, cutoff: rrand(70, 130), rate: sp_rate * choose([0.5, 1]), pan: rrand(-1, 1), pan_slide: sp_time
      control s, pan: rrand(-1, 1)
      sleep sp_time
    end
  end
end
# NEW SECTION

# Coded by Sam Aaron

if one_in(4)
  use_debug false
  
  with_fx :reverb do
    live_loop :choral do
      r = (ring 0.5, 1.0/3, 3.0/5).choose
      cue :choir, rate: r
      8.times do
        sample :ambi_choir, rate: r, pan: rrand(-1, 1)
        sleep 0.5
      end
    end
  end
  
  
  live_loop :wub_wub do
    with_fx :wobble, phase: 2, reps: 16 do |w|
      with_fx :echo, mix: 0.6 do
        sample :drum_heavy_kick
        sample :bass_hit_c, rate: 0.8, amp: 0.4
        sleep 1
        ## try changing the wobble's phase duration:
        # control w, phase: (ring 0.5, 1, 2).choose
      end
    end
  end
end
# NEW SECTION

# Welcome to Sonic Pi

# Phasing Piano for Sonic Pi, coded by Darin Wilson
# inspired by Steve Reich's Clapping Music
#
# This piece consists of two threads, each playing the same short melodic phrase.
#
# On every third pass through the phrase, one of the threads shifts the phase by
# 1/4 of a beat, moving it more and more out of phase. Eventually, it comes
# back around to where it started, and the piece ends.

if one_in(20)
  use_synth :dark_ambience
  
  use_bpm 44
  
  define :play_phrase do
    play_pattern_timed [72, 70, 72, 67, 65, 70, 62, 60],
      [0.25, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25, 0.25]
  end
  
  # this thread plays the phrase consistently
  with_fx :pan, pan: -0.5 do
    in_thread(name: :steady) do
      10.times do
        play_phrase
        sleep 0.25
      end
    end
  end
  
  # this thread shifts the phrase 1/4 beat later on every 3rd pass
  with_fx :pan, pan: 0.5 do
    in_thread(name: :phasing) do
      13.times do
        3.times do |count|
          play_phrase
          # last time, wait an extra 0.25 before starting the phrase again
          sleep (count == 2 ? 0.5 : 0.25)
        end
        puts "SHIFT!"
      end
    end
  end
end