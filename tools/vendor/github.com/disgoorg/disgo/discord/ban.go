package discord

// Ban represents a banned User from a Guild (https://discord.com/developers/docs/resources/guild#ban-object)
type Ban struct {
	Reason *string `json:"reason,omitempty"`
	User   User    `json:"user"`
}

// AddBan is used to ban a User (https://discord.com/developers/docs/resources/guild#create-guild-ban-json-params)
type AddBan struct {
	DeleteMessageDays int `json:"delete_message_days,omitempty"`
}
