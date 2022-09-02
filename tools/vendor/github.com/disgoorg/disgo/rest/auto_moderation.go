package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ AutoModeration = (*autoModerationImpl)(nil)

func NewAutoModeration(client Client) AutoModeration {
	return &autoModerationImpl{client: client}
}

type AutoModeration interface {
	GetAutoModerationRules(guildID snowflake.ID, opts ...RequestOpt) ([]discord.AutoModerationRule, error)
	GetAutoModerationRule(guildID snowflake.ID, ruleID snowflake.ID, opts ...RequestOpt) (*discord.AutoModerationRule, error)
	CreateAutoModerationRule(guildID snowflake.ID, ruleCreate discord.AutoModerationRuleCreate, opts ...RequestOpt) (*discord.AutoModerationRule, error)
	UpdateAutoModerationRule(guildID snowflake.ID, ruleID snowflake.ID, ruleUpdate discord.AutoModerationRuleUpdate, opts ...RequestOpt) (*discord.AutoModerationRule, error)
	DeleteAutoModerationRule(guildID snowflake.ID, ruleID snowflake.ID, opts ...RequestOpt) error
}

type autoModerationImpl struct {
	client Client
}

func (s *autoModerationImpl) GetAutoModerationRules(guildID snowflake.ID, opts ...RequestOpt) (rules []discord.AutoModerationRule, err error) {
	err = s.client.Do(GetAutoModerationRules.Compile(nil, guildID), nil, &rules, opts...)
	return
}

func (s *autoModerationImpl) GetAutoModerationRule(guildID snowflake.ID, ruleID snowflake.ID, opts ...RequestOpt) (rule *discord.AutoModerationRule, err error) {
	err = s.client.Do(GetAutoModerationRule.Compile(nil, guildID, ruleID), nil, &rule, opts...)
	return
}

func (s *autoModerationImpl) CreateAutoModerationRule(guildID snowflake.ID, ruleCreate discord.AutoModerationRuleCreate, opts ...RequestOpt) (rule *discord.AutoModerationRule, err error) {
	err = s.client.Do(CreateAutoModerationRule.Compile(nil, guildID), ruleCreate, &rule, opts...)
	return
}

func (s *autoModerationImpl) UpdateAutoModerationRule(guildID snowflake.ID, ruleID snowflake.ID, ruleUpdate discord.AutoModerationRuleUpdate, opts ...RequestOpt) (rule *discord.AutoModerationRule, err error) {
	err = s.client.Do(UpdateAutoModerationRule.Compile(nil, guildID, ruleID), ruleUpdate, &rule, opts...)
	return
}

func (s *autoModerationImpl) DeleteAutoModerationRule(guildID snowflake.ID, ruleID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteAutoModerationRule.Compile(nil, guildID, ruleID), nil, nil, opts...)
}
