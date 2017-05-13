
# F8 keyboard
# F9 
# FA lpad
# FB rpad
# FC lscore
# FD rscore
# FE ballx
# FF bally
#
#
#
# D8 keyboard-codev
# D9 
# DA lpad-codev
# DB rpad-codev
# DC lscore-codev
# DD rscore-codev
# DE ballx-codev
# DF bally-codev
#
#
# E0 Direction
# E1 XSpeed: dc 4
# E2 YAngle: dc 0
# E3 initialBallPositionX: dc 128
# E4 initialBallPositionY: dc 128
# E5 initialPaddlePosition: dc 128
#
# 


asect 0x00


ldi r0,15
ldi r1,0xE1
st r1,r0
ldi r1,0xE2
st r1,r0
ldi r0,128
ldi r1,0xE3
st r1,r0
ldi r1,0xE4
st r1,r0
ldi r1,0xE5
st r1,r0
#-----------------------------MAIN-----------------------------------

reset:

br scoreboardReset
#jsr ballReset
#jsr paddleReset



main0:



br checkIfScore
#jsr initialHitDetect
#jsr paddleShift
#jsr ballMoveStart
br main0






#---------------------------SCOREBOARD--------------------------------

checkIfScore:

ldi r0,0xDE
ld r0,r0
ldi r1,0  ## needs rework
cmp r0,r1
#beq scoreLeft
ldi r1,255  ## needs rework
cmp r0,r1
#beq scoreRight
br initialHitDetect

#scoreLeft:

#ldi r0,0xDD
#ld r0,r1
#inc r1
#st r0,r1
#ldi r0,0xFD
#st r0,r1
#rts


#scoreRight:

#ldi r0,0xDC
#ld r0,r1
#inc r1
#st r0,r1
#ldi r0,0xFC
#st r0,r1
#rts


scoreboardReset:

ldi r0,0xDC
ld r0,r0
ldi r1,0
st r0,r1
ldi r0,0xFC
st r0,r1
ldi r0,0xDD
ld r0,r0
st r0,r1
ldi r0,0xFD
st r0,r1

br ballReset




#-----------------------------BALL----------------------------------------


ballReset:

ldi r0,0xDE
ldi r1,initialBallPositionX
ldc r1,r1
st r0,r1
ldi r0,0xFE
st r0,r1
ldi r0,0xDF
ldi r1,initialBallPositionY
ldc r1,r1
st r0,r1
ldi r0,0xFF
st r0,r1
br paddleReset

ballMoveStart:


ldi r2,0xE0
ld r2,r2
clr r3
ldi r0,0xE1
ld r0,r0
ldi r1,0xE2
ld r1,r1
cmp r2,r3
beq ballMove
neg r0
br ballMove


ballMove:


ldi r2,0xDE # load x coord ball
ld r2,r3
add r3,r0
st r2,r0  # store new x coord
ldi r2,0xFE
st r2,r0

ldi r2,0xDF # load y coord
ld r2,r3
add r3,r1
st r2,r1 # st new coord
ldi r2,0xFF
st r2,r1
br main0



#---------------------HIT DETECTION-------------------------------

initialHitDetect:

ldi r0,0xDE
ld r0,r0

ldi r1,1         #*********** check 
cmp r0,r1
beq hitDetectLoadL
ldi r1,254    # check if ball is one away from board edge
cmp r0,r1
beq hitDetectLoadR
br paddleShift




hitDetectLoadL:

ldi r0,0xDA
ld r0,r0
br hitDetect


hitDetectLoadR:

ldi r0,0xDB
ld r0,r0
br hitDetect



hitDetect:

ldi r2,0xDF
ld r2,r2
ldi r1,8
sub r2,r1
add r1,r2 # get both sides of paddle

cmp r0,r1 # if ball is higher than lowest part of paddle, continue
bhi secondCheck
br paddleShift
secondCheck:
cmp r0,r2 # if ball is lower than top of paddle, continue
blo hitDetected
br paddleShift
hitDetected:
ldi r0,0xE0
ld r0,r1
not r1
st r0,r1
br paddleShift



#----------------------PADDLE-------------------------------------


paddleReset:

ldi r0,0xDA 
ldi r2,0xDB
ldi r1,initialPaddlePosition
ldc r1,r1
st r0,r1
st r2,r1
ldi r0,0xFA
ldi r2,0xFB
st r0,r1
st r2,r1
br main0




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

	ldi r0,0xDA # load paddle position
	ld r0,r1
	st r0,r1
	ldi r0,0xFA
	st r0,r1
	br ballMoveStart
	
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
	ldi r0,0xDA
	st r0,r3 # store new paddle middle position in 0xFA
	ldi r0,0xFA
	st r0,r3
	br ballMoveStart

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
	ldi r0,0xDA
	st r0,r3 # store new paddle middle position in 0xFA
	ldi r0,0xFA
	st r0,r3
	br ballMoveStart




#----------------VARIABLES----------------------------------




halt



initialBallPositionX: dc 128
initialBallPositionY: dc 128
initialPaddlePosition: dc 128

end









