.text
.global update_level
.global update_player
.global update_cars
.global update_score

update_level:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # update level timer
    call    GetFrameTime
    addss   level_timer, %xmm0
    movss   %xmm0, level_timer
    
    # check if level_up_time seconds have passed
    comiss  level_up_time, %xmm0
    jb      update_level_done
    
    # level up
    call    level_up

update_level_done:
    # epilogue
    popq    %rbp
    ret

level_up:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # increment level
    movl    level, %eax
    incl    %eax
    movl    %eax, level
    
    # reset level timer
    xorps   %xmm0, %xmm0
    movss   %xmm0, level_timer
    
    # increase car speed by 10%
    movss   car_speed, %xmm0
    mulss   speed_multiplier, %xmm0
    movss   %xmm0, car_speed
    
    # decrease spawn time by 10%
    movss   car_spawn_time, %xmm0
    mulss   spawn_multiplier, %xmm0
    
    # check if below minimum spawn time
    comiss  min_spawn_time, %xmm0
    jae     apply_spawn_time
    movss   min_spawn_time, %xmm0
    
apply_spawn_time:
    movss   %xmm0, car_spawn_time
    
    # epilogue
    popq    %rbp
    ret

# player movement
update_player:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # put frametime in xmm2
    call    GetFrameTime
    movss   %xmm0, %xmm2
    
    # get target lane position
    movl    player_lane, %eax
    leaq    lanes, %rdi
    # target_x
    movss   (%rdi, %rax, 4), %xmm0
    
    # smooth movement toward target
    # current_x
    movss   player_x, %xmm1
    # difference
    subss   %xmm1, %xmm0
    
    # apply smoothing with frame time
    # multiply by base speed
    mulss   move_speed, %xmm0
    # multiply by frame time
    mulss   %xmm2, %xmm0
    
    # new position
    addss   %xmm0, %xmm1
    movss   %xmm1, player_x
    
    popq    %rbp
    ret

# cars movement
update_cars:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # update spawn timer
    call    GetFrameTime
    addss   car_spawn_timer, %xmm0
    movss   %xmm0, car_spawn_timer
    
    # spawn new car if timer reached
    comiss  car_spawn_time, %xmm0
    jb      update_existing_cars
    
    # reset timer and spawn car
    xorps   %xmm0, %xmm0
    movss   %xmm0, car_spawn_timer
    call    spawn_car

update_existing_cars:
    # update all active cars
    movq    $0, %rbx

update_cars_loop:
    cmpq    $10, %rbx
    jge     update_cars_done
    
    # check if car is active
    leaq    cars_active, %rax
    cmpl    $0, (%rax, %rbx, 4)
    je      next_car
    
    # move car down
    leaq    cars_y, %rax
    movss   (%rax, %rbx, 4), %xmm0
    # get the frametime to sync movement speed with framerate
    call    GetFrameTime
    mulss   car_speed, %xmm0
    leaq    cars_y, %rax
    addss   (%rax, %rbx, 4), %xmm0
    movss   %xmm0, (%rax, %rbx, 4)
    
    # check if car is off screen
    cvtsi2ssl screen_height, %xmm1
    comiss  %xmm1, %xmm0
    jb      next_car
    
    # deactivate off-screen car
    leaq    cars_active, %rax
    movl    $0, (%rax, %rbx, 4)

next_car:
    incq    %rbx
    jmp     update_cars_loop

update_cars_done:
    # epilogue
    popq    %rbp
    ret

# spawn new car
spawn_car:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # find inactive car slot
    movq    $0, %rbx

find_slot_loop:
    cmpq    $10, %rbx
    jge     spawn_done
    
    leaq    cars_active, %rax
    cmpl    $0, (%rax, %rbx, 4)
    je      found_slot
    
    incq    %rbx
    jmp     find_slot_loop

found_slot:
    # activate car
    leaq    cars_active, %rax
    movl    $1, (%rax, %rbx, 4)
    
    # get random lane (0-2) using GetRandomValue
    movl    $0, %edi        # min
    movl    $2, %esi        # max
    call    GetRandomValue
    
    # set car lane and position
    leaq    cars_lane, %rdi
    movl    %eax, (%rdi, %rbx, 4)
    
    leaq    lanes, %rdi
    movss   (%rdi, %rax, 4), %xmm0
    leaq    cars_x, %rdi
    movss   %xmm0, (%rdi, %rbx, 4)
    
    # start above screen
    leaq    cars_y, %rdi
    movss   player_size, %xmm0
    xorps   %xmm1, %xmm1
    subss   %xmm0, %xmm1
    movss   %xmm1, (%rdi, %rbx, 4)

spawn_done:
    # epilogue
    popq    %rbp
    ret

update_score:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    call    GetFrameTime
    addss   score_timer, %xmm0
    movss   %xmm0, score_timer
    
    comiss  score_interval, %xmm0
    jb      update_score_done
    
    addl    $1, score
    xorps   %xmm0, %xmm0
    movss   %xmm0, score_timer
    
update_score_done:
    # epilogue
    popq    %rbp
    ret
