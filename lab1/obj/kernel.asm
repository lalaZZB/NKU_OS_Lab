
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp

    tail kern_init
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	00650513          	addi	a0,a0,6 # 80204010 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	01660613          	addi	a2,a2,22 # 80204028 <end>
int kern_init(void) {
    8020001a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
int kern_init(void) {
    80200020:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
    80200022:	165000ef          	jal	ra,80200986 <memset>

    cons_init();  // init the console
    80200026:	14a000ef          	jal	ra,80200170 <cons_init>

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	96e58593          	addi	a1,a1,-1682 # 80200998 <etext>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	98650513          	addi	a0,a0,-1658 # 802009b8 <etext+0x20>
    8020003a:	030000ef          	jal	ra,8020006a <cprintf>

    print_kerninfo();
    8020003e:	062000ef          	jal	ra,802000a0 <print_kerninfo>

    // grade_backtrace();

    idt_init();  // init interrupt descriptor table
    80200042:	13e000ef          	jal	ra,80200180 <idt_init>

    // rdtime in mbare mode crashes
    clock_init();  // init clock interrupt
    80200046:	0e8000ef          	jal	ra,8020012e <clock_init>

    intr_enable();  // enable irq interrupt
    8020004a:	130000ef          	jal	ra,8020017a <intr_enable>
    
    while (1)
    8020004e:	a001                	j	8020004e <kern_init+0x44>

0000000080200050 <cputch>:

/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void cputch(int c, int *cnt) {
    80200050:	1141                	addi	sp,sp,-16
    80200052:	e022                	sd	s0,0(sp)
    80200054:	e406                	sd	ra,8(sp)
    80200056:	842e                	mv	s0,a1
    cons_putc(c);
    80200058:	11a000ef          	jal	ra,80200172 <cons_putc>
    (*cnt)++;
    8020005c:	401c                	lw	a5,0(s0)
}
    8020005e:	60a2                	ld	ra,8(sp)
    (*cnt)++;
    80200060:	2785                	addiw	a5,a5,1
    80200062:	c01c                	sw	a5,0(s0)
}
    80200064:	6402                	ld	s0,0(sp)
    80200066:	0141                	addi	sp,sp,16
    80200068:	8082                	ret

000000008020006a <cprintf>:
 * cprintf - formats a string and writes it to stdout
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...) {
    8020006a:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    8020006c:	02810313          	addi	t1,sp,40 # 80204028 <end>
int cprintf(const char *fmt, ...) {
    80200070:	8e2a                	mv	t3,a0
    80200072:	f42e                	sd	a1,40(sp)
    80200074:	f832                	sd	a2,48(sp)
    80200076:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
    80200078:	00000517          	auipc	a0,0x0
    8020007c:	fd850513          	addi	a0,a0,-40 # 80200050 <cputch>
    80200080:	004c                	addi	a1,sp,4
    80200082:	869a                	mv	a3,t1
    80200084:	8672                	mv	a2,t3
int cprintf(const char *fmt, ...) {
    80200086:	ec06                	sd	ra,24(sp)
    80200088:	e0ba                	sd	a4,64(sp)
    8020008a:	e4be                	sd	a5,72(sp)
    8020008c:	e8c2                	sd	a6,80(sp)
    8020008e:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
    80200090:	e41a                	sd	t1,8(sp)
    int cnt = 0;
    80200092:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
    80200094:	506000ef          	jal	ra,8020059a <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
    80200098:	60e2                	ld	ra,24(sp)
    8020009a:	4512                	lw	a0,4(sp)
    8020009c:	6125                	addi	sp,sp,96
    8020009e:	8082                	ret

00000000802000a0 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
    802000a0:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
    802000a2:	00001517          	auipc	a0,0x1
    802000a6:	91e50513          	addi	a0,a0,-1762 # 802009c0 <etext+0x28>
void print_kerninfo(void) {
    802000aa:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
    802000ac:	fbfff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  entry  0x%016x (virtual)\n", kern_init);
    802000b0:	00000597          	auipc	a1,0x0
    802000b4:	f5a58593          	addi	a1,a1,-166 # 8020000a <kern_init>
    802000b8:	00001517          	auipc	a0,0x1
    802000bc:	92850513          	addi	a0,a0,-1752 # 802009e0 <etext+0x48>
    802000c0:	fabff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  etext  0x%016x (virtual)\n", etext);
    802000c4:	00001597          	auipc	a1,0x1
    802000c8:	8d458593          	addi	a1,a1,-1836 # 80200998 <etext>
    802000cc:	00001517          	auipc	a0,0x1
    802000d0:	93450513          	addi	a0,a0,-1740 # 80200a00 <etext+0x68>
    802000d4:	f97ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  edata  0x%016x (virtual)\n", edata);
    802000d8:	00004597          	auipc	a1,0x4
    802000dc:	f3858593          	addi	a1,a1,-200 # 80204010 <ticks>
    802000e0:	00001517          	auipc	a0,0x1
    802000e4:	94050513          	addi	a0,a0,-1728 # 80200a20 <etext+0x88>
    802000e8:	f83ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  end    0x%016x (virtual)\n", end);
    802000ec:	00004597          	auipc	a1,0x4
    802000f0:	f3c58593          	addi	a1,a1,-196 # 80204028 <end>
    802000f4:	00001517          	auipc	a0,0x1
    802000f8:	94c50513          	addi	a0,a0,-1716 # 80200a40 <etext+0xa8>
    802000fc:	f6fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
    80200100:	00004597          	auipc	a1,0x4
    80200104:	32758593          	addi	a1,a1,807 # 80204427 <end+0x3ff>
    80200108:	00000797          	auipc	a5,0x0
    8020010c:	f0278793          	addi	a5,a5,-254 # 8020000a <kern_init>
    80200110:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
    80200114:	43f7d593          	srai	a1,a5,0x3f
}
    80200118:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
    8020011a:	3ff5f593          	andi	a1,a1,1023
    8020011e:	95be                	add	a1,a1,a5
    80200120:	85a9                	srai	a1,a1,0xa
    80200122:	00001517          	auipc	a0,0x1
    80200126:	93e50513          	addi	a0,a0,-1730 # 80200a60 <etext+0xc8>
}
    8020012a:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
    8020012c:	bf3d                	j	8020006a <cprintf>

000000008020012e <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    8020012e:	1141                	addi	sp,sp,-16
    80200130:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
    80200132:	02000793          	li	a5,32
    80200136:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    8020013a:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    8020013e:	67e1                	lui	a5,0x18
    80200140:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200144:	953e                	add	a0,a0,a5
    80200146:	7f0000ef          	jal	ra,80200936 <sbi_set_timer>
}
    8020014a:	60a2                	ld	ra,8(sp)
    ticks = 0;
    8020014c:	00004797          	auipc	a5,0x4
    80200150:	ec07b223          	sd	zero,-316(a5) # 80204010 <ticks>
    cprintf("++ setup timer interrupts\n");
    80200154:	00001517          	auipc	a0,0x1
    80200158:	93c50513          	addi	a0,a0,-1732 # 80200a90 <etext+0xf8>
}
    8020015c:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
    8020015e:	b731                	j	8020006a <cprintf>

