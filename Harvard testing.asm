asect 0x00
ldi r2,0xF8 #Read Input data
ld r2,r2

ldi r3,0xFA
st r3,r2

halt
asect 0xFA

end