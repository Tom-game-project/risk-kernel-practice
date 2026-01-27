/* entry.S */
.section .text
.global _start

_start:
    /* 1. スタックポインタ(sp)を設定する */
    /* スタックはメモリの後ろの方（stack_top）から手前に向かって伸びる */
    la sp, stack_top

    /* 2. C言語のメイン関数へジャンプ */
    call kmain

    /* 3. もしkmainから戻ってきたら、無限ループで止める */
    j .

/* スタック領域の確保 */
.section .bss
    .space 4096 * 4  /* 16KB分のスペースを確保 */
stack_top:
