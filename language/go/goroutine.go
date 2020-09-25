/*
 * @Author: mazhuang
 * @Date: 2020-09-08 11:50:50
 * @LastEditTime: 2020-09-08 11:55:50
 * @Description:
 */
package main

import (
	"fmt"
	"time"
)

func main() {
	go func() {
		fmt.Println("father alive")

		go func() {
			time.Sleep(time.Second * 2)
			for i := 0; i < 5; i++ {
				fmt.Println("child alive", i)
			}
		}()
		defer fmt.Println("father dead")
		return
	}()
	time.Sleep(time.Second * 3)
}