0000000080200160 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    80200160:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    80200164:	67e1                	lui	a5,0x18
    80200166:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020016a:	953e                	add	a0,a0,a5
    8020016c:	7ca0006f          	j	80200936 <sbi_set_timer>

0000000080200170 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
    80200170:	8082                	ret

0000000080200172 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
    80200172:	0ff57513          	zext.b	a0,a0
    80200176:	7a60006f          	j	8020091c <sbi_console_putchar>

000000008020017a <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
    8020017a:	100167f3          	csrrsi	a5,sstatus,2
    8020017e:	8082                	ret

0000000080200180 <idt_init>:
 */
void idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    80200180:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    80200184:	00000797          	auipc	a5,0x0
    80200188:	2f478793          	addi	a5,a5,756 # 80200478 <__alltraps>
    8020018c:	10579073          	csrw	stvec,a5
}
    80200190:	8082                	ret

0000000080200192 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200192:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    80200194:	1141                	addi	sp,sp,-16
    80200196:	e022                	sd	s0,0(sp)
    80200198:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    8020019a:	00001517          	auipc	a0,0x1
    8020019e:	91650513          	addi	a0,a0,-1770 # 80200ab0 <etext+0x118>
void print_regs(struct pushregs *gpr) {
    802001a2:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001a4:	ec7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    802001a8:	640c                	ld	a1,8(s0)
    802001aa:	00001517          	auipc	a0,0x1
    802001ae:	91e50513          	addi	a0,a0,-1762 # 80200ac8 <etext+0x130>
    802001b2:	eb9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001b6:	680c                	ld	a1,16(s0)
    802001b8:	00001517          	auipc	a0,0x1
    802001bc:	92850513          	addi	a0,a0,-1752 # 80200ae0 <etext+0x148>
    802001c0:	eabff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001c4:	6c0c                	ld	a1,24(s0)
    802001c6:	00001517          	auipc	a0,0x1
    802001ca:	93250513          	addi	a0,a0,-1742 # 80200af8 <etext+0x160>
    802001ce:	e9dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001d2:	700c                	ld	a1,32(s0)
    802001d4:	00001517          	auipc	a0,0x1
    802001d8:	93c50513          	addi	a0,a0,-1732 # 80200b10 <etext+0x178>
    802001dc:	e8fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001e0:	740c                	ld	a1,40(s0)
    802001e2:	00001517          	auipc	a0,0x1
    802001e6:	94650513          	addi	a0,a0,-1722 # 80200b28 <etext+0x190>
    802001ea:	e81ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001ee:	780c                	ld	a1,48(s0)
    802001f0:	00001517          	auipc	a0,0x1
    802001f4:	95050513          	addi	a0,a0,-1712 # 80200b40 <etext+0x1a8>
    802001f8:	e73ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    802001fc:	7c0c                	ld	a1,56(s0)
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	95a50513          	addi	a0,a0,-1702 # 80200b58 <etext+0x1c0>
    80200206:	e65ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    8020020a:	602c                	ld	a1,64(s0)
    8020020c:	00001517          	auipc	a0,0x1
    80200210:	96450513          	addi	a0,a0,-1692 # 80200b70 <etext+0x1d8>
    80200214:	e57ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    80200218:	642c                	ld	a1,72(s0)
    8020021a:	00001517          	auipc	a0,0x1
    8020021e:	96e50513          	addi	a0,a0,-1682 # 80200b88 <etext+0x1f0>
    80200222:	e49ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    80200226:	682c                	ld	a1,80(s0)
    80200228:	00001517          	auipc	a0,0x1
    8020022c:	97850513          	addi	a0,a0,-1672 # 80200ba0 <etext+0x208>
    80200230:	e3bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    80200234:	6c2c                	ld	a1,88(s0)
    80200236:	00001517          	auipc	a0,0x1
    8020023a:	98250513          	addi	a0,a0,-1662 # 80200bb8 <etext+0x220>
    8020023e:	e2dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200242:	702c                	ld	a1,96(s0)
    80200244:	00001517          	auipc	a0,0x1
    80200248:	98c50513          	addi	a0,a0,-1652 # 80200bd0 <etext+0x238>
    8020024c:	e1fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200250:	742c                	ld	a1,104(s0)
    80200252:	00001517          	auipc	a0,0x1
    80200256:	99650513          	addi	a0,a0,-1642 # 80200be8 <etext+0x250>
    8020025a:	e11ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    8020025e:	782c                	ld	a1,112(s0)
    80200260:	00001517          	auipc	a0,0x1
    80200264:	9a050513          	addi	a0,a0,-1632 # 80200c00 <etext+0x268>
    80200268:	e03ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    8020026c:	7c2c                	ld	a1,120(s0)
    8020026e:	00001517          	auipc	a0,0x1
    80200272:	9aa50513          	addi	a0,a0,-1622 # 80200c18 <etext+0x280>
    80200276:	df5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    8020027a:	604c                	ld	a1,128(s0)
    8020027c:	00001517          	auipc	a0,0x1
    80200280:	9b450513          	addi	a0,a0,-1612 # 80200c30 <etext+0x298>
    80200284:	de7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    80200288:	644c                	ld	a1,136(s0)
    8020028a:	00001517          	auipc	a0,0x1
    8020028e:	9be50513          	addi	a0,a0,-1602 # 80200c48 <etext+0x2b0>
    80200292:	dd9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    80200296:	684c                	ld	a1,144(s0)
    80200298:	00001517          	auipc	a0,0x1
    8020029c:	9c850513          	addi	a0,a0,-1592 # 80200c60 <etext+0x2c8>
    802002a0:	dcbff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    802002a4:	6c4c                	ld	a1,152(s0)
    802002a6:	00001517          	auipc	a0,0x1
    802002aa:	9d250513          	addi	a0,a0,-1582 # 80200c78 <etext+0x2e0>
    802002ae:	dbdff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002b2:	704c                	ld	a1,160(s0)
    802002b4:	00001517          	auipc	a0,0x1
    802002b8:	9dc50513          	addi	a0,a0,-1572 # 80200c90 <etext+0x2f8>
    802002bc:	dafff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002c0:	744c                	ld	a1,168(s0)
    802002c2:	00001517          	auipc	a0,0x1
    802002c6:	9e650513          	addi	a0,a0,-1562 # 80200ca8 <etext+0x310>
    802002ca:	da1ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002ce:	784c                	ld	a1,176(s0)
    802002d0:	00001517          	auipc	a0,0x1
    802002d4:	9f050513          	addi	a0,a0,-1552 # 80200cc0 <etext+0x328>
    802002d8:	d93ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002dc:	7c4c                	ld	a1,184(s0)
    802002de:	00001517          	auipc	a0,0x1
    802002e2:	9fa50513          	addi	a0,a0,-1542 # 80200cd8 <etext+0x340>
    802002e6:	d85ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002ea:	606c                	ld	a1,192(s0)
    802002ec:	00001517          	auipc	a0,0x1
    802002f0:	a0450513          	addi	a0,a0,-1532 # 80200cf0 <etext+0x358>
    802002f4:	d77ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002f8:	646c                	ld	a1,200(s0)
    802002fa:	00001517          	auipc	a0,0x1
    802002fe:	a0e50513          	addi	a0,a0,-1522 # 80200d08 <etext+0x370>
    80200302:	d69ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    80200306:	686c                	ld	a1,208(s0)
    80200308:	00001517          	auipc	a0,0x1
    8020030c:	a1850513          	addi	a0,a0,-1512 # 80200d20 <etext+0x388>
    80200310:	d5bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    80200314:	6c6c                	ld	a1,216(s0)
    80200316:	00001517          	auipc	a0,0x1
    8020031a:	a2250513          	addi	a0,a0,-1502 # 80200d38 <etext+0x3a0>
    8020031e:	d4dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200322:	706c                	ld	a1,224(s0)
    80200324:	00001517          	auipc	a0,0x1
    80200328:	a2c50513          	addi	a0,a0,-1492 # 80200d50 <etext+0x3b8>
    8020032c:	d3fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200330:	746c                	ld	a1,232(s0)
    80200332:	00001517          	auipc	a0,0x1
    80200336:	a3650513          	addi	a0,a0,-1482 # 80200d68 <etext+0x3d0>
    8020033a:	d31ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    8020033e:	786c                	ld	a1,240(s0)
    80200340:	00001517          	auipc	a0,0x1
    80200344:	a4050513          	addi	a0,a0,-1472 # 80200d80 <etext+0x3e8>
    80200348:	d23ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020034c:	7c6c                	ld	a1,248(s0)
}
    8020034e:	6402                	ld	s0,0(sp)
    80200350:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	00001517          	auipc	a0,0x1
    80200356:	a4650513          	addi	a0,a0,-1466 # 80200d98 <etext+0x400>
}
    8020035a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020035c:	b339                	j	8020006a <cprintf>

