package restclient

// APIRoute is a basic struct containing Method and URL
type APIRoute struct {
	*Route
	method Method
}

// Compile returns a CompiledAPIRoute
func (r *APIRoute) Compile(queryValues QueryValues, args ...interface{}) (*CompiledAPIRoute, error) {
	compiledRoute, err := r.Route.Compile(queryValues, args...)
	if err != nil {
		return nil, err
	}
	return &CompiledAPIRoute{
		CompiledRoute: compiledRoute,
		method:        r.method,
	}, nil
}

// Method returns the request method used by the route
func (r *APIRoute) Method() Method {
	return r.method
}

// NewAPIRoute generates a new discord api route struct
func NewAPIRoute(method Method, url string, queryParams ...string) *APIRoute {
	return &APIRoute{
		Route:  newRoute(API, url, queryParams),
		method: method,
	}
}

// CompiledAPIRoute is APIRoute compiled with all URL args
type CompiledAPIRoute struct {
	*CompiledRoute
	method Method
}

// Method returns the request method used by the route
func (r *CompiledAPIRoute) Method() Method {
	return r.method
}
