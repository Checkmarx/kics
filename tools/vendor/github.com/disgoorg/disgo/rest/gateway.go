package rest

import (
	"github.com/disgoorg/disgo/discord"
)

var _ Gateway = (*gatewayImpl)(nil)

func NewGateway(client Client) Gateway {
	return &gatewayImpl{client: client}
}

type Gateway interface {
	GetGateway(opts ...RequestOpt) (*discord.Gateway, error)
	GetGatewayBot(opts ...RequestOpt) (*discord.GatewayBot, error)
}

type gatewayImpl struct {
	client Client
}

func (s *gatewayImpl) GetGateway(opts ...RequestOpt) (gateway *discord.Gateway, err error) {
	err = s.client.Do(GetGateway.Compile(nil), nil, &gateway, opts...)
	return
}

func (s *gatewayImpl) GetGatewayBot(opts ...RequestOpt) (gatewayBot *discord.GatewayBot, err error) {
	err = s.client.Do(GetGatewayBot.Compile(nil), nil, &gatewayBot, opts...)
	return
}
