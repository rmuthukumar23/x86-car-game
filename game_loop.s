.text
.global game_loop

game_loop:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp

game_loop_start:
    # check if window should close
    call    WindowShouldClose
    testl   %eax, %eax
    jnz     game_loop_end
    
    # check game state
    cmpl    $0, game_over
    jne     game_over_state
    
    # normal gameplay updates
    call    handle_input
    call    update_level
    call    update_cars
    call    update_player
    call    update_score
    call    check_collisions
    jmp     render

game_over_state:
    # check for restart
    # enter key
    movl    $257, %edi
    call    IsKeyPressed
    testl   %eax, %eax
    jz      render
    
    # restart game
    call    restart_game

render:
    # render frame
    call    render_frame
    
    jmp     game_loop_start

game_loop_end:
    # epilogue
    popq    %rbp
    ret
