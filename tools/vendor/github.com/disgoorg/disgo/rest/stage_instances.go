package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ StageInstances = (*stageInstanceImpl)(nil)

func NewStageInstances(client Client) StageInstances {
	return &stageInstanceImpl{client: client}
}

type StageInstances interface {
	GetStageInstance(guildID snowflake.ID, opts ...RequestOpt) (*discord.StageInstance, error)
	CreateStageInstance(stageInstanceCreate discord.StageInstanceCreate, opts ...RequestOpt) (*discord.StageInstance, error)
	UpdateStageInstance(guildID snowflake.ID, stageInstanceUpdate discord.StageInstanceUpdate, opts ...RequestOpt) (*discord.StageInstance, error)
	DeleteStageInstance(guildID snowflake.ID, opts ...RequestOpt) error
}

type stageInstanceImpl struct {
	client Client
}

func (s *stageInstanceImpl) GetStageInstance(guildID snowflake.ID, opts ...RequestOpt) (stageInstance *discord.StageInstance, err error) {
	err = s.client.Do(GetStageInstance.Compile(nil, guildID), nil, &stageInstance, opts...)
	return
}

func (s *stageInstanceImpl) CreateStageInstance(stageInstanceCreate discord.StageInstanceCreate, opts ...RequestOpt) (stageInstance *discord.StageInstance, err error) {
	err = s.client.Do(CreateStageInstance.Compile(nil), stageInstanceCreate, &stageInstance, opts...)
	return
}

func (s *stageInstanceImpl) UpdateStageInstance(guildID snowflake.ID, stageInstanceUpdate discord.StageInstanceUpdate, opts ...RequestOpt) (stageInstance *discord.StageInstance, err error) {
	err = s.client.Do(UpdateStageInstance.Compile(nil, guildID), stageInstanceUpdate, &stageInstance, opts...)
	return
}

func (s *stageInstanceImpl) DeleteStageInstance(guildID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteStageInstance.Compile(nil, guildID), nil, nil, opts...)
}
