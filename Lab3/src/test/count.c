/* 统计字符ch在字符串str出现的次数 */
unsigned long long Count(char ch, char *str) {
    int i = 0, res = 0;;
    while (str[i] != '\0') {
        if (str[i++] == ch) {
            res++;
        }
    }
    return res;
}