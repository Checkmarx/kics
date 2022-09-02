package restclient

// CustomRoute is APIRoute but custom for you
type CustomRoute struct {
	*APIRoute
}

// Compile returns a CompiledAPIRoute
func (r CustomRoute) Compile(queryValues QueryValues, args ...interface{}) (*CompiledAPIRoute, error) {
	compiledRoute, err := r.Route.Compile(queryValues, args...)
	if err != nil {
		return nil, err
	}
	return &CompiledAPIRoute{
		CompiledRoute: compiledRoute,
		method:        r.method,
	}, nil
}

// NewCustomRoute generates a new custom route struct
func NewCustomRoute(method Method, url string, queryParams ...string) *APIRoute {
	return &APIRoute{
		Route:  newRoute("", url, queryParams),
		method: method,
	}
}
