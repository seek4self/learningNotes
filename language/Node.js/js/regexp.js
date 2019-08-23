const mobileReg = /^((\+|00)86)?1([358][0-9]|4[579]|6[67]|7[0135678]|9[189])[0-9]{8}$/;
const contentReg = /^([0-9]|[-])+$/g;
const telephoneReg = /^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/;


// console.log(unionReg)

console.log(telephoneReg.test('010-88888888'))
console.log(contentReg.test('155-1234-5678'))