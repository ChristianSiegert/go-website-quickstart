package main

import (
	"log"

	"github.com/ChristianSiegert/go-website-quickstart/config"

	"github.com/ChristianSiegert/go-packages/webapps"
	flags "github.com/jessevdk/go-flags"
)

func init() {
	// Parse command-line arguments
	parser := flags.NewParser(config.Options, flags.HelpFlag)
	if _, err := parser.Parse(); err != nil {
		log.Fatalln(err)
	}
}

func main() {
	app := webapps.New(config.Options.ServerHost, config.Options.ServerPort)

	log.Println("started server at http://" + config.Options.ServerHost + ":" + config.Options.ServerPort)

	if err := app.Start(); err != nil {
		log.Fatalln(err)
	}
}
