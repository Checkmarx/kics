<!-- omit in toc -->
# go-teams-notify

A package to send messages to Microsoft Teams (channels)

[![Latest release][githubtag-image]][githubtag-url]
[![Go Reference][goref-image]][goref-url]
[![License][license-image]][license-url]
[![Validate Codebase](https://github.com/atc0005/go-teams-notify/workflows/Validate%20Codebase/badge.svg)](https://github.com/atc0005/go-teams-notify/actions?query=workflow%3A%22Validate+Codebase%22)
[![Validate Docs](https://github.com/atc0005/go-teams-notify/workflows/Validate%20Docs/badge.svg)](https://github.com/atc0005/go-teams-notify/actions?query=workflow%3A%22Validate+Docs%22)
[![Lint and Build using Makefile](https://github.com/atc0005/go-teams-notify/workflows/Lint%20and%20Build%20using%20Makefile/badge.svg)](https://github.com/atc0005/go-teams-notify/actions?query=workflow%3A%22Lint+and+Build+using+Makefile%22)
[![Quick Validation](https://github.com/atc0005/go-teams-notify/workflows/Quick%20Validation/badge.svg)](https://github.com/atc0005/go-teams-notify/actions?query=workflow%3A%22Quick+Validation%22)

<!-- omit in toc -->
## Table of contents

- [Project home](#project-home)
- [Overview](#overview)
- [Features](#features)
- [Project Status](#project-status)
- [Supported Releases](#supported-releases)
- [Changelog](#changelog)
- [Usage](#usage)
  - [Add this project as a dependency](#add-this-project-as-a-dependency)
  - [Webhook URLs](#webhook-urls)
    - [Expected format](#expected-format)
    - [How to create a webhook URL (Connector)](#how-to-create-a-webhook-url-connector)
  - [Examples](#examples)
    - [Basic](#basic)
    - [Add an Action](#add-an-action)
    - [Disable webhook URL prefix validation](#disable-webhook-url-prefix-validation)
    - [Enable custom patterns' validation](#enable-custom-patterns-validation)
- [Used by](#used-by)
- [References](#references)

## Project home

See [our GitHub repo](https://github.com/atc0005/go-teams-notify) for the
latest code, to file an issue or submit improvements for review and potential
inclusion into the project.

## Overview

The `goteamsnotify` package (aka, `go-teams-notify`) allows sending messages
to a Microsoft Teams channel.

Simple messages can be composed of only a title and a text body. More complex
messages can be composed of multiple sections, key/value pairs (aka, `Facts`)
and/or externally hosted images. See the [Features](#features) list for more
information.

## Features

- Submit simple or complex messages to Microsoft Teams
  - simple messages consist of only a title and a text body (one or more
    strings)
  - complex messages consist of one or more sections, key/value pairs (aka,
    `Facts`) and/or externally hosted images. or images (hosted externally)
- Support for [`Actions`][msgcard-ref-actions], allowing users to take quick
  actions within Microsoft Teams
- Configurable validation of webhook URLs
  - enabled by default, attempts to match most common known webhook URL
    patterns
  - option to disable validation entirely
  - option to use custom validation patterns
- Configurable validation of `MessageCard` type
  - default assertion that bare-minimum required fields are present
  - support for providing a custom validation function to override default
    validation behavior
- Configurable timeouts
- Configurable retry support

## Project Status

In short:

- The upstream project is no longer being actively developed or maintained.
- This fork is now a standalone project, accepting contributions, bug reports
  and feature requests.
- Others have also taken an interest in [maintaining their own
  forks](https://github.com/atc0005/go-teams-notify/network/members) of the
  original project. See those forks for other ideas/changes that you may find
  useful.

For more details, see the
[Releases](https://github.com/atc0005/go-teams-notify/releases) section or our
[Changelog](https://github.com/atc0005/go-teams-notify/blob/master/CHANGELOG.md).

## Supported Releases

| Series   | Example  | Status              |
| -------- | -------- | ------------------- |
| `v1.x.x` | `v1.3.1` | Not Supported (EOL) |
| `v2.x.x` | `v2.6.0` | Supported           |

## Changelog

See the [`CHANGELOG.md`](CHANGELOG.md) file for the changes associated with
each release of this application. Changes that have been merged to `master`,
but not yet an official release may also be noted in the file under the
`Unreleased` section. A helpful link to the Git commit history since the last
official release is also provided for further review.

## Usage

### Add this project as a dependency

Assuming that you're using [Go
Modules](https://blog.golang.org/using-go-modules), add this line to your
imports like so:

```golang
import (
  // ...

  "github.com/atc0005/go-teams-notify/v2"
)
```

Depending on your editor and current settings, your editor may resolve the
import and update your `go.mod` and `go.sum` files accordingly. If not, review
these resources for further information:

- <https://blog.golang.org/using-go-modules>
- <https://golang.org/doc/modules/managing-dependencies>
- <https://golang.org/ref/mod>

See the [Examples](#examples) section for more details.

### Webhook URLs

#### Expected format

Valid webhook URLs for Microsoft Teams use one of several (confirmed) FQDNs
patterns:

- `outlook.office.com`
- `outlook.office365.com`
- `*.webhook.office.com`
  - e.g., `example.webhook.office.com`

Using a webhook URL with any of these FQDN patterns appears to give identical
results.

Here are complete, equivalent example webhook URLs from Microsoft's
documentation using the FQDNs above:

- <https://outlook.office.com/webhook/a1269812-6d10-44b1-abc5-b84f93580ba0@9e7b80c7-d1eb-4b52-8582-76f921e416d9/IncomingWebhook/3fdd6767bae44ac58e5995547d66a4e4/f332c8d9-3397-4ac5-957b-b8e3fc465a8c>
- <https://outlook.office365.com/webhook/a1269812-6d10-44b1-abc5-b84f93580ba0@9e7b80c7-d1eb-4b52-8582-76f921e416d9/IncomingWebhook/3fdd6767bae44ac58e5995547d66a4e4/f332c8d9-3397-4ac5-957b-b8e3fc465a8c>
- <https://example.webhook.office.com/webhookb2/a1269812-6d10-44b1-abc5-b84f93580ba0@9e7b80c7-d1eb-4b52-8582-76f921e416d9/IncomingWebhook/3fdd6767bae44ac58e5995547d66a4e4/f332c8d9-3397-4ac5-957b-b8e3fc465a8c>
  - note the `webhookb2` sub-URI specific to this FQDN pattern

All of these patterns when provided to this library should pass the default
validation applied. See the example further down for the option of disabling
webhook URL validation entirely.

#### How to create a webhook URL (Connector)

1. Open Microsoft Teams
1. Navigate to the channel where you wish to receive incoming messages from
   this application
1. Select `⋯` next to the channel name and then choose Connectors.
1. Scroll through the list of Connectors to Incoming Webhook, and choose Add.
1. Enter a name for the webhook, upload an image to associate with data from
   the webhook, and choose Create.
1. Copy the webhook URL to the clipboard and save it. You'll need the webhook
   URL for sending information to Microsoft Teams.
   - NOTE: While you can create another easily enough, you should treat this
     webhook URL as sensitive information as anyone with this unique URL is
     able to send messages (without authentication) into the associated
     channel.
1. Choose Done.

Credit:
[docs.microsoft.com](https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using#setting-up-a-custom-incoming-webhook),
[gist comment from
shadabacc3934](https://gist.github.com/chusiang/895f6406fbf9285c58ad0a3ace13d025#gistcomment-3562501)

### Examples

#### Basic

This is an example of a simple client application which uses this library.

File: [basic](./examples/basic/main.go)

#### Add an Action

This example illustrates adding an [`OpenUri Action`][msgcard-ref-actions] to
a message card. When used, this action triggers opening a URI in a separate
browser or application.

File: [actions](./examples/actions/main.go)

#### Disable webhook URL prefix validation

This example disables the validation webhook URLs, including the validation of
known prefixes so that custom/private webhook URL endpoints can be used (e.g.,
testing purposes).

File: [disable-validation](./examples/disable-validation/main.go)

#### Enable custom patterns' validation

This example demonstrates how to enable custom validation patterns for webhook
URLs.

File: [custom-validation](./examples/custom-validation/main.go)

## Used by

See the Known importers lists below for a dynamically updated list of projects
using either this library or the original project.

- [this fork](https://pkg.go.dev/github.com/atc0005/go-teams-notify/v2?tab=importedby)
- [original project](https://pkg.go.dev/github.com/dasrick/go-teams-notify/v2?tab=importedby)

## References

- [Original project](https://github.com/dasrick/go-teams-notify)
- [Forks of original project](https://github.com/atc0005/go-teams-notify/network/members)

- Microsoft Teams
  - MS Teams - adaptive cards
  ([de-de](https://docs.microsoft.com/de-de/outlook/actionable-messages/adaptive-card),
  [en-us](https://docs.microsoft.com/en-us/outlook/actionable-messages/adaptive-card))
  - MS Teams - send via connectors
  ([de-de](https://docs.microsoft.com/de-de/outlook/actionable-messages/send-via-connectors),
  [en-us](https://docs.microsoft.com/en-us/outlook/actionable-messages/send-via-connectors))
  - [adaptivecards.io](https://adaptivecards.io/designer)
  - [Legacy actionable message card reference][msgcard-ref]

[githubtag-image]: https://img.shields.io/github/release/atc0005/go-teams-notify.svg?style=flat
[githubtag-url]: https://github.com/atc0005/go-teams-notify

[goref-image]: https://pkg.go.dev/badge/github.com/atc0005/go-teams-notify/v2.svg
[goref-url]: https://pkg.go.dev/github.com/atc0005/go-teams-notify/v2

[license-image]: https://img.shields.io/github/license/atc0005/go-teams-notify.svg?style=flat
[license-url]: https://github.com/atc0005/go-teams-notify/blob/master/LICENSE

[msgcard-ref]: <https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference>
[msgcard-ref-actions]: <https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference#actions>
