package discord

import (
	"time"

	"github.com/disgoorg/disgo/json"
	"github.com/disgoorg/snowflake/v2"
)

// The MessageType indicates the Message type
type MessageType int

// Constants for the MessageType
const (
	MessageTypeDefault MessageType = iota
	MessageTypeRecipientAdd
	MessageTypeRecipientRemove
	MessageTypeCall
	MessageTypeChannelNameChange
	MessageTypeChannelIconChange
	ChannelPinnedMessage
	MessageTypeUserJoin
	MessageTypeGuildBoost
	MessageTypeGuildBoostTier1
	MessageTypeGuildBoostTier2
	MessageTypeGuildBoostTier3
	MessageTypeChannelFollowAdd
	_
	MessageTypeGuildDiscoveryDisqualified
	MessageTypeGuildDiscoveryRequalified
	MessageTypeGuildDiscoveryGracePeriodInitialWarning
	MessageTypeGuildDiscoveryGracePeriodFinalWarning
	MessageTypeThreadCreated
	MessageTypeReply
	MessageTypeSlashCommand
	MessageTypeThreadStarterMessage
	MessageTypeGuildInviteReminder
	MessageTypeContextMenuCommand
	MessageTypeAutoModerationAction
)

func (t MessageType) System() bool {
	switch t {
	case MessageTypeDefault, MessageTypeReply, MessageTypeSlashCommand, MessageTypeThreadStarterMessage, MessageTypeContextMenuCommand:
		return false

	default:
		return true
	}
}

func (t MessageType) Deleteable() bool {
	switch t {
	case MessageTypeRecipientAdd, MessageTypeRecipientRemove, MessageTypeCall,
		MessageTypeChannelNameChange, MessageTypeChannelIconChange, MessageTypeGuildDiscoveryDisqualified,
		MessageTypeGuildDiscoveryRequalified, MessageTypeGuildDiscoveryGracePeriodInitialWarning,
		MessageTypeGuildDiscoveryGracePeriodFinalWarning, MessageTypeThreadStarterMessage:
		return false

	default:
		return true
	}
}

// Message is a struct for messages sent in discord text-based channels
type Message struct {
	ID                snowflake.ID         `json:"id"`
	GuildID           *snowflake.ID        `json:"guild_id"`
	Reactions         []MessageReaction    `json:"reactions"`
	Attachments       []Attachment         `json:"attachments"`
	TTS               bool                 `json:"tts"`
	Embeds            []Embed              `json:"embeds,omitempty"`
	Components        []ContainerComponent `json:"components,omitempty"`
	CreatedAt         time.Time            `json:"timestamp"`
	Mentions          []User               `json:"mentions"`
	MentionEveryone   bool                 `json:"mention_everyone"`
	MentionRoles      []snowflake.ID       `json:"mention_roles"`
	MentionChannels   []Channel            `json:"mention_channels"`
	Pinned            bool                 `json:"pinned"`
	EditedTimestamp   *time.Time           `json:"edited_timestamp"`
	Author            User                 `json:"author"`
	Member            *Member              `json:"member"`
	Content           string               `json:"content,omitempty"`
	ChannelID         snowflake.ID         `json:"channel_id"`
	Type              MessageType          `json:"type"`
	Flags             MessageFlags         `json:"flags"`
	MessageReference  *MessageReference    `json:"message_reference,omitempty"`
	Interaction       *MessageInteraction  `json:"interaction,omitempty"`
	WebhookID         *snowflake.ID        `json:"webhook_id,omitempty"`
	Activity          *MessageActivity     `json:"activity,omitempty"`
	Application       *MessageApplication  `json:"application,omitempty"`
	Stickers          []MessageSticker     `json:"sticker_items,omitempty"`
	ReferencedMessage *Message             `json:"referenced_message,omitempty"`
	LastUpdated       *time.Time           `json:"last_updated,omitempty"`
	Thread            *MessageThread       `json:"thread,omitempty"`
	Position          *int                 `json:"position,omitempty"`
}

func (m *Message) UnmarshalJSON(data []byte) error {
	type message Message
	var v struct {
		Components []UnmarshalComponent `json:"components"`
		message
	}

	if err := json.Unmarshal(data, &v); err != nil {
		return err
	}

	*m = Message(v.message)

	if len(v.Components) > 0 {
		m.Components = make([]ContainerComponent, len(v.Components))
		for i := range v.Components {
			m.Components[i] = v.Components[i].Component.(ContainerComponent)
		}
	}

	return nil
}

// ActionRows returns all ActionRowComponent(s) from this Message
func (m *Message) ActionRows() []ActionRowComponent {
	var actionRows []ActionRowComponent
	for i := range m.Components {
		if actionRow, ok := m.Components[i].(ActionRowComponent); ok {
			actionRows = append(actionRows, actionRow)
		}
	}
	return actionRows
}

// InteractiveComponents returns the InteractiveComponent(s) from this Message
func (m *Message) InteractiveComponents() []InteractiveComponent {
	var interactiveComponents []InteractiveComponent
	for i := range m.Components {
		for ii := range m.Components[i].Components() {
			interactiveComponents = append(interactiveComponents, m.Components[i].Components()[ii])
		}
	}
	return interactiveComponents
}

