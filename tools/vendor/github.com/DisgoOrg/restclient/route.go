package restclient

import (
	"errors"
	"fmt"
	"net/url"
	"strconv"
	"strings"
)

// QueryValues is used to supply query param value pairs to Route.Compile
type QueryValues map[string]interface{}

func newRoute(baseRoute string, url string, queryParams []string) *Route {
	params := map[string]struct{}{}
	for _, param := range queryParams {
		params[param] = struct{}{}
	}
	return &Route{
		baseRoute:     baseRoute,
		route:         url,
		queryParams:   params,
		urlParamCount: countURLParams(url),
	}
}

// Route the base struct for routes used in disgo
type Route struct {
	baseRoute     string
	route         string
	queryParams   map[string]struct{}
	urlParamCount int
}

// Compile builds a full request URL based on provided arguments
func (r *Route) Compile(queryValues QueryValues, args ...interface{}) (*CompiledRoute, error) {
	if len(args) != r.urlParamCount {
		return nil, errors.New("invalid amount of arguments received. expected: " + strconv.Itoa(len(args)) + ", received: " + strconv.Itoa(r.urlParamCount))
	}
	route := r.route
	if len(args) > 0 {
		for _, arg := range args {
			start := strings.Index(route, "{")
			end := strings.Index(route, "}")
			route = route[:start] + fmt.Sprint(arg) + route[end+1:]
		}
	}

	compiledRoute := r.baseRoute + route
	queryParamsStr := ""
	if queryValues != nil {
		query := url.Values{}
		for param, value := range queryValues {
			if _, ok := r.queryParams[param]; !ok {
				return nil, errors.New("unexpected query param '" + param + "' received")
			}
			query.Add(param, fmt.Sprint(value))
		}
		if len(query) > 0 {
			queryParamsStr = query.Encode()
		}
	}

	return &CompiledRoute{route: compiledRoute, queryParams: queryParamsStr}, nil
}

// NewRoute generates a Route when given a URL
func NewRoute(url string, queryParams ...string) *Route {
	params := map[string]struct{}{}
	for _, param := range queryParams {
		params[param] = struct{}{}
	}
	return &Route{
		baseRoute:     "",
		route:         url,
		queryParams:   params,
		urlParamCount: countURLParams(url),
	}
}

func countURLParams(url string) int {
	paramCount := strings.Count(url, "{")
	return paramCount
}

// CompiledRoute is Route compiled with all URL args
type CompiledRoute struct {
	route       string
	queryParams string
}

// URL returns the full request URL
func (r *CompiledRoute) URL() string {
	route := r.route
	if r.queryParams != "" {
		route += "?" + r.queryParams
	}
	return route
}

// Route returns the request route
func (r *CompiledRoute) Route() string {
	return r.route
}

// QueryParams returns the request query params
func (r *CompiledRoute) QueryParams() string {
	return r.route
}
