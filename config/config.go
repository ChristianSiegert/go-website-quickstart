package config

// Options defines command-line options. Values are available after command-line
// arguments have been parsed in `init` in main.go. For documentation on how to
// write command-line options, see <https://godoc.org/github.com/jessevdk/go-flags>.
var Options = &struct {
	ServerHost string `default:"localhost" description:"Network interface on which the web server listens." long:"server-host"`
	ServerPort string `default:"8080" description:"Port on which the web server listens." long:"server-port"`
}{}
