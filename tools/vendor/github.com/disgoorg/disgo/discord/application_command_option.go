package discord

import (
	"fmt"

	"github.com/disgoorg/disgo/json"
)

// ApplicationCommandOptionType specifies the type of the arguments used in ApplicationCommand.Options
type ApplicationCommandOptionType int

// Constants for each slash command option type
const (
	ApplicationCommandOptionTypeSubCommand ApplicationCommandOptionType = iota + 1
	ApplicationCommandOptionTypeSubCommandGroup
	ApplicationCommandOptionTypeString
	ApplicationCommandOptionTypeInt
	ApplicationCommandOptionTypeBool
	ApplicationCommandOptionTypeUser
	ApplicationCommandOptionTypeChannel
	ApplicationCommandOptionTypeRole
	ApplicationCommandOptionTypeMentionable
	ApplicationCommandOptionTypeFloat
	ApplicationCommandOptionTypeAttachment
)

type ApplicationCommandOption interface {
	json.Marshaler
	Type() ApplicationCommandOptionType
	OptionName() string
	OptionDescription() string
	applicationCommandOption()
}

type UnmarshalApplicationCommandOption struct {
	ApplicationCommandOption
}

func (u *UnmarshalApplicationCommandOption) UnmarshalJSON(data []byte) error {
	var oType struct {
		Type ApplicationCommandOptionType `json:"type"`
	}

	if err := json.Unmarshal(data, &oType); err != nil {
		return err
	}

	var (
		applicationCommandOption ApplicationCommandOption
		err                      error
	)

	switch oType.Type {
	case ApplicationCommandOptionTypeSubCommand:
		var v ApplicationCommandOptionSubCommand
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeSubCommandGroup:
		var v ApplicationCommandOptionSubCommandGroup
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeString:
		var v ApplicationCommandOptionString
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeInt:
		var v ApplicationCommandOptionInt
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeBool:
		var v ApplicationCommandOptionBool
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeUser:
		var v ApplicationCommandOptionUser
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeChannel:
		var v ApplicationCommandOptionChannel
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeRole:
		var v ApplicationCommandOptionRole
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeMentionable:
		var v ApplicationCommandOptionMentionable
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeFloat:
		var v ApplicationCommandOptionFloat
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	case ApplicationCommandOptionTypeAttachment:
		var v ApplicationCommandOptionAttachment
		err = json.Unmarshal(data, &v)
		applicationCommandOption = v

	default:
		err = fmt.Errorf("unkown application command option with type %d received", oType.Type)
	}

	if err != nil {
		return err
	}

	u.ApplicationCommandOption = applicationCommandOption
	return nil
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionSubCommand)(nil)

type ApplicationCommandOptionSubCommand struct {
	Name                     string                     `json:"name"`
	NameLocalizations        map[Locale]string          `json:"name_localizations,omitempty"`
	Description              string                     `json:"description"`
	DescriptionLocalizations map[Locale]string          `json:"description_localizations,omitempty"`
	Options                  []ApplicationCommandOption `json:"options,omitempty"`
}

func (o ApplicationCommandOptionSubCommand) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionSubCommand ApplicationCommandOptionSubCommand
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionSubCommand
	}{
		Type:                               o.Type(),
		applicationCommandOptionSubCommand: applicationCommandOptionSubCommand(o),
	})
}

func (o *ApplicationCommandOptionSubCommand) UnmarshalJSON(data []byte) error {
	type applicationCommandOptionSubCommand ApplicationCommandOptionSubCommand
	var v struct {
		Options []UnmarshalApplicationCommandOption `json:"options"`
		applicationCommandOptionSubCommand
	}
	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}

	*o = ApplicationCommandOptionSubCommand(v.applicationCommandOptionSubCommand)

	if len(v.Options) > 0 {
		o.Options = make([]ApplicationCommandOption, len(v.Options))
		for i := range v.Options {
			o.Options[i] = v.Options[i].ApplicationCommandOption
		}
	}

	return nil
}

