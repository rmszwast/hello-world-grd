package main

import "net/http"

func main(){
	fs := http.FileServer(http.Dir("../../client/build"))
	http.Handle("/", fs)
	http.ListenAndServe(":8000", nil)
}