000000008020035e <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    8020035e:	1141                	addi	sp,sp,-16
    80200360:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200362:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    80200364:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    80200366:	00001517          	auipc	a0,0x1
    8020036a:	a4a50513          	addi	a0,a0,-1462 # 80200db0 <etext+0x418>
void print_trapframe(struct trapframe *tf) {
    8020036e:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200370:	cfbff0ef          	jal	ra,8020006a <cprintf>
    print_regs(&tf->gpr);
    80200374:	8522                	mv	a0,s0
    80200376:	e1dff0ef          	jal	ra,80200192 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    8020037a:	10043583          	ld	a1,256(s0)
    8020037e:	00001517          	auipc	a0,0x1
    80200382:	a4a50513          	addi	a0,a0,-1462 # 80200dc8 <etext+0x430>
    80200386:	ce5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    8020038a:	10843583          	ld	a1,264(s0)
    8020038e:	00001517          	auipc	a0,0x1
    80200392:	a5250513          	addi	a0,a0,-1454 # 80200de0 <etext+0x448>
    80200396:	cd5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    8020039a:	11043583          	ld	a1,272(s0)
    8020039e:	00001517          	auipc	a0,0x1
    802003a2:	a5a50513          	addi	a0,a0,-1446 # 80200df8 <etext+0x460>
    802003a6:	cc5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003aa:	11843583          	ld	a1,280(s0)
}
    802003ae:	6402                	ld	s0,0(sp)
    802003b0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b2:	00001517          	auipc	a0,0x1
    802003b6:	a5e50513          	addi	a0,a0,-1442 # 80200e10 <etext+0x478>
}
    802003ba:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003bc:	b17d                	j	8020006a <cprintf>

00000000802003be <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    802003be:	11853783          	ld	a5,280(a0)
    802003c2:	472d                	li	a4,11
    802003c4:	0786                	slli	a5,a5,0x1
    802003c6:	8385                	srli	a5,a5,0x1
    802003c8:	06f76763          	bltu	a4,a5,80200436 <interrupt_handler+0x78>
    802003cc:	00001717          	auipc	a4,0x1
    802003d0:	b0c70713          	addi	a4,a4,-1268 # 80200ed8 <etext+0x540>
    802003d4:	078a                	slli	a5,a5,0x2
    802003d6:	97ba                	add	a5,a5,a4
    802003d8:	439c                	lw	a5,0(a5)
    802003da:	97ba                	add	a5,a5,a4
    802003dc:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003de:	00001517          	auipc	a0,0x1
    802003e2:	aaa50513          	addi	a0,a0,-1366 # 80200e88 <etext+0x4f0>
    802003e6:	b151                	j	8020006a <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003e8:	00001517          	auipc	a0,0x1
    802003ec:	a8050513          	addi	a0,a0,-1408 # 80200e68 <etext+0x4d0>
    802003f0:	b9ad                	j	8020006a <cprintf>
            cprintf("User software interrupt\n");
    802003f2:	00001517          	auipc	a0,0x1
    802003f6:	a3650513          	addi	a0,a0,-1482 # 80200e28 <etext+0x490>
    802003fa:	b985                	j	8020006a <cprintf>
            cprintf("Supervisor software interrupt\n");
    802003fc:	00001517          	auipc	a0,0x1
    80200400:	a4c50513          	addi	a0,a0,-1460 # 80200e48 <etext+0x4b0>
    80200404:	b19d                	j	8020006a <cprintf>
