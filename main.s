.text
.global main

main:
    # prologue
    pushq   %rbp
    movq    %rsp, %rbp

    # call game functions
    call    init_game
    call    game_loop

    # epilogue
    call    CloseWindow
    movq %rbp, %rsp
    popq %rbp
    movq $0, %rdi
    call exit
