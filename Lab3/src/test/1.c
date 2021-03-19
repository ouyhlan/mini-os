char Message[10]="AaBbCcDdEe";   
       /*变量_Message,初值为AaBbCcDdEe*/
char *upper(int a, int b, int c, int d, int e, int f){
    a++;
    b++;
    c++;
    d++;
    e++;
    f++;
    int i=0;
    while(Message[i]) {
        if (Message[i]>='a'&&Message[i]<='z')  
                Message[i]=Message[i]+'A'-'a';
        i++;
    }
    return Message;
}
