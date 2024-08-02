V65C816 General Purpose 16 Bit Microprocessor
Design by: Valerio Venturi (valerioventuri@gmail.com)

The V65C816 is a VHDL RTL softcore 100% software compatible with the original silicon

WDC65C816 CPU but with some new instructions:

• two fast multiply 16X16-32 bit instructions

• multitasking context save and restore fast instructions

• two fast save and restore AXY instruction

• register exchange instructions

• Improved execution time for some instructions and addressing modes.

• All the two bytes unused opcodes are treated as NOPs.


New Opcodes:

PHR (0x42/0x8B) PusH Registers push C,X,Y to stack (flags: unaffected)

PLR (0x42/0xAB) PulL Registers C,X,Y in reversed order from stack (flags: unaffected)

SAV (0x42/0x90) (SAVE) push C,X,Y,P,PBR,D to stack (flags: unaffected)

RST (0x42/0x91) (RESTORE) pull C,X,Y,P,PBR,D in reversed order from stack (flags: all)

MPU (0x42/0x8E) MultiPly Unsigned 16X16->32 bit (flags: Z)

MPS (0x42/0x8F) MultiPly Signed 15X15->31 bit (with sign) (flags: NZ)

XYX (0x42/0xEB) eXchange Y and X (flags: unaffected)

XAX (0x42/0x0B) eXchange A and X (flags: unaffected)

XAY (0x42/0x2B) eXchange A and Y (flags: unaffected)

EXT (0x42/0xEC) EXTends sign of accumulator A to B

NEG (0x42/0xED) NEGates contents of accumulator

NOTE: all new instructions listed above must be preceded by a WDM (0x42) opcode

https://opencores.org/projects/v65c816

License: LGPL

