package main

import "fmt"

func main() {
	fmt.Printf("hello, world\n");
	var f float32 = 16777216;
	fmt.Printf("f = %f", f+2);
	fmt.Println(f == f+1);
}