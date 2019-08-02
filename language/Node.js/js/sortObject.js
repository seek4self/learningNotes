var list = [
    { name: "zhangsan", id: "45" },
    { name: "bocai", id: "21" },
    { name: "qingyi", id: "33" }
];
//定义一个函数
function compare(pro) {
    return function (obj1, obj2) {
        var val1 = obj1[pro];
        var val2 = obj2[pro];
        console.log(val1, val2)
        return val2 - val1;
        if (val1 < val2) { //正序
            return 1;
        } else if (val1 > val2) {
            return -1;
        } else {
            return 0;
        }
    }
}
//使用方法 
list.sort(compare("id"));
console.log(list);