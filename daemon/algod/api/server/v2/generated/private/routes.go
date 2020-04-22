// Package private provides primitives to interact the openapi HTTP API.
//
// Code generated by github.com/algorand/oapi-codegen DO NOT EDIT.
package private

import (
	"bytes"
	"compress/gzip"
	"encoding/base64"
	"fmt"
	"github.com/algorand/oapi-codegen/pkg/runtime"
	"github.com/getkin/kin-openapi/openapi3"
	"github.com/labstack/echo/v4"
	"net/http"
	"strings"
)

// ServerInterface represents all server handlers.
type ServerInterface interface {

	// (POST /v2/register-participation-keys/{address})
	RegisterParticipationKeys(ctx echo.Context, address string, params RegisterParticipationKeysParams) error

	// (POST /v2/shutdown)
	ShutdownNode(ctx echo.Context, params ShutdownNodeParams) error
}

// ServerInterfaceWrapper converts echo contexts to parameters.
type ServerInterfaceWrapper struct {
	Handler ServerInterface
}

// RegisterParticipationKeys converts echo context to params.
func (w *ServerInterfaceWrapper) RegisterParticipationKeys(ctx echo.Context) error {
	var err error
	// ------------- Path parameter "address" -------------
	var address string

	err = runtime.BindStyledParameter("simple", false, "address", ctx.Param("address"), &address)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Invalid format for parameter address: %s", err))
	}

	ctx.Set("api_key.Scopes", []string{""})

	// Parameter object where we will unmarshal all parameters from the context
	var params RegisterParticipationKeysParams
	// ------------- Optional query parameter "fee" -------------
	if paramValue := ctx.QueryParam("fee"); paramValue != "" {

	}

	err = runtime.BindQueryParameter("form", true, false, "fee", ctx.QueryParams(), &params.Fee)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Invalid format for parameter fee: %s", err))
	}

	// ------------- Optional query parameter "key-dilution" -------------
	if paramValue := ctx.QueryParam("key-dilution"); paramValue != "" {

	}

	err = runtime.BindQueryParameter("form", true, false, "key-dilution", ctx.QueryParams(), &params.KeyDilution)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Invalid format for parameter key-dilution: %s", err))
	}

	// ------------- Optional query parameter "round-last-valid" -------------
	if paramValue := ctx.QueryParam("round-last-valid"); paramValue != "" {

	}

	err = runtime.BindQueryParameter("form", true, false, "round-last-valid", ctx.QueryParams(), &params.RoundLastValid)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Invalid format for parameter round-last-valid: %s", err))
	}

	// ------------- Optional query parameter "no-wait" -------------
	if paramValue := ctx.QueryParam("no-wait"); paramValue != "" {

	}

	err = runtime.BindQueryParameter("form", true, false, "no-wait", ctx.QueryParams(), &params.NoWait)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Invalid format for parameter no-wait: %s", err))
	}

	// Invoke the callback with all the unmarshalled arguments
	err = w.Handler.RegisterParticipationKeys(ctx, address, params)
	return err
}

// ShutdownNode converts echo context to params.
func (w *ServerInterfaceWrapper) ShutdownNode(ctx echo.Context) error {
	var err error

	ctx.Set("api_key.Scopes", []string{""})

	// Parameter object where we will unmarshal all parameters from the context
	var params ShutdownNodeParams
	// ------------- Optional query parameter "timeout" -------------
	if paramValue := ctx.QueryParam("timeout"); paramValue != "" {

	}

	err = runtime.BindQueryParameter("form", true, false, "timeout", ctx.QueryParams(), &params.Timeout)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, fmt.Sprintf("Invalid format for parameter timeout: %s", err))
	}

	// Invoke the callback with all the unmarshalled arguments
	err = w.Handler.ShutdownNode(ctx, params)
	return err
}

// RegisterHandlers adds each server route to the EchoRouter.
func RegisterHandlers(router interface {
	CONNECT(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	DELETE(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	GET(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	HEAD(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	OPTIONS(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	PATCH(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	POST(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	PUT(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
	TRACE(path string, h echo.HandlerFunc, m ...echo.MiddlewareFunc) *echo.Route
}, si ServerInterface) {

	wrapper := ServerInterfaceWrapper{
		Handler: si,
	}

	router.POST("/v2/register-participation-keys/:address", wrapper.RegisterParticipationKeys)
	router.POST("/v2/shutdown", wrapper.ShutdownNode)

}

// Base64 encoded, gzipped, json marshaled Swagger object
var swaggerSpec = []string{

	"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",
	"+7v/DQAA//+92ndK4FcAAA==",
}

// GetSwagger returns the Swagger specification corresponding to the generated code
// in this file.
func GetSwagger() (*openapi3.Swagger, error) {
	zipped, err := base64.StdEncoding.DecodeString(strings.Join(swaggerSpec, ""))
	if err != nil {
		return nil, fmt.Errorf("error base64 decoding spec: %s", err)
	}
	zr, err := gzip.NewReader(bytes.NewReader(zipped))
	if err != nil {
		return nil, fmt.Errorf("error decompressing spec: %s", err)
	}
	var buf bytes.Buffer
	_, err = buf.ReadFrom(zr)
	if err != nil {
		return nil, fmt.Errorf("error decompressing spec: %s", err)
	}

	swagger, err := openapi3.NewSwaggerLoader().LoadSwaggerFromData(buf.Bytes())
	if err != nil {
		return nil, fmt.Errorf("error loading Swagger: %s", err)
	}
	return swagger, nil
}
