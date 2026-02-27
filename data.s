.data
    # window
    .global screen_width
    .global screen_height
    .global window_title
    screen_width:   .long 720
    screen_height:  .long 900
    window_titele:   .asciz "Traffic Dodge"
    
    # player
    .global player_x
    .global player_y
    .global player_size
    .global player_lane
    player_x:       .float 400.0
    player_y:       .float 600.0
    player_size:    .float 90.0
    # 0=left, 1=middle, 2=right
    player_lane:    .long 1
    
    # lanes
    .global lanes
    .global move_speed
    lanes:          .float 120.0, 360.0, 600.0
    move_speed:     .float 20.0
    
    # cars
    .global car_count
    .global cars_active
    .global cars_x
    .global cars_y
    .global cars_lane
    .global car_spawn_time
    .global car_spawn_timer
    .global car_speed
    .global base_car_speed
    car_count:      .long 10
    cars_active:    .space 40        # 10 * 4 bytes
    cars_x:         .space 40        # 10 * 4 bytes  
    cars_y:         .space 40        # 10 * 4 bytes
    cars_lane:      .space 40        # 10 * 4 bytes
    car_spawn_time: .float 0.75
    car_spawn_timer:.float 0.0
    car_speed:      .float 600.0
    base_car_speed: .float 600.0
    
    # colors
    .global color_white
    .global color_gray
    .global color_red
    .global color_blue
    .global color_black
    .global color_overlay
    .global color_green
    .global color_gold
    color_white:    .long 0xFFFFFFFF
    color_gray:     .long 0xFFD3D3D3
    color_red:      .long 0xFF0000FF
    color_blue:     .long 0xFFFF0000
    color_black:    .long 0xFF000000
    color_overlay:  .long 0x80000000
    color_green:    .long 0xFF00FF00
    color_gold:     .long 0xFF00D7FF

    # floats
    .global pointfive
    .global thousand
    .global level_up_time
    .global speed_multiplier
    .global spawn_multiplier
    .global min_spawn_time
    pointfive: .float 0.5
    thousand:   .float 1000.0
    level_up_time: .float 5.0
    # 15% speed increase per level
    speed_multiplier: .float 1.15
    # 15% spawn rate increase per level
    spawn_multiplier: .float 0.85
    # minimum spawn time
    min_spawn_time:   .float 0.1
    
    # score
    .global score
    .global score_text
    .global score_timer
    .global score_interval
    score:          .long 0
    score_text:     .asciz "Score: %d"
    score_timer:    .float 0.0
    score_interval: .float 0.01
    
    # Game state
    .global game_over
    # 0 = playing, 1 = game over
    game_over:      .long 0
    
    # game over text
    .global gameover_text
    .global restart_text
    .global final_score_text
    .global top_five_scores_text
    .global highscore_text
    gameover_text:  .asciz "GAME OVER"
    restart_text:   .asciz "Press ENTER to restart"
    final_score_text: .asciz "Final Score: %d"
    top_five_scores_text: .asciz "TOP 5 HIGH SCORES"
    highscore_text: .asciz "%d. Score: %d  Level: %d"
    
    # level system
    .global level
    .global level_timer
    .global level_text
    .global level_up_text
    level:          .long 1
    level_timer:    .float 0.0
    level_text:     .asciz "Level: %d"
    level_up_text:  .asciz "LEVEL UP!"

    # highscore system
    .global highscore_count
    .global highscores
    .global highscore_levels
    highscore_count:   .long 5
    highscores:        .space 20      # 5 scores * 4 bytes
    highscore_levels:  .space 20      # 5 levels * 4 bytes
    
    # highscore text buffers
    .global score_buffer
    score_buffer:      .space 64

    # constants
    .global car_spawn_time_init
    car_spawn_time_init: .float 0.75

    # collision mask
    .align 16
    .global abs_mask
abs_mask:
    .long 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF
