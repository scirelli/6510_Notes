#!/usr/bin/env node
const fs = require('fs');
const readline = require('readline');

var fileName = 'out.bin',
    stream = null;

switch(process.argv[2]) {
    case '-f':
    case '--file':
        fileName = process.argv[3];
        stream = fs.createWriteStream(fileName, {encoding: 'binary'});
        break;
    default:
        stream = fs.createWriteStream(fileName);
}

const rl = readline.createInterface({
    input:    process.stdin,
    output:   process.stdout,
    terminal: false
});

const PETSCII2ASCII = (new Array(256)).fill('\0');

PETSCII2ASCII[13] = '\n';
PETSCII2ASCII[32] = ' ';
PETSCII2ASCII[33] = '!';
PETSCII2ASCII[34] = '"';
PETSCII2ASCII[35] = '#';
PETSCII2ASCII[36] = '$';
PETSCII2ASCII[37] = '%';
PETSCII2ASCII[38] = '&';
PETSCII2ASCII[39] = '\'';
PETSCII2ASCII[40] = '(';
PETSCII2ASCII[41] = ')';
PETSCII2ASCII[42] = '*';
PETSCII2ASCII[43] = '+';
PETSCII2ASCII[44] = ',';
PETSCII2ASCII[45] = '–';
PETSCII2ASCII[46] = '.';
PETSCII2ASCII[47] = '/';
PETSCII2ASCII[48] = '0';
PETSCII2ASCII[49] = '1';
PETSCII2ASCII[50] = '2';
PETSCII2ASCII[51] = '3';
PETSCII2ASCII[52] = '4';
PETSCII2ASCII[53] = '5';
PETSCII2ASCII[54] = '6';
PETSCII2ASCII[55] = '7';
PETSCII2ASCII[56] = '8';
PETSCII2ASCII[57] = '9';
PETSCII2ASCII[58] = ':';
PETSCII2ASCII[59] = ';';
PETSCII2ASCII[60] = '<';
PETSCII2ASCII[61] = '=';
PETSCII2ASCII[62] = '>';
PETSCII2ASCII[63] = '?';
PETSCII2ASCII[64] = '@';
PETSCII2ASCII[65] = 'A';
PETSCII2ASCII[66] = 'B';
PETSCII2ASCII[67] = 'C';
PETSCII2ASCII[68] = 'D';
PETSCII2ASCII[69] = 'E';
PETSCII2ASCII[70] = 'F';
PETSCII2ASCII[71] = 'G';
PETSCII2ASCII[72] = 'H';
PETSCII2ASCII[73] = 'I';
PETSCII2ASCII[74] = 'J';
PETSCII2ASCII[75] = 'K';
PETSCII2ASCII[76] = 'L';
PETSCII2ASCII[77] = 'M';
PETSCII2ASCII[78] = 'N';
PETSCII2ASCII[79] = 'O';
PETSCII2ASCII[80] = 'P';
PETSCII2ASCII[81] = 'Q';
PETSCII2ASCII[82] = 'R';
PETSCII2ASCII[83] = 'S';
PETSCII2ASCII[84] = 'T';
PETSCII2ASCII[85] = 'U';
PETSCII2ASCII[86] = 'V';
PETSCII2ASCII[87] = 'W';
PETSCII2ASCII[88] = 'X';
PETSCII2ASCII[89] = 'Y';
PETSCII2ASCII[90] = 'Z';
PETSCII2ASCII[91] = '[';
PETSCII2ASCII[92] = '£';
PETSCII2ASCII[93] = ']';
PETSCII2ASCII[94] = '↑';
PETSCII2ASCII[95] = '←';
PETSCII2ASCII[96] = '─';
PETSCII2ASCII[97] = '♠';
PETSCII2ASCII[98] = '│';
PETSCII2ASCII[99] = '─';
PETSCII2ASCII[105] = '╮';
PETSCII2ASCII[106] = '╰';
PETSCII2ASCII[107] = '╯';
PETSCII2ASCII[109] = '╲';
PETSCII2ASCII[110] = '╱';
PETSCII2ASCII[113] = '●';
PETSCII2ASCII[115] = '♥';
PETSCII2ASCII[117] = '╭';
PETSCII2ASCII[118] = '╳';
PETSCII2ASCII[119] = '○';
PETSCII2ASCII[120] = '♣';
PETSCII2ASCII[122] = '♦';
PETSCII2ASCII[123] = '┼';
PETSCII2ASCII[125] = '│';
PETSCII2ASCII[126] = 'π';
PETSCII2ASCII[127] = '◥';
PETSCII2ASCII[161] = '▌';
PETSCII2ASCII[162] = '▄';
PETSCII2ASCII[163] = '▔';
PETSCII2ASCII[164] = '▁';
PETSCII2ASCII[165] = '▏';
PETSCII2ASCII[166] = '▒';
PETSCII2ASCII[167] = '▕';
PETSCII2ASCII[169] = '◤';
PETSCII2ASCII[171] = '├';
PETSCII2ASCII[172] = '▗';
PETSCII2ASCII[173] = '└';
PETSCII2ASCII[174] = '┐';
PETSCII2ASCII[175] = '▂';
PETSCII2ASCII[176] = '┌';
PETSCII2ASCII[177] = '┴';
PETSCII2ASCII[178] = '┬';
PETSCII2ASCII[179] = '┤';
PETSCII2ASCII[180] = '▎';
PETSCII2ASCII[181] = '▍';
PETSCII2ASCII[185] = '▃';
PETSCII2ASCII[187] = '▖';
PETSCII2ASCII[188] = '▝';
PETSCII2ASCII[189] = '┘';
PETSCII2ASCII[190] = '▘';
PETSCII2ASCII[191] = '▚';
PETSCII2ASCII[192] = '━';
PETSCII2ASCII[193] = '♠';
PETSCII2ASCII[194] = '│';
PETSCII2ASCII[195] = '━';
PETSCII2ASCII[201] = '╮';
PETSCII2ASCII[202] = '╰';
PETSCII2ASCII[203] = '╯';
PETSCII2ASCII[205] = '╲';
PETSCII2ASCII[206] = '╱';
PETSCII2ASCII[209] = '●';
PETSCII2ASCII[211] = '♥';
PETSCII2ASCII[213] = '╭';
PETSCII2ASCII[214] = '╳';
PETSCII2ASCII[215] = '○';
PETSCII2ASCII[216] = '♣';
PETSCII2ASCII[218] = '♦';
PETSCII2ASCII[219] = '┼';
PETSCII2ASCII[221] = '│';
PETSCII2ASCII[222] = 'π';
PETSCII2ASCII[223] = '◥';
PETSCII2ASCII[224] = '[';
PETSCII2ASCII[225] = '▌';
PETSCII2ASCII[226] = '▄';
PETSCII2ASCII[227] = '▔';
PETSCII2ASCII[228] = '▁';
PETSCII2ASCII[229] = '▏';
PETSCII2ASCII[230] = '▒';
PETSCII2ASCII[231] = '▕';
PETSCII2ASCII[233] = '◤';
PETSCII2ASCII[235] = '├';
PETSCII2ASCII[236] = '▗';
PETSCII2ASCII[237] = '└';
PETSCII2ASCII[238] = '┐';
PETSCII2ASCII[239] = '▂';
PETSCII2ASCII[240] = '┌';
PETSCII2ASCII[241] = '┴';
PETSCII2ASCII[242] = '┬';
PETSCII2ASCII[243] = '┤';
PETSCII2ASCII[244] = '▎';
PETSCII2ASCII[245] = '▍';
PETSCII2ASCII[249] = '▃';
PETSCII2ASCII[251] = '▖';
PETSCII2ASCII[252] = '▝';
PETSCII2ASCII[253] = '┘';
PETSCII2ASCII[254] = '▘';

const ASSCII2PETSCII = PETSCII2ASCII.reduce((a, v, i)=>{
    if(v.charCodeAt(0) > 255) return a;
    a[v.charCodeAt(0)] = String.fromCharCode(i);
    return a;
}, (new Array(256)).fill('\0'));


rl.on('line', function(line) {
    let b = Uint8Array.from(line.split('').map(s=>s.charCodeAt(0)).map(c=>{
        if(c >= 'a'.charCodeAt(0) && c <= 'z'.charCodeAt(0)) c -= 32;
        return ASSCII2PETSCII[c].charCodeAt(0);
    }).map(toLittleEdian8));
    stream.write(Buffer.from(b), 'binary');
});

function toLittleEdian8(byte) {
    return ((byte & 0xF0) >> 4) + ((byte & 0x0F) << 4);
}

// function toLittleEdian16(out, word, index) {
//     let hib, lob;

//     hib = (word & 0xFF00) >> 8;
//     hib = ((hib & 0xF0) >> 4) + ((hib & 0x0F) << 4);


//     lob = word & 0x00FF;
//     lob = ((lob & 0xF0) >> 4) + ((lob & 0x0F) << 4);

//     index *= 2;
//     out[index]= lob;
//     out[index+1] = hib;
//     return out;
// }
