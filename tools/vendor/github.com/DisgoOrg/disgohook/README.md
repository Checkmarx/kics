# disgohook

[![Go Reference](https://pkg.go.dev/badge/github.com/DisgoOrg/disgohook.svg)](https://pkg.go.dev/github.com/DisgoOrg/disgohook)
[![Go Report](https://goreportcard.com/badge/github.com/DisgoOrg/disgohook)](https://goreportcard.com/report/github.com/DisgoOrg/disgohook)
[![Go Version](https://img.shields.io/github/go-mod/go-version/DisgoOrg/disgohook)](https://golang.org/doc/devel/release.html)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/DisgoOrg/disgohook/blob/master/LICENSE)
[![Disgo Version](https://img.shields.io/github/v/release/DisgoOrg/disgohook)](https://github.com/DisgoOrg/disgohook/releases/latest)
[![Disgo Discord](https://img.shields.io/badge/Disgo%20Discord-blue.svg)](https://discord.gg/wVDMGe3EmB)

DisgoHook is a simple [Discord Webhook](https://discord.com/developers/docs/resources/webhook) library written
in [Go](https://golang.org/) aimed to be easy to use

---

**With v1 of [disgo](https://github.com/DisgoOrg/disgo) webhook support will be included there & this repo will be archived**

---

## Getting Started

### Installing

```sh
go get github.com/DisgoOrg/disgohook
```

### Usage

Import the package into your project.

```go
import "github.com/DisgoOrg/disgohook"
```

Create a new Webhook by `webhook_id/webhook_token`. (*This WebhookClient should be only created once as it holds important state*)

As first param you can optionally pass your own [*http.Client](https://pkg.go.dev/net/http#Client) and as second parameter you can pass your own logger implementing [this](https://github.com/DisgoOrg/log/blob/master/logger.go) interface.
This webhook then can be used to send, edit and delete messages

### Send Message
```go
webhook, err := disgohook.NewWebhookClientByToken(nil, nil, "webhook_id/webhook_token")

message, err := webhook.SendContent("hello world!")
message, err := webhook.SendEmbeds(api.NewEmbedBuilder().
	SetDescription("hello world!").
	Build(),
)
message, err := webhook.SendMessage(api.NewWebhookMessageCreateBuilder().
	SetContent("hello world!").
	Build(),
)
```

### Edit Message
```go
webhook, err := disgohook.NewWebhookClientByToken(nil, nil, "webhook_id/webhook_token")

message, err := webhook.EditContent("870741249114652722", "hello world!")
message, err := webhook.EditEmbeds("870741249114652722", 
	api.NewEmbedBuilder().
	SetDescription("hello world!").
	Build(),
)
message, err := webhook.EditMessage("870741249114652722", 
	api.NewWebhookMessageUpdateBuilder().
	SetContent("hello world!").
	Build(), 
)
```

### Delete Message
```go
webhook, err := disgohook.NewWebhookClientByToken(nil, nil, "webhook_id/webhook_token")

err := webhook.DeleteMessage("870741249114652722")
```

## Documentation

Documentation is unfinished and can be found under

* [![Go Reference](https://pkg.go.dev/badge/github.com/DisgoOrg/disgohook.svg)](https://pkg.go.dev/github.com/DisgoOrg/disgohook)
* [![Discord Webhook Documentation](https://img.shields.io/badge/Discord%20Webhook%20Documentation-blue.svg)](https://discord.com/developers/docs/resources/webhook)

## Examples

You can find examples under [example](https://github.com/DisgoOrg/disgohook/tree/master/example)
and [dislog](https://github.com/DisgoOrg/dislog)

## Troubleshooting

For help feel free to open an issues or reach out on [Discord](https://discord.gg/wVDMGe3EmB)

## Contributing

Contributions are welcomed but for bigger changes please first reach out via [Discord](https://discord.gg/wVDMGe3EmB) or
create an issue to discuss your intentions and ideas.

## License

Distributed under
the [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/DisgoOrg/disgohook/blob/master/LICENSE)
. See LICENSE for more information.