void interrupt_handler(struct trapframe *tf) {
    80200406:	1141                	addi	sp,sp,-16
    80200408:	e406                	sd	ra,8(sp)
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            /*2212005 code begin*/
            clock_set_next_event();
    8020040a:	d57ff0ef          	jal	ra,80200160 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
    8020040e:	00004697          	auipc	a3,0x4
    80200412:	c0268693          	addi	a3,a3,-1022 # 80204010 <ticks>
    80200416:	629c                	ld	a5,0(a3)
    80200418:	06400713          	li	a4,100
    8020041c:	0785                	addi	a5,a5,1
    8020041e:	02e7f733          	remu	a4,a5,a4
    80200422:	e29c                	sd	a5,0(a3)
    80200424:	cb11                	beqz	a4,80200438 <interrupt_handler+0x7a>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    80200426:	60a2                	ld	ra,8(sp)
    80200428:	0141                	addi	sp,sp,16
    8020042a:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    8020042c:	00001517          	auipc	a0,0x1
    80200430:	a8c50513          	addi	a0,a0,-1396 # 80200eb8 <etext+0x520>
    80200434:	b91d                	j	8020006a <cprintf>
            print_trapframe(tf);
    80200436:	b725                	j	8020035e <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
    80200438:	06400593          	li	a1,100
    8020043c:	00001517          	auipc	a0,0x1
    80200440:	a6c50513          	addi	a0,a0,-1428 # 80200ea8 <etext+0x510>
    80200444:	c27ff0ef          	jal	ra,8020006a <cprintf>
                print_times++;
    80200448:	00004717          	auipc	a4,0x4
    8020044c:	bd070713          	addi	a4,a4,-1072 # 80204018 <print_times.0>
    80200450:	431c                	lw	a5,0(a4)
                if (print_times == 10){
    80200452:	46a9                	li	a3,10
                print_times++;
    80200454:	0017861b          	addiw	a2,a5,1
    80200458:	c310                	sw	a2,0(a4)
                if (print_times == 10){
    8020045a:	fcd616e3          	bne	a2,a3,80200426 <interrupt_handler+0x68>
}
    8020045e:	60a2                	ld	ra,8(sp)
    80200460:	0141                	addi	sp,sp,16
            	sbi_shutdown();
    80200462:	a1fd                	j	80200950 <sbi_shutdown>

0000000080200464 <trap>:
    }
}

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    80200464:	11853783          	ld	a5,280(a0)
    80200468:	0007c763          	bltz	a5,80200476 <trap+0x12>
    switch (tf->cause) {
    8020046c:	472d                	li	a4,11
    8020046e:	00f76363          	bltu	a4,a5,80200474 <trap+0x10>
 * trap - handles or dispatches an exception/interrupt. if and when trap()
 * returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {trap_dispatch(tf);}
    80200472:	8082                	ret
            print_trapframe(tf);
    80200474:	b5ed                	j	8020035e <print_trapframe>
        interrupt_handler(tf);
    80200476:	b7a1                	j	802003be <interrupt_handler>

0000000080200478 <__alltraps>:
    .endm

    .globl __alltraps
.align(2)
__alltraps:
    SAVE_ALL
    80200478:	14011073          	csrw	sscratch,sp
    8020047c:	712d                	addi	sp,sp,-288
    8020047e:	e002                	sd	zero,0(sp)
    80200480:	e406                	sd	ra,8(sp)
    80200482:	ec0e                	sd	gp,24(sp)
    80200484:	f012                	sd	tp,32(sp)
    80200486:	f416                	sd	t0,40(sp)
    80200488:	f81a                	sd	t1,48(sp)
    8020048a:	fc1e                	sd	t2,56(sp)
    8020048c:	e0a2                	sd	s0,64(sp)
    8020048e:	e4a6                	sd	s1,72(sp)
    80200490:	e8aa                	sd	a0,80(sp)
    80200492:	ecae                	sd	a1,88(sp)
    80200494:	f0b2                	sd	a2,96(sp)
    80200496:	f4b6                	sd	a3,104(sp)
    80200498:	f8ba                	sd	a4,112(sp)
    8020049a:	fcbe                	sd	a5,120(sp)
    8020049c:	e142                	sd	a6,128(sp)
    8020049e:	e546                	sd	a7,136(sp)
    802004a0:	e94a                	sd	s2,144(sp)
    802004a2:	ed4e                	sd	s3,152(sp)
    802004a4:	f152                	sd	s4,160(sp)
    802004a6:	f556                	sd	s5,168(sp)
    802004a8:	f95a                	sd	s6,176(sp)
    802004aa:	fd5e                	sd	s7,184(sp)
    802004ac:	e1e2                	sd	s8,192(sp)
    802004ae:	e5e6                	sd	s9,200(sp)
    802004b0:	e9ea                	sd	s10,208(sp)
    802004b2:	edee                	sd	s11,216(sp)
    802004b4:	f1f2                	sd	t3,224(sp)
    802004b6:	f5f6                	sd	t4,232(sp)
    802004b8:	f9fa                	sd	t5,240(sp)
    802004ba:	fdfe                	sd	t6,248(sp)
    802004bc:	14001473          	csrrw	s0,sscratch,zero
    802004c0:	100024f3          	csrr	s1,sstatus
    802004c4:	14102973          	csrr	s2,sepc
    802004c8:	143029f3          	csrr	s3,stval
    802004cc:	14202a73          	csrr	s4,scause
    802004d0:	e822                	sd	s0,16(sp)
    802004d2:	e226                	sd	s1,256(sp)
    802004d4:	e64a                	sd	s2,264(sp)
    802004d6:	ea4e                	sd	s3,272(sp)
    802004d8:	ee52                	sd	s4,280(sp)

    move  a0, sp
    802004da:	850a                	mv	a0,sp
    jal trap
    802004dc:	f89ff0ef          	jal	ra,80200464 <trap>

00000000802004e0 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
    802004e0:	6492                	ld	s1,256(sp)
    802004e2:	6932                	ld	s2,264(sp)
    802004e4:	10049073          	csrw	sstatus,s1
    802004e8:	14191073          	csrw	sepc,s2
    802004ec:	60a2                	ld	ra,8(sp)
    802004ee:	61e2                	ld	gp,24(sp)
    802004f0:	7202                	ld	tp,32(sp)
    802004f2:	72a2                	ld	t0,40(sp)
    802004f4:	7342                	ld	t1,48(sp)
    802004f6:	73e2                	ld	t2,56(sp)
    802004f8:	6406                	ld	s0,64(sp)
    802004fa:	64a6                	ld	s1,72(sp)
    802004fc:	6546                	ld	a0,80(sp)
    802004fe:	65e6                	ld	a1,88(sp)
    80200500:	7606                	ld	a2,96(sp)
    80200502:	76a6                	ld	a3,104(sp)
    80200504:	7746                	ld	a4,112(sp)
    80200506:	77e6                	ld	a5,120(sp)
    80200508:	680a                	ld	a6,128(sp)
    8020050a:	68aa                	ld	a7,136(sp)
    8020050c:	694a                	ld	s2,144(sp)
    8020050e:	69ea                	ld	s3,152(sp)
    80200510:	7a0a                	ld	s4,160(sp)
    80200512:	7aaa                	ld	s5,168(sp)
    80200514:	7b4a                	ld	s6,176(sp)
    80200516:	7bea                	ld	s7,184(sp)
    80200518:	6c0e                	ld	s8,192(sp)
    8020051a:	6cae                	ld	s9,200(sp)
    8020051c:	6d4e                	ld	s10,208(sp)
    8020051e:	6dee                	ld	s11,216(sp)
    80200520:	7e0e                	ld	t3,224(sp)
    80200522:	7eae                	ld	t4,232(sp)
    80200524:	7f4e                	ld	t5,240(sp)
    80200526:	7fee                	ld	t6,248(sp)
    80200528:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
    8020052a:	10200073          	sret

000000008020052e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
    8020052e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    80200532:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
    80200534:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    80200538:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
    8020053a:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
    8020053e:	f022                	sd	s0,32(sp)
    80200540:	ec26                	sd	s1,24(sp)
    80200542:	e84a                	sd	s2,16(sp)
    80200544:	f406                	sd	ra,40(sp)
    80200546:	e44e                	sd	s3,8(sp)
    80200548:	84aa                	mv	s1,a0
    8020054a:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
    8020054c:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
    80200550:	2a01                	sext.w	s4,s4
    if (num >= base) {
    80200552:	03067e63          	bgeu	a2,a6,8020058e <printnum+0x60>
    80200556:	89be                	mv	s3,a5
        while (-- width > 0)
    80200558:	00805763          	blez	s0,80200566 <printnum+0x38>
    8020055c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
    8020055e:	85ca                	mv	a1,s2
    80200560:	854e                	mv	a0,s3
    80200562:	9482                	jalr	s1
        while (-- width > 0)
    80200564:	fc65                	bnez	s0,8020055c <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
    80200566:	1a02                	slli	s4,s4,0x20
    80200568:	00001797          	auipc	a5,0x1
    8020056c:	9a078793          	addi	a5,a5,-1632 # 80200f08 <etext+0x570>
    80200570:	020a5a13          	srli	s4,s4,0x20
    80200574:	9a3e                	add	s4,s4,a5
}
    80200576:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
    80200578:	000a4503          	lbu	a0,0(s4)
}
    8020057c:	70a2                	ld	ra,40(sp)
    8020057e:	69a2                	ld	s3,8(sp)
    80200580:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
    80200582:	85ca                	mv	a1,s2
    80200584:	87a6                	mv	a5,s1
}
    80200586:	6942                	ld	s2,16(sp)
    80200588:	64e2                	ld	s1,24(sp)
    8020058a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
    8020058c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
    8020058e:	03065633          	divu	a2,a2,a6
    80200592:	8722                	mv	a4,s0
    80200594:	f9bff0ef          	jal	ra,8020052e <printnum>
    80200598:	b7f9                	j	80200566 <printnum+0x38>