func (o ApplicationCommandOptionSubCommand) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionSubCommand) OptionDescription() string {
	return o.Description
}

func (ApplicationCommandOptionSubCommand) applicationCommandOption() {}
func (ApplicationCommandOptionSubCommand) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeSubCommand
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionSubCommandGroup)(nil)

type ApplicationCommandOptionSubCommandGroup struct {
	Name                     string                               `json:"name"`
	NameLocalizations        map[Locale]string                    `json:"name_localizations,omitempty"`
	Description              string                               `json:"description"`
	DescriptionLocalizations map[Locale]string                    `json:"description_localizations,omitempty"`
	Options                  []ApplicationCommandOptionSubCommand `json:"options,omitempty"`
}

func (o ApplicationCommandOptionSubCommandGroup) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionSubCommandGroup ApplicationCommandOptionSubCommandGroup
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionSubCommandGroup
	}{
		Type:                                    o.Type(),
		applicationCommandOptionSubCommandGroup: applicationCommandOptionSubCommandGroup(o),
	})
}

func (o ApplicationCommandOptionSubCommandGroup) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionSubCommandGroup) OptionDescription() string {
	return o.Description
}

func (ApplicationCommandOptionSubCommandGroup) applicationCommandOption() {}
func (ApplicationCommandOptionSubCommandGroup) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeSubCommandGroup
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionString)(nil)

type ApplicationCommandOptionString struct {
	Name                     string                                 `json:"name"`
	NameLocalizations        map[Locale]string                      `json:"name_localizations,omitempty"`
	Description              string                                 `json:"description"`
	DescriptionLocalizations map[Locale]string                      `json:"description_localizations,omitempty"`
	Required                 bool                                   `json:"required,omitempty"`
	Choices                  []ApplicationCommandOptionChoiceString `json:"choices,omitempty"`
	Autocomplete             bool                                   `json:"autocomplete,omitempty"`
	MinLength                *int                                   `json:"min_length,omitempty"`
	MaxLength                *int                                   `json:"max_length,omitempty"`
}

func (o ApplicationCommandOptionString) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionString ApplicationCommandOptionString
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionString
	}{
		Type:                           o.Type(),
		applicationCommandOptionString: applicationCommandOptionString(o),
	})
}

func (o ApplicationCommandOptionString) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionString) OptionDescription() string {
	return o.Description
}

func (ApplicationCommandOptionString) applicationCommandOption() {}
func (ApplicationCommandOptionString) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeString
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionInt)(nil)

type ApplicationCommandOptionInt struct {
	Name                     string                              `json:"name"`
	NameLocalizations        map[Locale]string                   `json:"name_localizations,omitempty"`
	Description              string                              `json:"description"`
	DescriptionLocalizations map[Locale]string                   `json:"description_localizations,omitempty"`
	Required                 bool                                `json:"required,omitempty"`
	Choices                  []ApplicationCommandOptionChoiceInt `json:"choices,omitempty"`
	Autocomplete             bool                                `json:"autocomplete,omitempty"`
	MinValue                 *int                                `json:"min_value,omitempty"`
	MaxValue                 *int                                `json:"max_value,omitempty"`
}

func (o ApplicationCommandOptionInt) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionInt ApplicationCommandOptionInt
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionInt
	}{
		Type:                        o.Type(),
		applicationCommandOptionInt: applicationCommandOptionInt(o),
	})
}

func (o ApplicationCommandOptionInt) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionInt) OptionDescription() string {
	return o.Description
}

func (ApplicationCommandOptionInt) applicationCommandOption() {}
func (ApplicationCommandOptionInt) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeInt
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionBool)(nil)

type ApplicationCommandOptionBool struct {
	Name                     string            `json:"name"`
	NameLocalizations        map[Locale]string `json:"name_localizations,omitempty"`
	Description              string            `json:"description"`
	DescriptionLocalizations map[Locale]string `json:"description_localizations,omitempty"`
	Required                 bool              `json:"required,omitempty"`
}

