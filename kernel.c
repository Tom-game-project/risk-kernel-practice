// kernel.c

// QEMUで確認した「UART（シリアル通信）」の住所
#define UART0_ADDR 0x10000000

// その住所を「ポインタ」として定義
// volatile は「最適化で勝手に省略するな（必ず書き込め）」という指示
volatile unsigned char *uart = (volatile unsigned char *)UART0_ADDR;

// 1文字送信する関数
void serial_putchar(char c) {
    *uart = c; // アドレスに文字を代入＝送信！
}

// 文字列を送信する関数
void print(const char *s) {
    while (*s != '\0') {
        serial_putchar(*s);
        s++;
    }
}

// OSのメイン関数
void kmain(void) {
    print("Hello, RISC-V World!\n");
    print("This is my first OS.\n");

    // OSは終了してはいけないので無限ループさせる
    while (1) { }
}
