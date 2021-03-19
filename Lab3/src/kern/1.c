#include "1.h"
#define USER_1 16
#define USER_2 19
#define USER_3 22
#define USER_4 25
#define NUM_OF_PROGRAM 4

/* Compare two string 
** 0 for same, -1 for not the same  
*/
int StrCmp(char *str1, char *str2, unsigned int n) {
    for (int i = 0; i < n; ++i) {
        if (str1[i] != str2[i])
            return -1;
    }
    return 0;
}

/* 指明要加载的用户程序扇区号和所需扇区数 */
void LoadUserProgram(unsigned int sec_no, unsigned int num_of_sec) {
    void *user_code_addr = 0x400000;
    readsect(user_code_addr, sec_no, num_of_sec);   /* 加载用户程序到内存里 */
    __asm__("call %0\n\t"
            :
            : "r"(user_code_addr)
            :
    );
}

void Welcoming() {    
    char *program_name[] = {"1.com", "2.com", "3.com", "4.com"};
    char str[32];
    CurPosition init_pos = {0, 0};
    SetCurPos(init_pos);
    
    unsigned char *vga_addr = 0xb8000;
    for (int i = 0; i < 25 * 80; ++i) {
        vga_addr[2 * i] = 0x20;               /* 设置青色背景 */
        vga_addr[2 * i + 1] = 0x30;
    }

    puts("Hello this is ouyhlan's monitor program! The following programs which you can use: ");
    putc('\n');
    
    for (int i = 0; i < NUM_OF_PROGRAM; ++i) {
        puts(program_name[i]);
        putc('\n');
    }

    while (1) {
        puts("Os1> ");
        gets(str);
        
        int program_id = 0;
        if (StrCmp(str, "1.com", 4) == 0) {
            program_id = 1;
        }
        else if (StrCmp(str, "2.com", 4) == 0) {
            program_id = 2;
        }
        else if (StrCmp(str, "3.com", 4) == 0) {
            program_id = 3;
        }
        else if (StrCmp(str, "4.com", 4) == 0) {
            program_id = 4;
        }
        else if (StrCmp(str, "exit", 4) == 0) {
            puts("\n[System exits normally!]\n");
            break;
        }
        else {
            puts("Wrong input! Please enter again!\n");
            continue;
        }

        switch (program_id) {
        case 1:
            LoadUserProgram(USER_1, 3);
            break;
        case 2:
            LoadUserProgram(USER_2, 3);
            break;
        case 3:
            LoadUserProgram(USER_3, 3);
            break;
        case 4:
            LoadUserProgram(USER_4, 3);
            break;
        default:
            /* Do nothing */;
        }
    }
    //gets(str);
    //putc('\n');
    //puts(str);
}   