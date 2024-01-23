package main

import "errors"

type User struct {
	Email string
	Name  string
	Age   uint
}

func foo() {
	foo := "bar"
}

func NewUser(name string, email string, age uint) (User, error) {
	if age < 13 || age > 120 {
		return User{}, errors.New("Not correct")
	}

	if name == "" {
		return User{}, errors.New("name is empty")
	}

	return User{
		Email: email,
		Name:  name,
		Age:   age,
	}, nil
}