000000008020059a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
    8020059a:	7119                	addi	sp,sp,-128
    8020059c:	f4a6                	sd	s1,104(sp)
    8020059e:	f0ca                	sd	s2,96(sp)
    802005a0:	ecce                	sd	s3,88(sp)
    802005a2:	e8d2                	sd	s4,80(sp)
    802005a4:	e4d6                	sd	s5,72(sp)
    802005a6:	e0da                	sd	s6,64(sp)
    802005a8:	fc5e                	sd	s7,56(sp)
    802005aa:	f06a                	sd	s10,32(sp)
    802005ac:	fc86                	sd	ra,120(sp)
    802005ae:	f8a2                	sd	s0,112(sp)
    802005b0:	f862                	sd	s8,48(sp)
    802005b2:	f466                	sd	s9,40(sp)
    802005b4:	ec6e                	sd	s11,24(sp)
    802005b6:	892a                	mv	s2,a0
    802005b8:	84ae                	mv	s1,a1
    802005ba:	8d32                	mv	s10,a2
    802005bc:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005be:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
    802005c2:	5b7d                	li	s6,-1
    802005c4:	00001a97          	auipc	s5,0x1
    802005c8:	978a8a93          	addi	s5,s5,-1672 # 80200f3c <etext+0x5a4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    802005cc:	00001b97          	auipc	s7,0x1
    802005d0:	b4cb8b93          	addi	s7,s7,-1204 # 80201118 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005d4:	000d4503          	lbu	a0,0(s10)
    802005d8:	001d0413          	addi	s0,s10,1
    802005dc:	01350a63          	beq	a0,s3,802005f0 <vprintfmt+0x56>
            if (ch == '\0') {
    802005e0:	c121                	beqz	a0,80200620 <vprintfmt+0x86>
            putch(ch, putdat);
    802005e2:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005e4:	0405                	addi	s0,s0,1
            putch(ch, putdat);
    802005e6:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005e8:	fff44503          	lbu	a0,-1(s0)
    802005ec:	ff351ae3          	bne	a0,s3,802005e0 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
    802005f0:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
    802005f4:	02000793          	li	a5,32
        lflag = altflag = 0;
    802005f8:	4c81                	li	s9,0
    802005fa:	4881                	li	a7,0
        width = precision = -1;
    802005fc:	5c7d                	li	s8,-1
    802005fe:	5dfd                	li	s11,-1
    80200600:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
    80200604:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
    80200606:	fdd6059b          	addiw	a1,a2,-35
    8020060a:	0ff5f593          	zext.b	a1,a1
    8020060e:	00140d13          	addi	s10,s0,1
    80200612:	04b56263          	bltu	a0,a1,80200656 <vprintfmt+0xbc>
    80200616:	058a                	slli	a1,a1,0x2
    80200618:	95d6                	add	a1,a1,s5
    8020061a:	4194                	lw	a3,0(a1)
    8020061c:	96d6                	add	a3,a3,s5
    8020061e:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
    80200620:	70e6                	ld	ra,120(sp)
    80200622:	7446                	ld	s0,112(sp)
    80200624:	74a6                	ld	s1,104(sp)
    80200626:	7906                	ld	s2,96(sp)
    80200628:	69e6                	ld	s3,88(sp)
    8020062a:	6a46                	ld	s4,80(sp)
    8020062c:	6aa6                	ld	s5,72(sp)
    8020062e:	6b06                	ld	s6,64(sp)
    80200630:	7be2                	ld	s7,56(sp)
    80200632:	7c42                	ld	s8,48(sp)
    80200634:	7ca2                	ld	s9,40(sp)
    80200636:	7d02                	ld	s10,32(sp)
    80200638:	6de2                	ld	s11,24(sp)
    8020063a:	6109                	addi	sp,sp,128
    8020063c:	8082                	ret
            padc = '0';
    8020063e:	87b2                	mv	a5,a2
            goto reswitch;
    80200640:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
    80200644:	846a                	mv	s0,s10
    80200646:	00140d13          	addi	s10,s0,1
    8020064a:	fdd6059b          	addiw	a1,a2,-35
    8020064e:	0ff5f593          	zext.b	a1,a1
    80200652:	fcb572e3          	bgeu	a0,a1,80200616 <vprintfmt+0x7c>
            putch('%', putdat);
    80200656:	85a6                	mv	a1,s1
    80200658:	02500513          	li	a0,37
    8020065c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
    8020065e:	fff44783          	lbu	a5,-1(s0)
    80200662:	8d22                	mv	s10,s0
    80200664:	f73788e3          	beq	a5,s3,802005d4 <vprintfmt+0x3a>
    80200668:	ffed4783          	lbu	a5,-2(s10)
    8020066c:	1d7d                	addi	s10,s10,-1
    8020066e:	ff379de3          	bne	a5,s3,80200668 <vprintfmt+0xce>
    80200672:	b78d                	j	802005d4 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
    80200674:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
    80200678:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
    8020067c:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
    8020067e:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
    80200682:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
    80200686:	02d86463          	bltu	a6,a3,802006ae <vprintfmt+0x114>
                ch = *fmt;
    8020068a:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
    8020068e:	002c169b          	slliw	a3,s8,0x2
    80200692:	0186873b          	addw	a4,a3,s8
    80200696:	0017171b          	slliw	a4,a4,0x1
    8020069a:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
    8020069c:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
    802006a0:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
    802006a2:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
    802006a6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
    802006aa:	fed870e3          	bgeu	a6,a3,8020068a <vprintfmt+0xf0>
            if (width < 0)
    802006ae:	f40ddce3          	bgez	s11,80200606 <vprintfmt+0x6c>
                width = precision, precision = -1;
    802006b2:	8de2                	mv	s11,s8
    802006b4:	5c7d                	li	s8,-1
    802006b6:	bf81                	j	80200606 <vprintfmt+0x6c>
            if (width < 0)
    802006b8:	fffdc693          	not	a3,s11
    802006bc:	96fd                	srai	a3,a3,0x3f
    802006be:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
    802006c2:	00144603          	lbu	a2,1(s0)
    802006c6:	2d81                	sext.w	s11,s11
    802006c8:	846a                	mv	s0,s10
            goto reswitch;
    802006ca:	bf35                	j	80200606 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
    802006cc:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
    802006d0:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
    802006d4:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
    802006d6:	846a                	mv	s0,s10
            goto process_precision;
    802006d8:	bfd9                	j	802006ae <vprintfmt+0x114>
    if (lflag >= 2) {
    802006da:	4705                	li	a4,1
            precision = va_arg(ap, int);
    802006dc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    802006e0:	01174463          	blt	a4,a7,802006e8 <vprintfmt+0x14e>
    else if (lflag) {
    802006e4:	1a088e63          	beqz	a7,802008a0 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
    802006e8:	000a3603          	ld	a2,0(s4)
    802006ec:	46c1                	li	a3,16
    802006ee:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
    802006f0:	2781                	sext.w	a5,a5
    802006f2:	876e                	mv	a4,s11
    802006f4:	85a6                	mv	a1,s1
    802006f6:	854a                	mv	a0,s2
    802006f8:	e37ff0ef          	jal	ra,8020052e <printnum>
            break;
    802006fc:	bde1                	j	802005d4 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
    802006fe:	000a2503          	lw	a0,0(s4)
    80200702:	85a6                	mv	a1,s1
    80200704:	0a21                	addi	s4,s4,8
    80200706:	9902                	jalr	s2
            break;
    80200708:	b5f1                	j	802005d4 <vprintfmt+0x3a>
    if (lflag >= 2) {
    8020070a:	4705                	li	a4,1
            precision = va_arg(ap, int);
    8020070c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    80200710:	01174463          	blt	a4,a7,80200718 <vprintfmt+0x17e>
    else if (lflag) {
    80200714:	18088163          	beqz	a7,80200896 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
    80200718:	000a3603          	ld	a2,0(s4)
    8020071c:	46a9                	li	a3,10
    8020071e:	8a2e                	mv	s4,a1
    80200720:	bfc1                	j	802006f0 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
    80200722:	00144603          	lbu	a2,1(s0)
            altflag = 1;
    80200726:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
    80200728:	846a                	mv	s0,s10
            goto reswitch;
    8020072a:	bdf1                	j	80200606 <vprintfmt+0x6c>
            putch(ch, putdat);
    8020072c:	85a6                	mv	a1,s1
    8020072e:	02500513          	li	a0,37
    80200732:	9902                	jalr	s2
            break;
    80200734:	b545                	j	802005d4 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
    80200736:	00144603          	lbu	a2,1(s0)
            lflag ++;
    8020073a:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
    8020073c:	846a                	mv	s0,s10
            goto reswitch;
    8020073e:	b5e1                	j	80200606 <vprintfmt+0x6c>
    if (lflag >= 2) {
    80200740:	4705                	li	a4,1
            precision = va_arg(ap, int);
    80200742:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    80200746:	01174463          	blt	a4,a7,8020074e <vprintfmt+0x1b4>
    else if (lflag) {
    8020074a:	14088163          	beqz	a7,8020088c <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
    8020074e:	000a3603          	ld	a2,0(s4)
    80200752:	46a1                	li	a3,8
    80200754:	8a2e                	mv	s4,a1
    80200756:	bf69                	j	802006f0 <vprintfmt+0x156>
            putch('0', putdat);
    80200758:	03000513          	li	a0,48
    8020075c:	85a6                	mv	a1,s1
    8020075e:	e03e                	sd	a5,0(sp)
    80200760:	9902                	jalr	s2
            putch('x', putdat);
    80200762:	85a6                	mv	a1,s1
    80200764:	07800513          	li	a0,120
    80200768:	9902                	jalr	s2
            num = (unsigned long long)va_arg(ap, void *);
    8020076a:	0a21                	addi	s4,s4,8
            goto number;
    8020076c:	6782                	ld	a5,0(sp)
    8020076e:	46c1                	li	a3,16
            num = (unsigned long long)va_arg(ap, void *);
    80200770:	ff8a3603          	ld	a2,-8(s4)
            goto number;
    80200774:	bfb5                	j	802006f0 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
    80200776:	000a3403          	ld	s0,0(s4)
    8020077a:	008a0713          	addi	a4,s4,8
    8020077e:	e03a                	sd	a4,0(sp)
    80200780:	14040263          	beqz	s0,802008c4 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
    80200784:	0fb05763          	blez	s11,80200872 <vprintfmt+0x2d8>
    80200788:	02d00693          	li	a3,45
    8020078c:	0cd79163          	bne	a5,a3,8020084e <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80200790:	00044783          	lbu	a5,0(s0)
    80200794:	0007851b          	sext.w	a0,a5
    80200798:	cf85                	beqz	a5,802007d0 <vprintfmt+0x236>
    8020079a:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
    8020079e:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802007a2:	000c4563          	bltz	s8,802007ac <vprintfmt+0x212>
    802007a6:	3c7d                	addiw	s8,s8,-1
    802007a8:	036c0263          	beq	s8,s6,802007cc <vprintfmt+0x232>
                    putch('?', putdat);
    802007ac:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
    802007ae:	0e0c8e63          	beqz	s9,802008aa <vprintfmt+0x310>
    802007b2:	3781                	addiw	a5,a5,-32
    802007b4:	0ef47b63          	bgeu	s0,a5,802008aa <vprintfmt+0x310>
                    putch('?', putdat);
    802007b8:	03f00513          	li	a0,63
    802007bc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802007be:	000a4783          	lbu	a5,0(s4)
    802007c2:	3dfd                	addiw	s11,s11,-1
    802007c4:	0a05                	addi	s4,s4,1
    802007c6:	0007851b          	sext.w	a0,a5
    802007ca:	ffe1                	bnez	a5,802007a2 <vprintfmt+0x208>
            for (; width > 0; width --) {
    802007cc:	01b05963          	blez	s11,802007de <vprintfmt+0x244>
    802007d0:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
    802007d2:	85a6                	mv	a1,s1
    802007d4:	02000513          	li	a0,32
    802007d8:	9902                	jalr	s2
            for (; width > 0; width --) {
    802007da:	fe0d9be3          	bnez	s11,802007d0 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
    802007de:	6a02                	ld	s4,0(sp)
    802007e0:	bbd5                	j	802005d4 <vprintfmt+0x3a>
    if (lflag >= 2) {
    802007e2:	4705                	li	a4,1
            precision = va_arg(ap, int);
    802007e4:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
    802007e8:	01174463          	blt	a4,a7,802007f0 <vprintfmt+0x256>
    else if (lflag) {
    802007ec:	08088d63          	beqz	a7,80200886 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
    802007f0:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
    802007f4:	0a044d63          	bltz	s0,802008ae <vprintfmt+0x314>
            num = getint(&ap, lflag);
    802007f8:	8622                	mv	a2,s0
    802007fa:	8a66                	mv	s4,s9
    802007fc:	46a9                	li	a3,10
    802007fe:	bdcd                	j	802006f0 <vprintfmt+0x156>
            err = va_arg(ap, int);
    80200800:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    80200804:	4719                	li	a4,6
            err = va_arg(ap, int);
    80200806:	0a21                	addi	s4,s4,8
            if (err < 0) {
    80200808:	41f7d69b          	sraiw	a3,a5,0x1f
    8020080c:	8fb5                	xor	a5,a5,a3
    8020080e:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    80200812:	02d74163          	blt	a4,a3,80200834 <vprintfmt+0x29a>
    80200816:	00369793          	slli	a5,a3,0x3
    8020081a:	97de                	add	a5,a5,s7
    8020081c:	639c                	ld	a5,0(a5)
    8020081e:	cb99                	beqz	a5,80200834 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
    80200820:	86be                	mv	a3,a5
    80200822:	00000617          	auipc	a2,0x0
    80200826:	71660613          	addi	a2,a2,1814 # 80200f38 <etext+0x5a0>
    8020082a:	85a6                	mv	a1,s1
    8020082c:	854a                	mv	a0,s2
    8020082e:	0ce000ef          	jal	ra,802008fc <printfmt>
    80200832:	b34d                	j	802005d4 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
    80200834:	00000617          	auipc	a2,0x0
    80200838:	6f460613          	addi	a2,a2,1780 # 80200f28 <etext+0x590>
    8020083c:	85a6                	mv	a1,s1
    8020083e:	854a                	mv	a0,s2
    80200840:	0bc000ef          	jal	ra,802008fc <printfmt>
    80200844:	bb41                	j	802005d4 <vprintfmt+0x3a>
                p = "(null)";
    80200846:	00000417          	auipc	s0,0x0
    8020084a:	6da40413          	addi	s0,s0,1754 # 80200f20 <etext+0x588>
                for (width -= strnlen(p, precision); width > 0; width --) {
    8020084e:	85e2                	mv	a1,s8
    80200850:	8522                	mv	a0,s0
    80200852:	e43e                	sd	a5,8(sp)
    80200854:	116000ef          	jal	ra,8020096a <strnlen>
    80200858:	40ad8dbb          	subw	s11,s11,a0
    8020085c:	01b05b63          	blez	s11,80200872 <vprintfmt+0x2d8>
                    putch(padc, putdat);
    80200860:	67a2                	ld	a5,8(sp)
    80200862:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
    80200866:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
    80200868:	85a6                	mv	a1,s1
    8020086a:	8552                	mv	a0,s4
    8020086c:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
    8020086e:	fe0d9ce3          	bnez	s11,80200866 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80200872:	00044783          	lbu	a5,0(s0)
    80200876:	00140a13          	addi	s4,s0,1
    8020087a:	0007851b          	sext.w	a0,a5
    8020087e:	d3a5                	beqz	a5,802007de <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
    80200880:	05e00413          	li	s0,94
    80200884:	bf39                	j	802007a2 <vprintfmt+0x208>
        return va_arg(*ap, int);
    80200886:	000a2403          	lw	s0,0(s4)
    8020088a:	b7ad                	j	802007f4 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
    8020088c:	000a6603          	lwu	a2,0(s4)
    80200890:	46a1                	li	a3,8
    80200892:	8a2e                	mv	s4,a1
    80200894:	bdb1                	j	802006f0 <vprintfmt+0x156>
    80200896:	000a6603          	lwu	a2,0(s4)
    8020089a:	46a9                	li	a3,10
    8020089c:	8a2e                	mv	s4,a1
    8020089e:	bd89                	j	802006f0 <vprintfmt+0x156>
    802008a0:	000a6603          	lwu	a2,0(s4)
    802008a4:	46c1                	li	a3,16
    802008a6:	8a2e                	mv	s4,a1
    802008a8:	b5a1                	j	802006f0 <vprintfmt+0x156>
                    putch(ch, putdat);
    802008aa:	9902                	jalr	s2
    802008ac:	bf09                	j	802007be <vprintfmt+0x224>
                putch('-', putdat);
    802008ae:	85a6                	mv	a1,s1
    802008b0:	02d00513          	li	a0,45
    802008b4:	e03e                	sd	a5,0(sp)
    802008b6:	9902                	jalr	s2
                num = -(long long)num;
    802008b8:	6782                	ld	a5,0(sp)
    802008ba:	8a66                	mv	s4,s9
    802008bc:	40800633          	neg	a2,s0
    802008c0:	46a9                	li	a3,10
    802008c2:	b53d                	j	802006f0 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
    802008c4:	03b05163          	blez	s11,802008e6 <vprintfmt+0x34c>
    802008c8:	02d00693          	li	a3,45
    802008cc:	f6d79de3          	bne	a5,a3,80200846 <vprintfmt+0x2ac>
                p = "(null)";
    802008d0:	00000417          	auipc	s0,0x0
    802008d4:	65040413          	addi	s0,s0,1616 # 80200f20 <etext+0x588>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802008d8:	02800793          	li	a5,40
    802008dc:	02800513          	li	a0,40
    802008e0:	00140a13          	addi	s4,s0,1
    802008e4:	bd6d                	j	8020079e <vprintfmt+0x204>
    802008e6:	00000a17          	auipc	s4,0x0
    802008ea:	63ba0a13          	addi	s4,s4,1595 # 80200f21 <etext+0x589>
    802008ee:	02800513          	li	a0,40
    802008f2:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
    802008f6:	05e00413          	li	s0,94
    802008fa:	b565                	j	802007a2 <vprintfmt+0x208>

00000000802008fc <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802008fc:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
    802008fe:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    80200902:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
    80200904:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    80200906:	ec06                	sd	ra,24(sp)
    80200908:	f83a                	sd	a4,48(sp)
    8020090a:	fc3e                	sd	a5,56(sp)
    8020090c:	e0c2                	sd	a6,64(sp)
    8020090e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
    80200910:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
    80200912:	c89ff0ef          	jal	ra,8020059a <vprintfmt>
}
    80200916:	60e2                	ld	ra,24(sp)
    80200918:	6161                	addi	sp,sp,80
    8020091a:	8082                	ret

000000008020091c <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
    8020091c:	4781                	li	a5,0
    8020091e:	00003717          	auipc	a4,0x3
    80200922:	6e273703          	ld	a4,1762(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    80200926:	88ba                	mv	a7,a4
    80200928:	852a                	mv	a0,a0
    8020092a:	85be                	mv	a1,a5
    8020092c:	863e                	mv	a2,a5
    8020092e:	00000073          	ecall
    80200932:	87aa                	mv	a5,a0
int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
    80200934:	8082                	ret

0000000080200936 <sbi_set_timer>:
    __asm__ volatile (
    80200936:	4781                	li	a5,0
    80200938:	00003717          	auipc	a4,0x3
    8020093c:	6e873703          	ld	a4,1768(a4) # 80204020 <SBI_SET_TIMER>
    80200940:	88ba                	mv	a7,a4
    80200942:	852a                	mv	a0,a0
    80200944:	85be                	mv	a1,a5
    80200946:	863e                	mv	a2,a5
    80200948:	00000073          	ecall
    8020094c:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
    8020094e:	8082                	ret

0000000080200950 <sbi_shutdown>:
    __asm__ volatile (
    80200950:	4781                	li	a5,0
    80200952:	00003717          	auipc	a4,0x3
    80200956:	6b673703          	ld	a4,1718(a4) # 80204008 <SBI_SHUTDOWN>
    8020095a:	88ba                	mv	a7,a4
    8020095c:	853e                	mv	a0,a5
    8020095e:	85be                	mv	a1,a5
    80200960:	863e                	mv	a2,a5
    80200962:	00000073          	ecall
    80200966:	87aa                	mv	a5,a0


void sbi_shutdown(void)
{
    sbi_call(SBI_SHUTDOWN,0,0,0);
    80200968:	8082                	ret

000000008020096a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    8020096a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
    8020096c:	e589                	bnez	a1,80200976 <strnlen+0xc>
    8020096e:	a811                	j	80200982 <strnlen+0x18>
        cnt ++;
    80200970:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
    80200972:	00f58863          	beq	a1,a5,80200982 <strnlen+0x18>
    80200976:	00f50733          	add	a4,a0,a5
    8020097a:	00074703          	lbu	a4,0(a4)
    8020097e:	fb6d                	bnez	a4,80200970 <strnlen+0x6>
    80200980:	85be                	mv	a1,a5
    }
    return cnt;
}
    80200982:	852e                	mv	a0,a1
    80200984:	8082                	ret

0000000080200986 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
    80200986:	ca01                	beqz	a2,80200996 <memset+0x10>
    80200988:	962a                	add	a2,a2,a0
    char *p = s;
    8020098a:	87aa                	mv	a5,a0
        *p ++ = c;
    8020098c:	0785                	addi	a5,a5,1
    8020098e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
    80200992:	fec79de3          	bne	a5,a2,8020098c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
    80200996:	8082                	ret
