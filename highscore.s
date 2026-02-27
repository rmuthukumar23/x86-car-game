.text
.global init_highscores
.global update_highscores
.global draw_highscore_entry

# initialize highscore data
init_highscores:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # initialize highscores with default values (0)
    movq    $0, %rbx

init_highscores_loop:
    cmpq    $5, %rbx
    jge     init_highscores_done
    
    leaq    highscores, %rax
    movl    $0, (%rax, %rbx, 4)
    
    leaq    highscore_levels, %rax
    movl    $0, (%rax, %rbx, 4)
    
    incq    %rbx
    jmp     init_highscores_loop
    
init_highscores_done:
    popq    %rbp
    ret

# called when game ends to check if current score qualifies
update_highscores:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    pushq   %r12
    pushq   %r13
    
    # current score
    movl    score, %r12d
    # current level
    movl    level, %r13d
    
    # check if score qualifies for highscore list
    # highscore counter
    movq    $0, %rbx

check_highscore_loop:
    # check if we've checked all highscores
    cmpq    $5, %rbx
    jge     update_highscores_done
    
    leaq    highscores, %rax
    movl    (%rax, %rbx, 4), %ecx
    
    # if current score is higher than this position, insert it
    cmpl    %ecx, %r12d
    jg      insert_highscore
    
    # increment counter and jump the loop
    incq    %rbx
    jmp     check_highscore_loop

insert_highscore:
    # shift existing scores down to make room
    # start counter from second to last position
    movq    $4, %rcx

shift_loop:
    # compare the counter to the place the highscore should be inserted
    cmpq    %rbx, %rcx
    jl      shift_done
    
    # Move score down
    leaq    highscores, %rax
    movl    -4(%rax, %rcx, 4), %edx
    movl    %edx, (%rax, %rcx, 4)
    
    # Move level down
    leaq    highscore_levels, %rax
    movl    -4(%rax, %rcx, 4), %edx
    movl    %edx, (%rax, %rcx, 4)
    
    decq    %rcx
    jmp     shift_loop

shift_done:
    # Insert new score at position
    leaq    highscores, %rax
    movl    %r12d, (%rax, %rbx, 4)
    
    leaq    highscore_levels, %rax
    movl    %r13d, (%rax, %rbx, 4)

update_highscores_done:
    popq    %r13
    popq    %r12
    popq    %rbx
    popq    %rbp
    ret

# ===== DRAW HIGHSCORE ENTRY =====
# Parameters: %rdi = position (0-4), %esi = y_position
draw_highscore_entry:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx
    pushq   %r12
    pushq   %r13
    pushq   %r14
    
    movq    %rdi, %rbx        # position (0-4)
    movl    %esi, %r14d       # y_position
    
    # Get score and level for this position
    leaq    highscores, %rax
    movl    (%rax, %rbx, 4), %edx    # score
    
    leaq    highscore_levels, %rax
    movl    (%rax, %rbx, 4), %ecx    # level
    
    # Format highscore text
    leaq    highscore_text, %rdi
    movq    %rbx, %rsi
    addq    $1, %rsi          # position + 1 (1-5 instead of 0-4)
    movq    %rdx, %rdx        # score
    movq    %rcx, %rcx        # level
    call    TextFormat
    movq    %rax, %r12        # save formatted text
    
    # Measure text for centering
    movq    %rax, %rdi
    movl    $30, %esi
    call    MeasureText
    movl    %eax, %r13d       # text width
    
    # Calculate centered X position
    movl    screen_width, %eax
    subl    %r13d, %eax
    shrl    $1, %eax          # divide by 2
    
    # Draw the text
    movq    %r12, %rdi
    movl    %eax, %esi        # centered x
    movl    %r14d, %edx       # y
    movl    $30, %ecx         # font size
    movl    color_white, %r8d
    call    DrawText
    
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbx
    popq    %rbp
    ret
