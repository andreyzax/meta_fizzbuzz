.POSIX:
.SUFFIXES:

all: build

build: src/fizzbuzz.clang src/fizzbuzz.golang src/fizzbuzz.class src/fizzbuzz.asmlang

install: build
	ln -sf src/fizzbuzz.sh fizzbuzz.sh
	ln -sf src/fizzbuzz.rb fizzbuzz.rb
	ln -sf src/fizzbuzz.py fizzbuzz.py
	ln -sf src/fizzbuzz.js fizzbuzz.js
	ln -sf src/fizzbuzz.lua fizzbuzz.lua
	ln -sf src/fizzbuzz_java_wrapper.sh fizzbuzz.javalang
	ln -sf src/check_fizzbuzz.sh check_fizzbuzz.sh
	ln -sf src/fizzbuzz.golang fizzbuzz.golang
	ln -sf src/fizzbuzz.clang fizzbuzz.clang
	ln -sf src/fizzbuzz.asmlang fizzbuzz.asmlang

src/fizzbuzz.clang: src/fizzbuzz.c
	gcc src/fizzbuzz.c -o src/fizzbuzz.clang

src/fizzbuzz.golang: src/fizzbuzz.go
	go build -o src/fizzbuzz.golang src/fizzbuzz.go

src/fizzbuzz.class: src/fizzbuzz.java
	javac src/fizzbuzz.java

src/fizzbuzz.asmlang: src/fizzbuzz.asmlang.o
	ld -s -z noseparate-code src/fizzbuzz.asmlang.o -o src/fizzbuzz.asmlang

src/fizzbuzz.asmlang.o: src/fizzbuzz.asm
	nasm -f elf64 src/fizzbuzz.asm -o src/fizzbuzz.asmlang.o

uninstall:
	rm  fizzbuzz.* check_fizzbuzz.sh

clean:
	rm -f src/fizzbuzz.golang src/fizzbuzz.clang src/fizzbuzz.class src/fizzbuzz.asmlang src/fizzbuzz.asmlang.o
