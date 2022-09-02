package rest

// Rest is a manager for all of disgo's HTTP requests
type Rest interface {
	Client

	Applications
	OAuth2
	Gateway
	Guilds
	AutoModeration
	Members
	Channels
	Threads
	Interactions
	Invites
	GuildTemplates
	Users
	Voice
	Webhooks
	StageInstances
	Emojis
	Stickers
	GuildScheduledEvents
}

var _ Rest = (*restImpl)(nil)

// New returns a new default Rest
func New(client Client) Rest {
	return &restImpl{
		Client:               client,
		Applications:         NewApplications(client),
		OAuth2:               NewOAuth2(client),
		Gateway:              NewGateway(client),
		Guilds:               NewGuilds(client),
		AutoModeration:       NewAutoModeration(client),
		Members:              NewMembers(client),
		Channels:             NewChannels(client),
		Threads:              NewThreads(client),
		Interactions:         NewInteractions(client),
		Invites:              NewInvites(client),
		GuildTemplates:       NewGuildTemplates(client),
		Users:                NewUsers(client),
		Voice:                NewVoice(client),
		Webhooks:             NewWebhooks(client),
		StageInstances:       NewStageInstances(client),
		Emojis:               NewEmojis(client),
		Stickers:             NewStickers(client),
		GuildScheduledEvents: NewGuildScheduledEvents(client),
	}
}

type restImpl struct {
	Client

	Applications
	OAuth2
	Gateway
	Guilds
	AutoModeration
	Members
	Channels
	Threads
	Interactions
	Invites
	GuildTemplates
	Users
	Voice
	Webhooks
	StageInstances
	Emojis
	Stickers
	GuildScheduledEvents
}
