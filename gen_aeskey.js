const crypto = require('crypto');

const key = crypto.randomBytes(32);
const out = [];

for (let i = 0; i < 32; i++) {
    out.push(key.readUIntBE(i, 1));
}

console.log(out.join(', '));
