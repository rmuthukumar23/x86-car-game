.text
.global handle_input

handle_input:
    pushq   %rbp
    movq    %rsp, %rbp
    
    # check left arrow key
    movl    $263, %edi
    call    IsKeyPressed
    testl   %eax, %eax
    jz      check_right
    
    # move left if possible
    movl    player_lane, %eax
    cmpl    $0, %eax
    jle     check_right
    decl    %eax
    movl    %eax, player_lane

check_right:
    # check right arrow key  
    movl    $262, %edi
    call    IsKeyPressed
    testl   %eax, %eax
    jz      input_done
    
    # move right if possible
    movl    player_lane, %eax
    cmpl    $2, %eax
    jge     input_done
    incl    %eax
    movl    %eax, player_lane

input_done:
    popq    %rbp
    ret
