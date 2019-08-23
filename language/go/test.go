package main

import (
	"fmt"
	// "errors"
	"encoding/json"
)

type Message struct {
    Name string
    Body string
    Time int64
}

func main() {
	fmt.Printf("hello, world\n");
	var f float32 = 16777216;
	fmt.Printf("f = %f\n", f+2);
	fmt.Println(f == f+1);

	m := Message{"Alice", "Hello", 1294706395881547000}
	b, _ := json.Marshal(m) 
	fmt.Println(b) 
}