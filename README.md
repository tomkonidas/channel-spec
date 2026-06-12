# ChannelSpec

A framework-agnostic DSL for specifying, documenting, and validating realtime
channel contracts in Elixir.

> [!WARNING]
> Early development. APIs are expected to change.

## What is ChannelSpec?

ChannelSpec provides a declarative way to describe realtime channel APIs.

By defining channel contracts in code, applications can:

- Document incoming and outgoing events
- Describe event payloads and replies
- Generate AsyncAPI specifications
- Validate contracts
- Build tooling around a single source of truth

ChannelSpec is framework-agnostic and is designed to model the realtime
communication patterns used by systems such as
[Phoenix Channels](https://phoenix.hexdocs.pm/channels.html) and
[Hologram Realtime](https://hologram.page/docs/realtime).

The library itself does not depend on any specific realtime framework.

## Example

```elixir
defmodule MyApp.RoomChannel do
  use ChannelSpec

  channel_spec do
    topic "room:*"
    description "Realtime chat rooms"

    incoming "join" do
      description "Join a room"
      payload MyApp.JoinPayload
      reply MyApp.JoinReply
      tags ["auth"]
    end
  end
end
```

The specification can be accessed at runtime:

```elixir
MyApp.RoomChannel.__channel_spec__()
```

Which returns:

```elixir
%ChannelSpec.Spec{
  topic: "room:*",
  description: "Realtime chat rooms",
  incoming: [
    %ChannelSpec.Event{
      name: "join",
      description: "Join a room",
      payload: MyApp.JoinPayload,
      reply: MyApp.JoinReply,
      deprecated: false,
      examples: [],
      tags: ["auth"],
      metadata: %{}
    }
  ],
  outgoing: []
}
```

## Goals

ChannelSpec aims to provide a single source of truth for realtime channel APIs.

From a channel specification, tooling may be able to generate:

- AsyncAPI documents
- Human-readable documentation
- Validation rules

## Current Status

Currently supported:

- Channel identifiers (`topic/1`)
- Channel descriptions
- Incoming events
- Event descriptions
- Event payloads
- Event tags
- Event reply payloads

Planned:

- Outgoing events
- Examples
- Metadata
- AsyncAPI generation
- Documentation generation
- Contract validation

## Installation

Add `:channel_spec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:channel_spec, "~> 0.1"}
  ]
end
```
