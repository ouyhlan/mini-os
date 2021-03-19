#define PML4_BASE 0x100000

void SetPageTable() {
    unsigned long long *PML4 = PML4_BASE;
    /* Setting Stack virtual memory */
    PML4[0] = 0x300027;
    PML4[511] = 0x200027;
    PML4[256] = 0x200027;

    unsigned long long *pdpl_kern = 0x200000;
    pdpl_kern[0] = 0x400027;
    pdpl_kern[511] = 0x400027;

    unsigned long long *pdpl_user = 0x300000;
    pdpl_user[0] = 0x500027;

    unsigned long long *pdl_kern = 0x400000;
    pdl_kern[0] = 0x600027;
    pdl_kern[511] = 0x600027;

    unsigned long long *pdl_user = 0x500000;
    pdl_user[0] = 0x700027;
    pdl_user[2] = 0xb00027;

    unsigned long long *pt_kern = 0x600000;
    /* Setting kernal stack for 1MB */
    unsigned long long kern_stack = 0xa00027;
    for (int i = 0; i < 1 << 8; ++i, kern_stack += 0x1000) {
        pt_kern[i + 256] = kern_stack;
    }

    /* Setting kernal code memory */
    unsigned long long *kern_code = 0x800027;
    for (int i = 0; i < 1 << 8; ++i, kern_code += 0x1000) {
        pt_kern[i] = kern_code;
    }

    /* 0x0100_00000 */
    unsigned long long *pt_user_1 = 0x700000;
    /* Setting first 1MB to the real memory */
    unsigned long long first_one_mega = 0x000027;
    for (int i = 0; i < 1 << 8; ++i, first_one_mega += 0x1000) {
        pt_user_1[i] = first_one_mega; 
    }
    pt_user_1[184] = 0x0B802f;  /* Setting display memory */

    unsigned long long idt = 0x900027;
    for (int i = 0; i < 1 << 8; ++i, idt += 0x1000) {
        pt_user_1[i + 256] = idt;
    }

    unsigned long long *pt_user_2 = 0xb00000;
    unsigned long long user_code = 0xc00027;
    for (int i = 0; i < 1 << 9; ++i, user_code += 0x1000) {
        pt_user_2[i] = user_code; 
    }

    /* Setting IDT for long mode */
    unsigned long long *idt_addr = 0x900000;
    for (int i = 0; i < 1 << 8; ++i) {
        idt_addr[i * 2] = 0x00000e0000080000;
        idt_addr[i * 2 + 1] = 0;
    }
    
}