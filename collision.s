.text
.global check_collisions

# collision detection
check_collisions:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    
    # check collision with each active car
    movq    $0, %rbx
collision_loop:
    cmpq    $10, %rbx
    jge     collision_done
    
    # check if car is active
    leaq    cars_active, %rax
    cmpl    $0, (%rax, %rbx, 4)
    je      next_collision
    
    # get car position
    leaq    cars_x, %rax
    movss   (%rax, %rbx, 4), %xmm0
    leaq    cars_y, %rax
    movss   (%rax, %rbx, 4), %xmm1
    
    # get player position
    movss   player_x, %xmm2
    movss   player_y, %xmm3
    
    # calculate half size
    movss   player_size, %xmm4
    movss   pointfive, %xmm5
    mulss   %xmm5, %xmm4
    
    # check x collision: abs(player_x - car_x) < size
    movss   %xmm2, %xmm6
    subss   %xmm0, %xmm6
    # absolute value
    andps   abs_mask, %xmm6
    movss   player_size, %xmm7
    comiss  %xmm7, %xmm6
    jae     next_collision
    
    # check y collision: abs(player_y - car_y) < size
    movss   %xmm3, %xmm6
    subss   %xmm1, %xmm6
    andps   abs_mask, %xmm6
    movss   player_size, %xmm7
    comiss  %xmm7, %xmm6
    jae     next_collision
    
    # collision detected
    movl    $1, game_over
    # update highscores when game ends
    call    update_highscores
    jmp     collision_done

next_collision:
    incq    %rbx
    jmp     collision_loop

collision_done:
    popq    %rbx
    popq    %rbp
    ret
