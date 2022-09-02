package discord

import (
	"fmt"
	"strings"
	"time"

	"github.com/disgoorg/snowflake/v2"
)

type Application struct {
	ID                    snowflake.ID        `json:"id"`
	Name                  string              `json:"name"`
	Icon                  *string             `json:"icon,omitempty"`
	Description           string              `json:"description"`
	RPCOrigins            []string            `json:"rpc_origins"`
	BotPublic             bool                `json:"bot_public"`
	BotRequireCodeGrant   bool                `json:"bot_require_code_grant"`
	TermsOfServiceURL     *string             `json:"terms_of_service_url,omitempty"`
	PrivacyPolicyURL      *string             `json:"privacy_policy_url,omitempty"`
	CustomInstallationURL *string             `json:"custom_install_url,omitempty"`
	InstallationParams    *InstallationParams `json:"install_params"`
	Tags                  []string            `json:"tags"`
	Owner                 *User               `json:"owner,omitempty"`
	Summary               string              `json:"summary"`
	VerifyKey             string              `json:"verify_key"`
	Team                  *Team               `json:"team,omitempty"`
	GuildID               *snowflake.ID       `json:"guild_id,omitempty"`
	PrimarySkuID          *snowflake.ID       `json:"primary_sku_id,omitempty"`
	Slug                  *string             `json:"slug,omitempty"`
	Cover                 *string             `json:"cover_image,omitempty"`
	Flags                 ApplicationFlags    `json:"flags,omitempty"`
}

func (a Application) IconURL(opts ...CDNOpt) *string {
	if a.Icon == nil {
		return nil
	}
	url := formatAssetURL(ApplicationIcon, opts, a.ID, *a.Icon)
	return &url
}

func (a Application) CoverURL(opts ...CDNOpt) *string {
	if a.Cover == nil {
		return nil
	}
	url := formatAssetURL(ApplicationCover, opts, a.ID, *a.Cover)
	return &url
}

func (a Application) CreatedAt() time.Time {
	return a.ID.Time()
}

type PartialApplication struct {
	ID    snowflake.ID     `json:"id"`
	Flags ApplicationFlags `json:"flags"`
}

type AuthorizationInformation struct {
	Application Application   `json:"application"`
	Scopes      []OAuth2Scope `json:"scopes"`
	Expires     time.Time     `json:"expires"`
	User        *User         `json:"user"`
}

type InstallationParams struct {
	Scopes      []OAuth2Scope `json:"scopes"`
	Permissions Permissions   `json:"permissions"`
}

// OAuth2Scope are the scopes you can request in the OAuth2 flow.
type OAuth2Scope string

const (
	// OAuth2ScopeActivitiesRead allows your app to fetch data from a user's "Now Playing/Recently Played" list - requires Discord approval
	OAuth2ScopeActivitiesRead OAuth2Scope = "activities.read"
	// OAuth2ScopeActivitiesWrite allows your app to update a user's activity - requires Discord approval (NOT REQUIRED FOR GAMESDK ACTIVITY MANAGER)
	OAuth2ScopeActivitiesWrite OAuth2Scope = "activities.write"

	// OAuth2ScopeApplicationsBuildsRead allows your app to read build data for a user's applications
	OAuth2ScopeApplicationsBuildsRead OAuth2Scope = "applications.builds.read"
	// OAuth2ScopeApplicationsBuildsUpload allows your app to upload/update builds for a user's applications - requires Discord approval
	OAuth2ScopeApplicationsBuildsUpload OAuth2Scope = "applications.builds.upload"

	OAuth2ScopeApplicationsCommands                  OAuth2Scope = "applications.commands"
	OAuth2ScopeApplicationsCommandsUpdate            OAuth2Scope = "applications.commands.update"
	OAuth2ScopeApplicationsCommandsPermissionsUpdate OAuth2Scope = "applications.commands.permissions.update"
	OAuth2ScopeApplicationsEntitlements              OAuth2Scope = "applications.entitlements"
	OAuth2ScopeApplicationsStoreUpdate               OAuth2Scope = "applications.store.update"

	OAuth2ScopeRPC                  OAuth2Scope = "rpc"
	OAuth2ScopeRPCNotificationsRead OAuth2Scope = "rpc.notifications.read"
	OAuth2ScopeRPCVoiceWrite        OAuth2Scope = "rpc.voice.write"
	OAuth2ScopeRPCVoiceRead         OAuth2Scope = "rpc.voice.read"
	OAuth2ScopeRPCActivitiesWrite   OAuth2Scope = "rpc.activities.write"

	OAuth2ScopeGuilds            OAuth2Scope = "guilds"
	OAuth2ScopeGuildsJoin        OAuth2Scope = "guilds.join"
	OAuth2ScopeGuildsMembersRead OAuth2Scope = "guilds.members.read"
	OAuth2ScopeGDMJoin           OAuth2Scope = "gdm.join"

	OAuth2ScopeRelationshipsRead OAuth2Scope = "relationships.read"
	OAuth2ScopeIdentify          OAuth2Scope = "identify"
	OAuth2ScopeEmail             OAuth2Scope = "email"
	OAuth2ScopeConnections       OAuth2Scope = "connections"
	OAuth2ScopeBot               OAuth2Scope = "bot"
	OAuth2ScopeMessagesRead      OAuth2Scope = "messages.read"
	OAuth2ScopeWebhookIncoming   OAuth2Scope = "webhook.incoming"
)

