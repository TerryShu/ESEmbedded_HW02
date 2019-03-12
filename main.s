.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	mov r0, #0
	mov r1, #1
	mov r2, #2

	// normal
	push {r0,r1,r2}
	pop {r3,r4,r5}

	// change push order
	push {r1,r0,r2}
	pop {r3,r4,r5}

	// change pop order
	push {r0,r1,r2}
	pop {r4,r3,r5}

	// change both push and pop order
	push {r1,r0,r2}
	pop {r4,r3,r5}

	// push step by step
	push {r1}
	push {r0}
	push {r2}
	pop {r3,r4,r5}