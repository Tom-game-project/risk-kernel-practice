// kernel.c

// QEMUで確認した「UART（シリアル通信）」の住所
// ```sh
// qemu-system-riscv64 -machine virt -monitor stdio -serial null -nographic
// 
// (qemu) info mtree
// ```
//
#define UART0_ADDR 0x10000000

// その住所を「ポインタ」として定義
// volatile は「最適化で勝手に省略するな（必ず書き込め）」という指示
volatile unsigned char *uart = (volatile unsigned char *)UART0_ADDR;

// 文字を送信する（出力）
void serial_putchar(char c) {
    *uart = c;
}

// ★追加：キー入力を受け取る（入力）
char serial_getchar(void) {
    // LSR（ベースアドレス + 5番地）へのポインタ
    volatile unsigned char *lsr = (volatile unsigned char *)(UART0_ADDR + 5);

    // 一番下のビット（Data Ready）が1になるまで無限ループで待つ
    // 1 & *lsr は、「*lsr の値の1ビット目だけ取り出す」という意味
    while ((1 & *lsr) == 0) {
        // まだデータが来ていないので何もしない（ポーリング）
    }

    // データが来たので、受信バッファ（+0番地）を読んで返す
    return *uart;
}

void print(const char *s) {
    while (*s != '\0') {
        serial_putchar(*s);
        s++;
    }
}

void kmain(void) {
    print("Hello, RISC-V World!\n");
    print("Type something: "); // 入力を促す

    // 無限ループで「入力 → 出力」を繰り返す
    while (1) {
        char c = serial_getchar(); // キー入力を待つ（ここで止まる）

        // Enterキー（'\r'）が押されたら改行も見やすくする
        if (c == '\r') {
            serial_putchar('\n');
        }

        serial_putchar(c); // 入力された文字をそのまま画面に出す（エコーバック）
    }
}
