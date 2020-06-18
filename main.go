package main

import (
	"fmt"
	"encoding/json"
	"io/ioutil"
	"encoding/hex"
	"crypto/sha256"
	"strings"
)

type Timestamp struct {
	Operator string // [0]
	Prefix string   // [1]
	Postfix string  // [2]
}

// This function should walk through the timestamps and verify message against merkleRoot
// Hints: use crypto/sha256 and encoding/hex. message is big-endian while merkleRoot is little-endian.
func VerifyHash(timestamps []Timestamp, message string, merkleRoot string) bool {
	return false
}


func main(){
	msg := "b4759e820cb549c53c755e5905c744f73605f8f6437ae7884252a5f204c8c6e6"
	merkleRoot := "f832e7458a6140ef22c6bc1743f09610281f66a1b202e7b4d278b83de55ef58c"

	filePath := "./bag/timestamp.json"
	dat, err := ioutil.ReadFile(filePath)
	if err != nil {
		return
	}

	tuples := [][]string{}
	timestamps := []Timestamp{}

	// Convert byte slice to slice of tuples
	json.Unmarshal(dat, &tuples)


	if VerifyHash(timestamps, msg, merkleRoot) == true {
		fmt.Println("CORRECT!")
	} else {
		fmt.Println("INCORRECT!")
	}
}