// ComponentByID returns the Component with the specific CustomID
func (m *Message) ComponentByID(customID string) InteractiveComponent {
	for i := range m.Components {
		for ii := range m.Components[i].Components() {
			if m.Components[i].Components()[ii].ID() == customID {
				return m.Components[i].Components()[ii]
			}
		}
	}
	return nil
}

// Buttons returns all ButtonComponent(s) from this Message
func (m *Message) Buttons() []ButtonComponent {
	var buttons []ButtonComponent
	for i := range m.Components {
		for ii := range m.Components[i].Components() {
			if button, ok := m.Components[i].Components()[ii].(ButtonComponent); ok {
				buttons = append(buttons, button)
			}
		}
	}
	return buttons
}

// ButtonByID returns a ButtonComponent with the specific customID from this Message
func (m *Message) ButtonByID(customID string) *ButtonComponent {
	for i := range m.Components {
		for ii := range m.Components[i].Components() {
			if button, ok := m.Components[i].Components()[ii].(*ButtonComponent); ok && button.ID() == customID {
				return button
			}
		}
	}
	return nil
}

// SelectMenus returns all SelectMenuComponent(s) from this Message
func (m *Message) SelectMenus() []SelectMenuComponent {
	var selectMenus []SelectMenuComponent
	for i := range m.Components {
		for ii := range m.Components[i].Components() {
			if button, ok := m.Components[i].Components()[ii].(SelectMenuComponent); ok {
				selectMenus = append(selectMenus, button)
			}
		}
	}
	return selectMenus
}

// SelectMenuByID returns a SelectMenuComponent with the specific customID from this Message
func (m *Message) SelectMenuByID(customID string) *SelectMenuComponent {
	for i := range m.Components {
		for ii := range m.Components[i].Components() {
			if button, ok := m.Components[i].Components()[ii].(*SelectMenuComponent); ok && button.ID() == customID {
				return button
			}
		}
	}
	return nil
}

type MessageThread struct {
	GuildThread
	Member ThreadMember `json:"member"`
}

type MessageSticker struct {
	ID         snowflake.ID      `json:"id"`
	Name       string            `json:"name"`
	FormatType StickerFormatType `json:"format_type"`
}

// MessageReaction contains information about the reactions of a message_events
type MessageReaction struct {
	Count int   `json:"count"`
	Me    bool  `json:"me"`
	Emoji Emoji `json:"emoji"`
}

// MessageActivityType is the type of MessageActivity https://com/developers/docs/resources/channel#message-object-message-activity-types
type MessageActivityType int

// Constants for MessageActivityType
const (
	MessageActivityTypeJoin MessageActivityType = iota + 1
	MessageActivityTypeSpectate
	MessageActivityTypeListen
	_
	MessageActivityTypeJoinRequest
)

// MessageActivity is used for rich presence-related chat embeds in a Message
type MessageActivity struct {
	Type    MessageActivityType `json:"type"`
	PartyID *string             `json:"party_id,omitempty"`
}

// MessageApplication is used for rich presence-related chat embeds in a Message
type MessageApplication struct {
	ID          snowflake.ID `json:"id"`
	CoverImage  *string      `json:"cover_image,omitempty"`
	Description string       `json:"description"`
	Icon        *string      `json:"icon,omitempty"`
	Name        string       `json:"name"`
}

// MessageReference is a reference to another message
type MessageReference struct {
	MessageID       *snowflake.ID `json:"message_id"`
	ChannelID       *snowflake.ID `json:"channel_id,omitempty"`
	GuildID         *snowflake.ID `json:"guild_id,omitempty"`
	FailIfNotExists bool          `json:"fail_if_not_exists,omitempty"`
}

// MessageInteraction is sent on the Message object when the message_events is a response to an interaction
type MessageInteraction struct {
	ID   snowflake.ID    `json:"id"`
	Type InteractionType `json:"type"`
	Name string          `json:"name"`
	User User            `json:"user"`
}

type MessageBulkDelete struct {
	Messages []snowflake.ID `json:"messages"`
}

// The MessageFlags of a Message
type MessageFlags int64

// Constants for MessageFlags
const (
	MessageFlagCrossposted MessageFlags = 1 << iota
	MessageFlagIsCrosspost
	MessageFlagSuppressEmbeds
	MessageFlagSourceMessageDeleted
	MessageFlagUrgent
	MessageFlagHasThread
	MessageFlagEphemeral
	MessageFlagLoading              // Message is an interaction of type 5, awaiting further response
	MessageFlagsNone   MessageFlags = 0
)

// Add allows you to add multiple bits together, producing a new bit
func (f MessageFlags) Add(bits ...MessageFlags) MessageFlags {
	for _, bit := range bits {
		f |= bit
	}
	return f
}

// Remove allows you to subtract multiple bits from the first, producing a new bit
func (f MessageFlags) Remove(bits ...MessageFlags) MessageFlags {
	for _, bit := range bits {
		f &^= bit
	}
	return f
}

// Has will ensure that the bit includes all the bits entered
func (f MessageFlags) Has(bits ...MessageFlags) bool {
	for _, bit := range bits {
		if (f & bit) != bit {
			return false
		}
	}
	return true
}

// Missing will check whether the bit is missing any one of the bits
func (f MessageFlags) Missing(bits ...MessageFlags) bool {
	for _, bit := range bits {
		if (f & bit) != bit {
			return true
		}
	}
	return false
}
