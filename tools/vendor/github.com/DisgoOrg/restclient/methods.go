package restclient

// Method is a HTTP request Method
type Method string

// HTTP Methods used by Discord
const (
	DELETE Method = "DELETE"
	GET    Method = "GET"
	POST   Method = "POST"
	PUT    Method = "PUT"
	PATCH  Method = "PATCH"
)

func (m Method) String() string {
	return string(m)
}
