const obj = {
    asd: "ds",
    zxc: "sdf",
    sd: "sdf"
};
delete obj.asd
console.log(obj);


// 生成6位随机数验证码
console.log(Math.random().toString().slice(-6));

function hello() {
    let field;
    this.set = (name) => {
        field = name;
    }

    this.get = () => {
        return field
    }
}

function print()

module.exports = hello;