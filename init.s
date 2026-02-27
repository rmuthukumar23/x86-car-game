.text
.global init_game

init_game:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # initialize window using raylib
    movl    screen_width, %edi
    movl    screen_height, %esi
    leaq    window_title, %rdx
    call    InitWindow
    
    # set fps
    movl    $0, %edi
    call    SetTargetFPS
    
    # initialize highscores
    call    init_highscores
    
    # initialize cars counter
    movq    $0, %rbx

init_cars_loop:
    cmpq    $10, %rbx
    jge     init_cars_done
    
    leaq    cars_active, %rax
    # add an inactive car
    movl    $0, (%rax, %rbx, 4)
    
    incq    %rbx
    jmp     init_cars_loop

init_cars_done:
    # initialize game state
    movl    $0, score
    movl    $0, game_over
    movl    $1, level
    xorps   %xmm0, %xmm0
    movss   %xmm0, level_timer
    
    # reset car speed and spawn time to original values
    movss   base_car_speed, %xmm0
    movss   %xmm0, car_speed
    movss   car_spawn_time_init, %xmm0
    movss   %xmm0, car_spawn_time
    
    # epilogue
    popq    %rbp
    ret

# restart game
.global restart_game
restart_game:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # reset game over bool
    movl    $0, game_over
    
    # reset player position
    movl    $1, player_lane
    movss   lanes+4, %xmm0
    movss   %xmm0, player_x
    
    # reset score and level
    movl    $0, score
    movl    $1, level
    xorps   %xmm0, %xmm0
    movss   %xmm0, level_timer
    
    # reset car speed and spawn rate
    movss   base_car_speed, %xmm0
    movss   %xmm0, car_speed
    movss   car_spawn_time_init, %xmm0
    movss   %xmm0, car_spawn_time
    
    # reset car spawn timer
    xorps   %xmm0, %xmm0
    movss   %xmm0, car_spawn_timer
    
    # restart cars counter
    movq    $0, %rbx

restart_cars_loop:
    cmpq    $10, %rbx
    jge     restart_done
    
    
    # deactivate cars
    leaq    cars_active, %rax
    movl    $0, (%rax, %rbx, 4)
    
    incq    %rbx
    jmp     restart_cars_loop

restart_done:
    # epilogue
    popq    %rbp
    ret
