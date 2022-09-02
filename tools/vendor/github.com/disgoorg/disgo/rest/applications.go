package rest

import (
	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Applications = (*applicationsImpl)(nil)

func NewApplications(client Client) Applications {
	return &applicationsImpl{client: client}
}

type Applications interface {
	GetGlobalCommands(applicationID snowflake.ID, withLocalizations bool, opts ...RequestOpt) ([]discord.ApplicationCommand, error)
	GetGlobalCommand(applicationID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) (discord.ApplicationCommand, error)
	CreateGlobalCommand(applicationID snowflake.ID, commandCreate discord.ApplicationCommandCreate, opts ...RequestOpt) (discord.ApplicationCommand, error)
	SetGlobalCommands(applicationID snowflake.ID, commandCreates []discord.ApplicationCommandCreate, opts ...RequestOpt) ([]discord.ApplicationCommand, error)
	UpdateGlobalCommand(applicationID snowflake.ID, commandID snowflake.ID, commandUpdate discord.ApplicationCommandUpdate, opts ...RequestOpt) (discord.ApplicationCommand, error)
	DeleteGlobalCommand(applicationID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) error

	GetGuildCommands(applicationID snowflake.ID, guildID snowflake.ID, withLocalizations bool, opts ...RequestOpt) ([]discord.ApplicationCommand, error)
	GetGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) (discord.ApplicationCommand, error)
	CreateGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, command discord.ApplicationCommandCreate, opts ...RequestOpt) (discord.ApplicationCommand, error)
	SetGuildCommands(applicationID snowflake.ID, guildID snowflake.ID, commands []discord.ApplicationCommandCreate, opts ...RequestOpt) ([]discord.ApplicationCommand, error)
	UpdateGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, command discord.ApplicationCommandUpdate, opts ...RequestOpt) (discord.ApplicationCommand, error)
	DeleteGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) error

	GetGuildCommandsPermissions(applicationID snowflake.ID, guildID snowflake.ID, opts ...RequestOpt) ([]discord.ApplicationCommandPermissions, error)
	GetGuildCommandPermissions(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) (*discord.ApplicationCommandPermissions, error)
}

type applicationsImpl struct {
	client Client
}

func (s *applicationsImpl) GetGlobalCommands(applicationID snowflake.ID, withLocalizations bool, opts ...RequestOpt) (commands []discord.ApplicationCommand, err error) {
	var unmarshalCommands []discord.UnmarshalApplicationCommand
	err = s.client.Do(GetGlobalCommands.Compile(discord.QueryValues{"with_localizations": withLocalizations}, applicationID), nil, &unmarshalCommands, opts...)
	if err == nil {
		commands = unmarshalApplicationCommandsToApplicationCommands(unmarshalCommands)
	}
	return
}

func (s *applicationsImpl) GetGlobalCommand(applicationID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) (command discord.ApplicationCommand, err error) {
	var unmarshalCommand discord.UnmarshalApplicationCommand
	err = s.client.Do(GetGlobalCommand.Compile(nil, applicationID, commandID), nil, &command, opts...)
	if err == nil {
		command = unmarshalCommand.ApplicationCommand
	}
	return
}

func (s *applicationsImpl) CreateGlobalCommand(applicationID snowflake.ID, commandCreate discord.ApplicationCommandCreate, opts ...RequestOpt) (command discord.ApplicationCommand, err error) {
	var unmarshalCommand discord.UnmarshalApplicationCommand
	err = s.client.Do(CreateGlobalCommand.Compile(nil, applicationID), commandCreate, &command, opts...)
	if err == nil {
		command = unmarshalCommand.ApplicationCommand
	}
	return
}

func (s *applicationsImpl) SetGlobalCommands(applicationID snowflake.ID, commandCreates []discord.ApplicationCommandCreate, opts ...RequestOpt) (commands []discord.ApplicationCommand, err error) {
	var unmarshalCommands []discord.UnmarshalApplicationCommand
	err = s.client.Do(SetGlobalCommands.Compile(nil, applicationID), commandCreates, &unmarshalCommands, opts...)
	if err == nil {
		commands = unmarshalApplicationCommandsToApplicationCommands(unmarshalCommands)
	}
	return
}

