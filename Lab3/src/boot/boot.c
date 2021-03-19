typedef struct uint64_t {
    long s1, s2;
} uint64_t;

typedef union ptr2data {
    uint64_t *ptr;
    int data;
} ptr2data;

uint64_t GetEntry(ptr2data addr) {
    uint64_t res;
    res.s2 = 0;
    res.s1 = 0 | (addr.data & 0xfffff000) | 0x27;
    return res;
}

/* PML-4 in 0x100000 PDPT in 0x200000 PDT in 0x300000 PT in 0x400000 */
void SetupPageTable() {
    uint64_t *PML_4 = 0x100000;
    uint64_t *PDPT_1 = 0x200000;
    uint64_t *PDPT_2 = 0x300000;
    uint64_t *PDT_1 = 0x400000;
    uint64_t *PDT_2 = 0x500000;
    uint64_t *PT_1 = 0x600000;
    uint64_t *PT_2 = 0x700000;

    uint64_t *page1 = 0x800000;
    uint64_t *page2 = 0x900000;

    /* Setting page table */
    PML_4[511] = GetEntry((ptr2data)PDPT_1);
    PDPT_1[0] = GetEntry((ptr2data)PDT_1);
    PDT_1[0] = GetEntry((ptr2data)PT_1);
    PT_1[0] = GetEntry((ptr2data)page1);

    PML_4[0] = GetEntry((ptr2data)PDPT_2);
    PDPT_2[0] = GetEntry((ptr2data)PDT_2);
    PDT_2[0] = GetEntry((ptr2data)PT_2);
    PT_2[0] = GetEntry((ptr2data)page2);
} 