func (o ApplicationCommandOptionBool) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionBool ApplicationCommandOptionBool
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionBool
	}{
		Type:                         o.Type(),
		applicationCommandOptionBool: applicationCommandOptionBool(o),
	})
}

func (o ApplicationCommandOptionBool) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionBool) OptionDescription() string {
	return o.Description
}

func (ApplicationCommandOptionBool) applicationCommandOption() {}
func (ApplicationCommandOptionBool) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeBool
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionUser)(nil)

type ApplicationCommandOptionUser struct {
	Name                     string            `json:"name"`
	NameLocalizations        map[Locale]string `json:"name_localizations,omitempty"`
	Description              string            `json:"description"`
	DescriptionLocalizations map[Locale]string `json:"description_localizations,omitempty"`
	Required                 bool              `json:"required,omitempty"`
}

func (o ApplicationCommandOptionUser) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionUser ApplicationCommandOptionUser
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionUser
	}{
		Type:                         o.Type(),
		applicationCommandOptionUser: applicationCommandOptionUser(o),
	})
}

func (o ApplicationCommandOptionUser) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionUser) OptionDescription() string {
	return o.Description
}

func (ApplicationCommandOptionUser) applicationCommandOption() {}
func (ApplicationCommandOptionUser) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeUser
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionChannel)(nil)

type ApplicationCommandOptionChannel struct {
	Name                     string            `json:"name"`
	NameLocalizations        map[Locale]string `json:"name_localizations,omitempty"`
	Description              string            `json:"description"`
	DescriptionLocalizations map[Locale]string `json:"description_localizations,omitempty"`
	Required                 bool              `json:"required,omitempty"`
	ChannelTypes             []ChannelType     `json:"channel_types,omitempty"`
}

func (o ApplicationCommandOptionChannel) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionChannel ApplicationCommandOptionChannel
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionChannel
	}{
		Type:                            o.Type(),
		applicationCommandOptionChannel: applicationCommandOptionChannel(o),
	})
}

func (o ApplicationCommandOptionChannel) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionChannel) OptionDescription() string {
	return o.Name
}

func (ApplicationCommandOptionChannel) applicationCommandOption() {}
func (ApplicationCommandOptionChannel) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeChannel
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionRole)(nil)

type ApplicationCommandOptionRole struct {
	Name                     string            `json:"name"`
	NameLocalizations        map[Locale]string `json:"name_localizations,omitempty"`
	Description              string            `json:"description"`
	DescriptionLocalizations map[Locale]string `json:"description_localizations,omitempty"`
	Required                 bool              `json:"required,omitempty"`
}

func (o ApplicationCommandOptionRole) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionRole ApplicationCommandOptionRole
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionRole
	}{
		Type:                         o.Type(),
		applicationCommandOptionRole: applicationCommandOptionRole(o),
	})
}

func (o ApplicationCommandOptionRole) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionRole) OptionDescription() string {
	return o.Name
}

func (ApplicationCommandOptionRole) applicationCommandOption() {}
func (ApplicationCommandOptionRole) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeRole
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionMentionable)(nil)

type ApplicationCommandOptionMentionable struct {
	Name                     string            `json:"name"`
	NameLocalizations        map[Locale]string `json:"name_localizations,omitempty"`
	Description              string            `json:"description"`
	DescriptionLocalizations map[Locale]string `json:"description_localizations,omitempty"`
	Required                 bool              `json:"required,omitempty"`
}

func (o ApplicationCommandOptionMentionable) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionMentionable ApplicationCommandOptionMentionable
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionMentionable
	}{
		Type:                                o.Type(),
		applicationCommandOptionMentionable: applicationCommandOptionMentionable(o),
	})
}

func (o ApplicationCommandOptionMentionable) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionMentionable) OptionDescription() string {
	return o.Name
}

