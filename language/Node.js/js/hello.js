const hello = require('./test');

const h = new hello();

h.set('123');
console.log(h.get());