func (s *applicationsImpl) UpdateGlobalCommand(applicationID snowflake.ID, commandID snowflake.ID, commandUpdate discord.ApplicationCommandUpdate, opts ...RequestOpt) (command discord.ApplicationCommand, err error) {
	var unmarshalCommand discord.UnmarshalApplicationCommand
	err = s.client.Do(UpdateGlobalCommand.Compile(nil, applicationID, commandID), commandUpdate, &unmarshalCommand, opts...)
	if err == nil {
		command = unmarshalCommand.ApplicationCommand
	}
	return
}

func (s *applicationsImpl) DeleteGlobalCommand(applicationID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteGlobalCommand.Compile(nil, applicationID, commandID), nil, nil, opts...)
}

func (s *applicationsImpl) GetGuildCommands(applicationID snowflake.ID, guildID snowflake.ID, withLocalizations bool, opts ...RequestOpt) (commands []discord.ApplicationCommand, err error) {
	var unmarshalCommands []discord.UnmarshalApplicationCommand
	err = s.client.Do(GetGuildCommands.Compile(discord.QueryValues{"with_localizations": withLocalizations}, applicationID, guildID), nil, &unmarshalCommands, opts...)
	if err == nil {
		commands = unmarshalApplicationCommandsToApplicationCommands(unmarshalCommands)
	}
	return
}

func (s *applicationsImpl) GetGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) (command discord.ApplicationCommand, err error) {
	var unmarshalCommand discord.UnmarshalApplicationCommand
	err = s.client.Do(GetGuildCommand.Compile(nil, applicationID, guildID, commandID), nil, &unmarshalCommand, opts...)
	if err == nil {
		command = unmarshalCommand.ApplicationCommand
	}
	return
}

func (s *applicationsImpl) CreateGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandCreate discord.ApplicationCommandCreate, opts ...RequestOpt) (command discord.ApplicationCommand, err error) {
	var unmarshalCommand discord.UnmarshalApplicationCommand
	err = s.client.Do(CreateGuildCommand.Compile(nil, applicationID, guildID), commandCreate, &unmarshalCommand, opts...)
	if err == nil {
		command = unmarshalCommand.ApplicationCommand
	}
	return
}

func (s *applicationsImpl) SetGuildCommands(applicationID snowflake.ID, guildID snowflake.ID, commandCreates []discord.ApplicationCommandCreate, opts ...RequestOpt) (commands []discord.ApplicationCommand, err error) {
	var unmarshalCommands []discord.UnmarshalApplicationCommand
	err = s.client.Do(SetGuildCommands.Compile(nil, applicationID, guildID), commandCreates, &unmarshalCommands, opts...)
	if err == nil {
		commands = unmarshalApplicationCommandsToApplicationCommands(unmarshalCommands)
	}
	return
}

func (s *applicationsImpl) UpdateGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, commandUpdate discord.ApplicationCommandUpdate, opts ...RequestOpt) (command discord.ApplicationCommand, err error) {
	var unmarshalCommand discord.UnmarshalApplicationCommand
	err = s.client.Do(UpdateGuildCommand.Compile(nil, applicationID, guildID, commandID), commandUpdate, &unmarshalCommand, opts...)
	if err == nil {
		command = unmarshalCommand.ApplicationCommand
	}
	return
}

func (s *applicationsImpl) DeleteGuildCommand(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(DeleteGuildCommand.Compile(nil, applicationID, guildID, commandID), nil, nil, opts...)
}

func (s *applicationsImpl) GetGuildCommandsPermissions(applicationID snowflake.ID, guildID snowflake.ID, opts ...RequestOpt) (commandsPerms []discord.ApplicationCommandPermissions, err error) {
	err = s.client.Do(GetGuildCommandsPermissions.Compile(nil, applicationID, guildID), nil, &commandsPerms, opts...)
	return
}

func (s *applicationsImpl) GetGuildCommandPermissions(applicationID snowflake.ID, guildID snowflake.ID, commandID snowflake.ID, opts ...RequestOpt) (commandPerms *discord.ApplicationCommandPermissions, err error) {
	err = s.client.Do(GetGuildCommandPermissions.Compile(nil, applicationID, guildID, commandID), nil, &commandPerms, opts...)
	return
}

func unmarshalApplicationCommandsToApplicationCommands(unmarshalCommands []discord.UnmarshalApplicationCommand) []discord.ApplicationCommand {
	commands := make([]discord.ApplicationCommand, len(unmarshalCommands))
	for i := range unmarshalCommands {
		commands[i] = unmarshalCommands[i].ApplicationCommand
	}
	return commands
}