func (ApplicationCommandOptionMentionable) applicationCommandOption() {}
func (ApplicationCommandOptionMentionable) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeMentionable
}

var _ ApplicationCommandOption = (*ApplicationCommandOptionFloat)(nil)

type ApplicationCommandOptionFloat struct {
	Name                     string                                `json:"name"`
	NameLocalizations        map[Locale]string                     `json:"name_localizations,omitempty"`
	Description              string                                `json:"description"`
	DescriptionLocalizations map[Locale]string                     `json:"description_localizations,omitempty"`
	Required                 bool                                  `json:"required,omitempty"`
	Choices                  []ApplicationCommandOptionChoiceFloat `json:"choices,omitempty"`
	Autocomplete             bool                                  `json:"autocomplete,omitempty"`
	MinValue                 *float64                              `json:"min_value,omitempty"`
	MaxValue                 *float64                              `json:"max_value,omitempty"`
}

func (o ApplicationCommandOptionFloat) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionFloat ApplicationCommandOptionFloat
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionFloat
	}{
		Type:                          o.Type(),
		applicationCommandOptionFloat: applicationCommandOptionFloat(o),
	})
}

func (o ApplicationCommandOptionFloat) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionFloat) OptionDescription() string {
	return o.Name
}

func (ApplicationCommandOptionFloat) applicationCommandOption() {}
func (ApplicationCommandOptionFloat) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeFloat
}

type ApplicationCommandOptionChoice interface {
	applicationCommandOptionChoice()
}

var _ ApplicationCommandOptionChoice = (*ApplicationCommandOptionChoiceInt)(nil)

type ApplicationCommandOptionChoiceInt struct {
	Name              string            `json:"name"`
	NameLocalizations map[Locale]string `json:"name_localizations,omitempty"`
	Value             int               `json:"value"`
}

func (ApplicationCommandOptionChoiceInt) applicationCommandOptionChoice() {}

var _ ApplicationCommandOptionChoice = (*ApplicationCommandOptionChoiceString)(nil)

type ApplicationCommandOptionChoiceString struct {
	Name              string            `json:"name"`
	NameLocalizations map[Locale]string `json:"name_localizations,omitempty"`
	Value             string            `json:"value"`
}

func (ApplicationCommandOptionChoiceString) applicationCommandOptionChoice() {}

var _ ApplicationCommandOptionChoice = (*ApplicationCommandOptionChoiceInt)(nil)

type ApplicationCommandOptionChoiceFloat struct {
	Name              string            `json:"name"`
	NameLocalizations map[Locale]string `json:"name_localizations,omitempty"`
	Value             float64           `json:"value"`
}

func (ApplicationCommandOptionChoiceFloat) applicationCommandOptionChoice() {}

type ApplicationCommandOptionAttachment struct {
	Name                     string            `json:"name"`
	NameLocalizations        map[Locale]string `json:"name_localizations,omitempty"`
	Description              string            `json:"description"`
	DescriptionLocalizations map[Locale]string `json:"description_localizations,omitempty"`
	Required                 bool              `json:"required,omitempty"`
}

func (o ApplicationCommandOptionAttachment) MarshalJSON() ([]byte, error) {
	type applicationCommandOptionAttachment ApplicationCommandOptionAttachment
	return json.Marshal(struct {
		Type ApplicationCommandOptionType `json:"type"`
		applicationCommandOptionAttachment
	}{
		Type:                               o.Type(),
		applicationCommandOptionAttachment: applicationCommandOptionAttachment(o),
	})
}

func (o ApplicationCommandOptionAttachment) OptionName() string {
	return o.Name
}

func (o ApplicationCommandOptionAttachment) OptionDescription() string {
	return o.Name
}

func (ApplicationCommandOptionAttachment) applicationCommandOption() {}
func (ApplicationCommandOptionAttachment) Type() ApplicationCommandOptionType {
	return ApplicationCommandOptionTypeAttachment
}
