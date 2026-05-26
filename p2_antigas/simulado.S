#---------------------------------------
.data
    .globl key
    .align 1
key: .byte 5

    .globl threshhold
    .align 2
threshhold: .short 512

    .globl scores
    .align 4
scores: .int 100, 600, 300, 800

    .globl total
    .align 8
total: .quad 0

#---------------------------------------
.text

.globl practice_exam
practice_exam:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp

    # for (i = 0; i < 4; i++)
    movl    $0, -4(%rbp)  # i = 0

begin_for:
    cmpl    $4, -4(%rbp)  # i >= 4 -> end_for
    jge     end_for

    movq    $scores, %r8
    movslq -4(%rbp), %r9
    imulq   $4, %r9
    addq    %r8, %r9
    movl    (%r9), %eax  # eax = scores[i]

    # _if (scores[i] < threshhold)
    movswl  threshhold, %edx

    cmpl    %edx, %eax  # if scores[i] < threshhold
    jge     else_block

    # temp = (short)(key * 4)
    movsbl  key, %eax  # eax = (int)key
    imull   $4, %eax   # eax = key * 4

    movw    %ax, -6(%rbp)  # temp = (short)resultado

    # total += temp
    movq    total, %rax
    movswq  -6(%rbp), %rcx  # rcx = (long)temp
    addq    %rcx, %rax
    movq    %rax, total

    jmp     end_if

else_block:
    # temp = calculate_bonus(scores[i], key, &total);
    movq   $scores, %r8
    movslq -4(%rbp), %r9
    imulq   $4, %r9
    addq    %r8, %r9
    movl    (%r9), %edi  # edi = scores[i]

    movb    key, %sil  # sil = key

    movq    $total, %rdx  # rdx = &total

    call    calculate_bonus

    movw    %ax, -6(%rbp)  # temp = %ax

    # scores[i] = (int)(temp << 2);
    movswl  -6(%rbp), %eax  # eax = (int)temp
    shll    $2, %eax       # eax = temp << 2
    movq    $scores, %r8
    movslq -4(%rbp), %r9
    imulq   $4, %r9
    addq    %r8, %r9

    movl    %eax, (%r9)  # scores[i] = (int)(temp << 2)

end_if:
    # i++
    incl    -4(%rbp)  # i++

    jmp     begin_for

end_for:
    leave
    ret