func (s OAuth2Scope) String() string {
	return string(s)
}

const ScopeSeparator = " "

func JoinScopes(scopes []OAuth2Scope) string {
	strScopes := make([]string, len(scopes))
	for i, scope := range scopes {
		strScopes[i] = scope.String()
	}
	return strings.Join(strScopes, ScopeSeparator)
}

func SplitScopes(joinedScopes string) []OAuth2Scope {
	var scopes []OAuth2Scope
	for _, scope := range strings.Split(joinedScopes, ScopeSeparator) {
		scopes = append(scopes, OAuth2Scope(scope))
	}
	return scopes
}

func HasScope(scope OAuth2Scope, scopes ...OAuth2Scope) bool {
	for _, s := range scopes {
		if s == scope {
			return true
		}
	}
	return false
}

type TokenType string

const (
	TokenTypeBearer TokenType = "Bearer"
	TokenTypeBot    TokenType = "Bot"
)

func (t TokenType) String() string {
	return string(t)
}

func (t TokenType) Apply(token string) string {
	return fmt.Sprintf("%s %s", t.String(), token)
}

// ApplicationFlags (https://discord.com/developers/docs/resources/application#application-object-application-flags)
type ApplicationFlags int

const (
	ApplicationFlagGatewayPresence = 1 << (iota + 12)
	ApplicationFlagGatewayPresenceLimited
	ApplicationFlagGatewayGuildMembers
	ApplicationFlagGatewayGuildMemberLimited
	ApplicationFlagVerificationPendingGuildLimit
	ApplicationFlagEmbedded
	ApplicationFlagGatewayMessageContent
	ApplicationFlagGatewayMessageContentLimited
	_
	_
	_
	ApplicationFlagApplicationCommandBadge
)

// Add allows you to add multiple bits together, producing a new bit
func (f ApplicationFlags) Add(bits ...ApplicationFlags) ApplicationFlags {
	for _, bit := range bits {
		f |= bit
	}
	return f
}

// Remove allows you to subtract multiple bits from the first, producing a new bit
func (f ApplicationFlags) Remove(bits ...ApplicationFlags) ApplicationFlags {
	for _, bit := range bits {
		f &^= bit
	}
	return f
}

// Has will ensure that the bit includes all the bits entered
func (f ApplicationFlags) Has(bits ...ApplicationFlags) bool {
	for _, bit := range bits {
		if (f & bit) != bit {
			return false
		}
	}
	return true
}

// Missing will check whether the bit is missing any one of the bits
func (f ApplicationFlags) Missing(bits ...ApplicationFlags) bool {
	for _, bit := range bits {
		if (f & bit) != bit {
			return true
		}
	}
	return false
}

type Team struct {
	Icon    *string      `json:"icon"`
	ID      snowflake.ID `json:"id"`
	Members []TeamMember `json:"members"`
	Name    string       `json:"name"`
	OwnerID snowflake.ID `json:"owner_user_id"`
}

func (t Team) IconURL(opts ...CDNOpt) *string {
	if t.Icon == nil {
		return nil
	}
	url := formatAssetURL(TeamIcon, opts, t.ID, *t.Icon)
	return &url
}

func (t Team) CreatedAt() time.Time {
	return t.ID.Time()
}

type TeamMember struct {
	MembershipState MembershipState   `json:"membership_state"`
	Permissions     []TeamPermissions `json:"permissions"`
	TeamID          snowflake.ID      `json:"team_id"`
	User            User              `json:"user"`
}

type MembershipState int

const (
	MembershipStateInvited = iota + 1
	MembershipStateAccepted
)

type TeamPermissions string

const (
	TeamPermissionAdmin = "*"
)
