/*
 * @Author: mazhuang
 * @Date: 2019-08-15 18:13:09
 * @LastEditTime: 2019-08-15 18:13:09
 * @Description: 
 */
/**
 * @description 获取随机整数，介于 0～max 
 * @param {*} max 上限区间
 */
function getRandom(max) {
    return Math.floor(Math.random() * max);
}

/**
 * @description 获取随机整数数组，元素之和为total
 * @param {*} num 数组元素个数减1
 * @param {*} total 数组之和
 * 等同于与将一线段分为10端，求每段长度
 */
function getRandomArr(num, total) {
    let temp = [];
    for (let i = 0; i < num; i++) {
        temp.push(getRandom(total));
    }
    temp.push(0);
    temp.push(total);
    temp.sort((a, b) => a - b);
    // console.log(arr);
    let arr = [];
    for (let i = 0; i < temp.length - 1; i++) {
        arr.push(temp[i + 1] - temp[i])
    }
    return arr;
}