.text
.global render_frame

render_frame:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %r12
    pushq   %r13
    
    call    BeginDrawing
    
    # set background
    movl    color_white, %edi
    call    ClearBackground
    
    # draw game objects
    call    draw_lanes
    call    draw_cars
    call    draw_player
    
    # check if game over
    cmpl    $0, game_over
    jne     draw_game_over_screen
    
    # draw ui during gameplay
    call    draw_score
    call    draw_level
    jmp     end_drawing

draw_game_over_screen:
    # draw semi-transparent overlay
    movl    $0, %edi
    movl    $0, %esi
    movl    screen_width, %edx
    movl    screen_height, %ecx
    movl    color_overlay, %r8d
    call    DrawRectangle
    
    # draw "GAME OVER"
    leaq    gameover_text, %rdi
    # font size
    movl    $105, %esi
    call    MeasureText
    movl    %eax, %r13d
    
    # calculate centered x: (screen_width - text_width) / 2
    movl    screen_width, %eax
    subl    %r13d, %eax
    # divide by 2
    shrl    $1, %eax
    
    leaq    gameover_text, %rdi
    # x
    movl    %eax, %esi
    # y
    movl    $200, %edx
    # font size
    movl    $105, %ecx
    movl    color_red, %r8d
    call    DrawText
    
    # draw final score
    movl    score, %esi
    leaq    final_score_text, %rdi
    call    TextFormat
    movq    %rax, %r12
    
    movq    %rax, %rdi
    movl    $60, %esi
    call    MeasureText
    movl    %eax, %r13d
    
    # calculate centered x
    movl    screen_width, %eax
    subl    %r13d, %eax
    shrl    $1, %eax
    
    movq    %r12, %rdi
    # x
    movl    %eax, %esi
    # y
    movl    $320, %edx
    movl    $60, %ecx
    movl    color_white, %r8d
    call    DrawText
    
    # draw final level
    movl    level, %esi
    leaq    level_text, %rdi
    call    TextFormat
    movq    %rax, %r12
    
    movq    %rax, %rdi
    movl    $40, %esi
    call    MeasureText
    movl    %eax, %r13d
    
    # calculate centered x
    movl    screen_width, %eax
    subl    %r13d, %eax
    shrl    $1, %eax
    
    movq    %r12, %rdi
    # x
    movl    %eax, %esi
    # y
    movl    $380, %edx
    movl    $40, %ecx
    movl    color_white, %r8d
    call    DrawText
    
    # draw highscores
    leaq    top_five_scores_text, %rdi
    movl    $50, %esi
    call    MeasureText
    movl    %eax, %r13d
    
    # calculate centered x
    movl    screen_width, %eax
    subl    %r13d, %eax
    shrl    $1, %eax
    
    leaq    top_five_scores_text, %rdi
    # x
    movl    %eax, %esi
    # y
    movl    $450, %edx
    movl    $50, %ecx
    movl    color_gold, %r8d
    call    DrawText
    
    # draw highscore entries
    movq    $0, %rdi
    # y
    movl    $515, %esi
    call    draw_highscore_entry
    
    movq    $1, %rdi
    # y
    movl    $545, %esi
    call    draw_highscore_entry
    
    movq    $2, %rdi
    # y
    movl    $575, %esi
    call    draw_highscore_entry
    
    movq    $3, %rdi
    # y
    movl    $605, %esi
    call    draw_highscore_entry
    
    movq    $4, %rdi
    # y
    movl    $635, %esi
    call    draw_highscore_entry
    
    # draw restart instruction
    leaq    restart_text, %rdi
    movl    $30, %esi
    call    MeasureText
    movl    %eax, %r13d
    
    # calculate centered x
    movl    screen_width, %eax
    subl    %r13d, %eax
    shrl    $1, %eax
    
    leaq    restart_text, %rdi
    # x
    movl    %eax, %esi
    # y
    movl    $690, %edx
    movl    $30, %ecx
    movl    color_white, %r8d
    call    DrawText

end_drawing:
    call    EndDrawing
    
    # epilogue
    popq    %r13
    popq    %r12
    popq    %rbp
    ret

draw_level:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # format level text
    movl    level, %esi
    leaq    level_text, %rdi
    call    TextFormat
    
    # draw level at top right
    # formatted text
    movq    %rax, %rdi
    # x
    movl    $10, %esi
    # y (below score)
    movl    $60, %edx
    # font size
    movl    $40, %ecx
    # color
    movl    color_black, %r8d
    call    DrawText
    
    # epilogue
    popq    %rbp
    ret

draw_lanes:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # Draw lane lines
    # x
    movl    $240, %edi
    # y1
    movl    $0, %esi
    # x
    movl    $240, %edx
    # y2
    movl    screen_height, %ecx
    # color
    movl    color_gray, %r8d
    call    DrawLine
    
    # x
    movl    $480, %edi
    # y1
    movl    $0, %esi
    # x
    movl    $480, %edx
    # y2
    movl    screen_height, %ecx
    # color
    movl    color_gray, %r8d
    call    DrawLine
    
    # epilogue
    popq    %rbp
    ret

draw_cars:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # loop counter
    movq    $0, %rbx
draw_cars_loop:
    # if all 10 cars are done jump to done
    cmpq    $10, %rbx
    jge     draw_cars_done
    
    # check if car is active
    leaq    cars_active, %rax
    cmpl    $0, (%rax, %rbx, 4)
    je      next_car_draw
    
    # calculate car position
    leaq    cars_x, %rax
    movss   (%rax, %rbx, 4), %xmm0
    leaq    cars_y, %rax
    movss   (%rax, %rbx, 4), %xmm1
    
    # convert to correct coordinates
    movss   player_size, %xmm2
    movss   pointfive, %xmm3
    mulss   %xmm3, %xmm2
    subss   %xmm2, %xmm0
    
    # x
    cvtss2sil %xmm0, %edi
    # y
    cvtss2sil %xmm1, %esi
    # width
    cvtss2sil player_size, %edx
    # height
    cvtss2sil player_size, %ecx
    movl    color_red, %r8d
    call    DrawRectangle

next_car_draw:
    incq    %rbx
    jmp     draw_cars_loop

draw_cars_done:
    # epilogue
    popq    %rbp
    ret

draw_player:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # calculate player position
    movss   player_x, %xmm0
    movss   player_size, %xmm1
    movss   pointfive, %xmm2
    mulss   %xmm2, %xmm1
    subss   %xmm1, %xmm0
    
    # x
    cvtss2sil %xmm0, %edi
    # y
    cvtss2sil player_y, %esi
    # width
    cvtss2sil player_size, %edx
    # height
    cvtss2sil player_size, %ecx
    # color
    movl    color_blue, %r8d
    call    DrawRectangle
    
    # epilogue
    popq    %rbp
    ret

draw_score:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # format score text
    movl    score, %esi
    leaq    score_text, %rdi
    call    TextFormat
    
    # draw score at top left
    # formatted text
    movq    %rax, %rdi
    # x
    movl    $10, %esi
    # y
    movl    $10, %edx
    # font size
    movl    $50, %ecx
    # color
    movl    color_black, %r8d
    call    DrawText
    
    # epilogue
    popq    %rbp
    ret
