package rest

import (
	"time"

	"github.com/disgoorg/disgo/discord"
	"github.com/disgoorg/snowflake/v2"
)

var _ Threads = (*threadImpl)(nil)

func NewThreads(client Client) Threads {
	return &threadImpl{client: client}
}

type Threads interface {
	// CreateThreadFromMessage does not work for discord.ChannelTypeGuildForum channels.
	CreateThreadFromMessage(channelID snowflake.ID, messageID snowflake.ID, threadCreateFromMessage discord.ThreadCreateFromMessage, opts ...RequestOpt) (thread *discord.GuildThread, err error)
	CreateThreadInForum(channelID snowflake.ID, threadCreateInForum discord.ForumThreadCreate, opts ...RequestOpt) (thread *discord.ForumThread, err error)
	CreateThread(channelID snowflake.ID, threadCreate discord.ThreadCreate, opts ...RequestOpt) (thread *discord.GuildThread, err error)
	JoinThread(threadID snowflake.ID, opts ...RequestOpt) error
	LeaveThread(threadID snowflake.ID, opts ...RequestOpt) error
	AddThreadMember(threadID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) error
	RemoveThreadMember(threadID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) error
	GetThreadMember(threadID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) (threadMember *discord.ThreadMember, err error)
	GetThreadMembers(threadID snowflake.ID, opts ...RequestOpt) (threadMembers []discord.ThreadMember, err error)

	GetPublicArchivedThreads(channelID snowflake.ID, before time.Time, limit int, opts ...RequestOpt) (threads *discord.GetThreads, err error)
	GetPrivateArchivedThreads(channelID snowflake.ID, before time.Time, limit int, opts ...RequestOpt) (threads *discord.GetThreads, err error)
	GetJoinedPrivateArchivedThreads(channelID snowflake.ID, before time.Time, limit int, opts ...RequestOpt) (threads *discord.GetThreads, err error)
}

type threadImpl struct {
	client Client
}

func (s *threadImpl) CreateThreadFromMessage(channelID snowflake.ID, messageID snowflake.ID, threadCreateWithMessage discord.ThreadCreateFromMessage, opts ...RequestOpt) (thread *discord.GuildThread, err error) {
	err = s.client.Do(CreateThreadWithMessage.Compile(nil, channelID, messageID), threadCreateWithMessage, &thread, opts...)
	return
}

func (s *threadImpl) CreateThreadInForum(channelID snowflake.ID, threadCreateInForum discord.ForumThreadCreate, opts ...RequestOpt) (thread *discord.ForumThread, err error) {
	body, err := threadCreateInForum.ToBody()
	if err != nil {
		return
	}

	err = s.client.Do(CreateThread.Compile(nil, channelID), body, &thread, opts...)
	return
}

func (s *threadImpl) CreateThread(channelID snowflake.ID, threadCreate discord.ThreadCreate, opts ...RequestOpt) (thread *discord.GuildThread, err error) {
	err = s.client.Do(CreateThread.Compile(nil, channelID), threadCreate, &thread, opts...)
	return
}

func (s *threadImpl) JoinThread(threadID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(JoinThread.Compile(nil, threadID), nil, nil, opts...)
}

func (s *threadImpl) LeaveThread(threadID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(LeaveThread.Compile(nil, threadID), nil, nil, opts...)
}

func (s *threadImpl) AddThreadMember(threadID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(AddThreadMember.Compile(nil, threadID, userID), nil, nil, opts...)
}

func (s *threadImpl) RemoveThreadMember(threadID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) error {
	return s.client.Do(RemoveThreadMember.Compile(nil, threadID, userID), nil, nil, opts...)
}

func (s *threadImpl) GetThreadMember(threadID snowflake.ID, userID snowflake.ID, opts ...RequestOpt) (threadMember *discord.ThreadMember, err error) {
	err = s.client.Do(GetThreadMember.Compile(nil, threadID, userID), nil, &threadMember, opts...)
	return
}

func (s *threadImpl) GetThreadMembers(threadID snowflake.ID, opts ...RequestOpt) (threadMembers []discord.ThreadMember, err error) {
	err = s.client.Do(GetThreadMembers.Compile(nil, threadID), nil, &threadMembers, opts...)
	return
}

func (s *threadImpl) GetPublicArchivedThreads(channelID snowflake.ID, before time.Time, limit int, opts ...RequestOpt) (threads *discord.GetThreads, err error) {
	queryValues := discord.QueryValues{}
	if !before.IsZero() {
		queryValues["before"] = before.Format(time.RFC3339)
	}
	if limit != 0 {
		queryValues["limit"] = limit
	}
	err = s.client.Do(GetArchivedPublicThreads.Compile(queryValues, channelID), nil, &threads, opts...)
	return
}

func (s *threadImpl) GetPrivateArchivedThreads(channelID snowflake.ID, before time.Time, limit int, opts ...RequestOpt) (threads *discord.GetThreads, err error) {
	queryValues := discord.QueryValues{}
	if !before.IsZero() {
		queryValues["before"] = before.Format(time.RFC3339)
	}
	if limit != 0 {
		queryValues["limit"] = limit
	}
	err = s.client.Do(GetArchivedPrivateThreads.Compile(queryValues, channelID), nil, &threads, opts...)
	return
}

func (s *threadImpl) GetJoinedPrivateArchivedThreads(channelID snowflake.ID, before time.Time, limit int, opts ...RequestOpt) (threads *discord.GetThreads, err error) {
	queryValues := discord.QueryValues{}
	if !before.IsZero() {
		queryValues["before"] = before.Format(time.RFC3339)
	}
	if limit != 0 {
		queryValues["limit"] = limit
	}
	err = s.client.Do(GetJoinedAchievedPrivateThreads.Compile(queryValues, channelID), nil, &threads, opts...)
	return
}
