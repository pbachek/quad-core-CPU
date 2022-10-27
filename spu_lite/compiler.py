import sys

ASM = {
    'fma'   : ('RRR', '1110'),
    'ila'   : ('RI18', '0100001'),
    'ahi'   : ('RI10', '00011101'),
    'ai'    : ('RI10', '00011100'),
    'sfhi'  : ('RI10', '00001101'),
    'sfi'   : ('RI10', '00001100'),
    'ceqi'  : ('RI10', '01111100'),
    'cgti'  : ('RI10', '01001100'),
    'clgti' : ('RI10', '01011100'),
    'mpyi'  : ('RI10', '01110100'),
    'mpyui' : ('RI10', '01110101'),
    'stqd'  : ('RI10', '00100100'),
    'lqd'   : ('RI10', '00110100'),
    'sc'    : ('RI10', '10100100'),
    'll'    : ('RI10', '10110100'),
    'ilh'   : ('RI16', '010000011'),
    'ilhu'  : ('RI16', '010000010'),
    'il'    : ('RI16', '010000001'),
    'br'    : ('RI16', '001100100'),
    'bra'   : ('RI16', '001100000'),
    'brnz'  : ('RI16', '001000010'),
    'brz'   : ('RI16', '001000000'),
    'brhnz' : ('RI16', '001000110'),
    'brhz'  : ('RI16', '001000100'),
    'stqa'  : ('RI16', '001000001'),
    'lqa'   : ('RI16', '001100001'),
    'csflt' : ('RI8', '0111011010'),
    'cflts' : ('RI8', '0111011000'),
    'shlhi' : ('RI7', '00001111111'),
    'shli'  : ('RI7', '00001111011'),
    'rothi' : ('RI7', '00001111100'),
    'roti'  : ('RI7', '00001111000'),
    'bi'    : ('RI7', '00110101000'),
    'ah'    : ('RR', '00011001000'),
    'a'     : ('RR', '00011000000'),
    'sfh'   : ('RR', '00001001000'),
    'sf'    : ('RR', '00001000000'),
    'clz'   : ('RR', '01010100101'),
    'and'   : ('RR', '00011000001'),
    'or'    : ('RR', '00001000001'),
    'xor'   : ('RR', '01001000001'),
    'nand'  : ('RR', '00011001001'),
    'nor'   : ('RR', '00001001001'),
    'ceqh'  : ('RR', '01111001000'),
    'ceq'   : ('RR', '01111000000'),
    'cgth'  : ('RR', '01001001000'),
    'cgt'   : ('RR', '01001000000'),
    'clgth' : ('RR', '01011001000'),
    'clgt'  : ('RR', '01011000000'),
    'shlh'  : ('RR', '00001011111'),
    'shl'   : ('RR', '00001011011'),
    'roth'  : ('RR', '00001011100'),
    'rot'   : ('RR', '00001011000'),
    'mpy'   : ('RR', '01111000100'),
    'mpyu'  : ('RR', '01111001100'),
    'fceq'  : ('RR', '01111000010'),
    'fcgt'  : ('RR', '01011000010'),
    'fa'    : ('RR', '01011000100'),
    'fs'    : ('RR', '01011000101'),
    'fm'    : ('RR', '01011000110'),
    'cntb'  : ('RR', '01010110100'),
    'avgb'  : ('RR', '00011010011'),
    'absdb' : ('RR', '00001010011'),
    'sumb'  : ('RR', '01001010011'),
    'nop'   : ('RR', '01000000001'),
    'gbb'   : ('RR', '00110110010'),
    'gbh'   : ('RR', '00110110001'),
    'gb'    : ('RR', '00110110000'),
    'stqx'  : ('RR', '00101000100'),
    'lqx'   : ('RR', '00111000100'),
    'lnop'  : ('RR', '00000000001'),
    'stop'  : ('RR', '00000000000')
}

asmFilename = sys.argv[1]
binFilename = asmFilename.split('.')[0] + '_bin.' + asmFilename.split('.')[1]

with open(asmFilename, 'r') as asmFile, open(binFilename, 'w') as binFile:
    for line in asmFile:
        line = line.strip()
        if line:
            lineSplit = line.split(' ', 1)
            mnemonic = lineSplit[0].strip()
            operands = []
            if len(lineSplit) > 1:
                operands = lineSplit[1].strip().split(',')
            for i in range(len(operands), 3):
                operands.append('0')
            binStr = ASM[mnemonic][1]
            if mnemonic in {'stqd', 'lqd', 'sc', 'll'}:
                binStr += '{0:010b}'.format(int(operands[1].strip(') ').split('(')[0].strip()) & 0b1111111111)
                binStr += '{0:07b}'.format(int(operands[1].strip(') ').split('(')[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
            elif mnemonic in {'br', 'bra'}:
                binStr += '{0:016b}'.format(int(operands[0].strip()) & 0b1111111111111111)
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
            elif mnemonic in {'bi'}:
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
            elif ASM[mnemonic][0] == 'RRR':
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
                binStr += '{0:07b}'.format(int(operands[2].strip('$')))
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[3].strip('$')))
            elif ASM[mnemonic][0] == 'RI18':
                binStr += '{0:018b}'.format(int(operands[1].strip()) & 0b111111111111111111)
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
            elif ASM[mnemonic][0] == 'RI10':
                binStr += '{0:010b}'.format(int(operands[2].strip()) & 0b1111111111)
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
            elif ASM[mnemonic][0] == 'RI16':
                binStr += '{0:016b}'.format(int(operands[1].strip()) & 0b1111111111111111)
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
            elif ASM[mnemonic][0] == 'RI8':
                binStr += '{0:08b}'.format(int(operands[2].strip()) & 0b11111111)
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
            elif ASM[mnemonic][0] == 'RI7':
                binStr += '{0:07b}'.format(int(operands[2].strip()) & 0b1111111)
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
            elif ASM[mnemonic][0] == 'RR':
                binStr += '{0:07b}'.format(int(operands[2].strip('$')))
                binStr += '{0:07b}'.format(int(operands[1].strip('$')))
                binStr += '{0:07b}'.format(int(operands[0].strip('$')))
                
            binFile.write(binStr + '\n')
