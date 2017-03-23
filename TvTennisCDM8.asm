asect 0x00


# ALL OF THE BELOW WILL BE SEPERATED INTO SEPERATE SUBROUTINES.
# CURRENTLY SEPERATED BY A SERIES OF HYPHENS
# ---------------------------------------------------------------

# REPRESENTING BALL VELOCITY. PAGE 6

ldi r0,vy
ld r0,r0

ldi r1,vx
ld r1,r1

move r0,r2

shl r1
shl r1   # Rather than pad each of the two velocity components 
shl r1   # to 8 bits we combine them into one 8-bit string 
shl r1   # as follows: bits 0..2 carry vx, bits 3..5 carry vy, and
shl r1   # bits 6..7 are always set to 0.
shl r1


shl r2
shl r1
shl r2
shl r1
shl r2

ldi r3,vxy
st r3,r2

#----------------------------------------------------------------

# REFLECTING THE BALL. PAGE 7






halt

inputs>
vx: dc 0b00000101 # THIS INPUT WILL BE TAKEN FROM LOGISIM
vy: dc 0b00000111 # THIS INPUT WILL BE TAKEN FROM LOGISIM
endinputs>

vxy: ds 1

end