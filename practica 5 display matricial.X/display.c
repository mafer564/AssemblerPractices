





// RAM PIC16F877A limited.

char data[27][5] = {

{0x00, 0x00, 0x00, 0x00, 0x00}, // &#39; &#39;

{0x7C, 0x12, 0x11, 0x12, 0x7C}, // A

{0x7F, 0x49, 0x49, 0x49, 0x36}, // B

{0x3E, 0x41, 0x41, 0x41, 0x22}, // C

{0x7F, 0x41, 0x41, 0x41, 0x3E}, // D

{0x7F, 0x49, 0x49, 0x49, 0x41}, // E

};
void main(){

short int i,d,r,c,e,n,m,q;

//************************************************************************

//Display ABCDEFGHI in three different modes

//1. Moving from Right

//2. Blinking

//3. Moving from Left

char string1[] = &quot;MACAM MACAM&quot;;

short int s1_length = 11; //s1_length is 10 include one space after I

char string2[] = &quot;BEDAK&quot;;

short int s2_length = 5; //s1_length is 10 include one space after I

char string3[] = &quot;NOFELET&quot;;

short int s3_length = 7; //s1_length is 10 include one space after I

// Initialize PIC system

TRISA = 0; // PORTA is digital output

PORTA = 0; // initialize PORTA

TRISB = 0; // PORTB is digital output

PORTB = 0; // initialize PORTB

TRISC = 0; // PORTC is digital output
PORTC = 0; // initialize PORTC

TRISD = 0; // PORTC is digital output

PORTD = 0; // initialize PORTC

ADCON1 = 0x0F; // Turn off PORTA analog inputs

while(1){ //Always looping

//************************************************************************

//Moving from Right and Out

//for (i=0;i&lt;s1_length;i++){

// map undefined bitmap characters to &#39; &#39;

//if ((string1[i] &lt; 64)||(string1[i] &gt; 90)) string1[i] = 64;

// map defined ASCII character codes to bitmap lookup table

//r = string1[i] - 64;

// d determins duration of character display @ d * 10ms

//n=0b00000001; //IN first matrix

//for(e=0;e&lt;5;e++){

//for (d=0;d&lt;10;d++){

//PORTB = n;

//for (c=0;c&lt;5;c++){

//PORTD = data[r][c];Delay_ms(1); // 2 ms delay

//PORTB = PORTB &gt;&gt; 1;

//}

//}n = n &lt;&lt; 1;

//}

//n=0b00000010; //OUT first matrix

//for(e=0;e&lt;5;e++){

//for (d=0;d&lt;10;d++){

//PORTB = n;

//for (c=0;c&lt;5;c++){

//PORTD = data[r][4-c];Delay_ms(1); // 2 ms delay

//PORTB = PORTB &lt;&lt; 1;

//}

//}n = n &lt;&lt; 1;

//}

//}

//************************************************************************

//Blinking

for (i=0;i&lt;s2_length;i++){

// map undefined bitmap characters to &#39; &#39;

if ((string2[i] &lt; 64)||(string2[i] &gt; 90)) string2[i] = 64;

// map defined ASCII character codes to bitmap lookup table

r = string2[i] - 64;

// d determins duration of character display @ d * 10ms

n=0b00010000; //IN first matrix

for(e=0;e&lt;5;e++){

for (d=0;d&lt;10;d++){ //d is display timing

PORTB = n;

for (c=0;c&lt;5;c++){

PORTD = data[r][c];Delay_ms(1); // 2 ms delay

PORTB = PORTB &gt;&gt; 1;

//Delay_ms(1);

}

}//n = n &lt;&lt; 1;

}

}

//************************************************************************

//Moving from Left and Out

//for (i=0;i&lt;s3_length;i++){

// map undefined bitmap characters to &#39; &#39;

//if ((string3[i] &lt; 64)||(string3[i] &gt; 90)) string3[i] = 64;

// map defined ASCII character codes to bitmap lookup table

//r = string3[i] - 64;

// d determins duration of character display @ d * 10ms

//n=0b00010000; //IN first matrix

//for(e=0;e&lt;5;e++){

//for (d=0;d&lt;20;d++){

//PORTB = n;

//for (c=0;c&lt;5;c++){

//PORTD = data[r][4-c];Delay_ms(1); // 2 ms delay

//PORTB = PORTB &lt;&lt; 1;

//}

//}n = n &gt;&gt; 1;

//}

//n=0b00001000; //OUT first matrix

//for(e=0;e&lt;5;e++){

//for (d=0;d&lt;20;d++){

//PORTB = n;

//for (c=0;c&lt;5;c++){

//PORTD = data[r][c];Delay_ms(1); // 2 ms delay

//PORTC = PORTB &gt;&gt; 1;

//}

//}n = n &gt;&gt; 1;

//}

//}

//} //End of while looping

//} //End of main looping