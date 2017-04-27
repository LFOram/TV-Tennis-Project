
# F8 keyboard
# F9 
# FA lpad
# FB rpad
# FC lscore
# FD rscore
# FE ballx
# FF bally


# 


asect 0x00

#-----------------------------MAIN-----------------------------------

reset:

jsr scoreboardReset
#jsr ballReset
#jsr paddleReset



main0:

jsr checkIfScore
ldi r0,direction # load current direction of b
ld r0,r0
ldi r1,0
cmp r1,r0
beq ballLeft
ldi r1,1
cmp r1,r0
beq ballRight

main1:

jsr paddleShift
br main0






#---------------------------SCOREBOARD--------------------------------

checkIfScore:

ldi r0,0xFE
ld r0,r0
ldi r1,0
cmp r0,r1
beq scoreLeft
ldi r1,255
cmp r0,r1
beq scoreRight
rts

scoreLeft:

ldi r0,0xFD
ld r0,r1
inc r1
st r0,r1
rts


scoreRight:

ldi r0,0xFC
ld r0,r1
inc r1
st r0,r1
rts


scoreboardReset:

ldi r0,0xFC
ld r0,r0
ldi r1,0
st r0,r1
ldi r0,0xFD
ld r0,r0
st r0,r1
rts




#-----------------------------BALL----------------------------------------


ballReset:

ldi r0,0xFE
ldi r1,initialBallPositionX
ld r1,r1
st r0,r1
ldi r0,0xFF
ldi r1,initialBallPositionY
ld r1,r1
st r0,r1
rts

ballMove:

ldi r0,0xFE
ld r0,r0
ldi r1,0xFF
ld r1,r1
ldi r2,direction
ld r2,r2
clr r3
cmp r2,r3
beq ballRight
br ballLeft


ballRight:

ldi r0,XSpeed
ld r0,r0
ldi r1,YAngle
ld r1,r1

ldi r2,0xFE # load x coord ball
ld r2,r2
add r2,r0
st r2,r0  # store new x coord

ldi r2,0xFF # load y coord
ld r2,r2
add r2,r1
st r2,r1 # st new coord
br main1



ballLeft:

ldi r0,XSpeed 
ld r0,r0
neg r0
ldi r1,YAngle
ld r1,r1


ldi r2,0xFE # load x coord ball
ld r2,r2
add r2,r0
st r2,r0 # st new x coord

ldi r2,0xFF # load y coord ball
ld r2,r2
add r2,r1
st r2,r1 # st new y coord
br main1


#----------------------PADDLE-------------------------------------


paddleReset:

ldi r0,0xFA 
ldi r2,0xFB
ldi r1,initialPaddlePosition
st r0,r1
st r2,r1
rts 




paddleShift:

ldi r0,0xF8 # load keyboard input
ld r0,r0


ldi r1,0 # 0 = noinput
ldi r2,1 # 1 = up
ldi r3,2 # 2 = down

cmp r0,r1
beq noMove
cmp r0,r2
beq upInput
cmp r0,r3
beq downInput

	noMove:

	ldi r0,0xFA # load paddle position
	ld r0,r1
	st r0,r1
	rts
	
	upInput:
	
	ldi r0,0xFA # load paddle position
	ld r0,r0 #  load paddle
	ldi r2,8 # load 8
	add r2,r0 # inc 8 times
	move r0,r3 # copy current middle bit to r3 to use as comparison
	add r2,r0 # find top paddle position
	ldi r1,255 # load max board 0,255
	cmp r0,r1 # compare top paddle> max board
	bhi noMove # if it is bigger, then dont move the board
	ldi r0,0xFA
	st r0,r3 # store new paddle middle position in 0xFA
	rts

	downInput:

	ldi r0,0xFA # load paddle position
	ld r0,r0 #  load paddle
	ldi r2,-8 # load -8
	add r2,r0 # dec 8 times
	move r0,r3 # copy current middle bit to r3 to use as comparison
	add r2,r0 # find bottom paddle position
	ldi r1,0 # load lowest board 0,0
	cmp r0,r1 # compare top paddle> max board
	blo noMove # if it is bigger, then dont move the board
	ldi r0,0xFA
	st r0,r3 # store new paddle middle position in 0xFA
	rts




#----------------VARIABLES----------------------------------




halt



initialBallPositionX: dc 128
initialBallPositionY: dc 128
initialPaddlePosition: dc 128
XSpeed: dc 4
YAngle: dc 0
direction: dc 0

end









