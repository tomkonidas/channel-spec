# ChannelSpec

A framework-agnostic DSL for defining and validating realtime channel contracts
in Elixir.

> [!WARNING]
> Early development. APIs are expected to change.

## What is ChannelSpec?

ChannelSpec is a declarative specification layer for realtime communication
systems.

It lets you define a single source of truth for how clients and servers
interact over message-based channels—covering incoming events, payloads,
replies, and documentation in one place.

Instead of scattering channel behavior across controllers, handlers, and docs,
ChannelSpec centralizes the contract so it can be:

- Documented consistently
- Validated at runtime or compile time
- Used to generate API specifications (e.g. AsyncAPI)
- Extended with tooling for testing and linting

ChannelSpec is framework-agnostic and is designed to model realtime
communication patterns such as [Phoenix Channels](https://phoenix.hexdocs.pm/channels.html),
WebSocket APIs, and other message-based pub/sub systems. The library itself
does not depend on any specific realtime framework.

## Why it exists

Realtime systems are often implicit.

Event names, payload shapes, and response semantics tend to live in code rather
than in a shared contract. This makes APIs harder to reason about, document,
and evolve safely.

ChannelSpec makes these contracts explicit.

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

      reply :ok,
        payload: MyApp.JoinSuccess,
        description: "Successfully joined"

      reply :error,
        payload: MyApp.JoinError,
        description: "Join failed"

      tags ["auth"]
    end

    outgoing "joined" do
      description "A user joined the room"
      payload MyApp.JoinedPayload
      tags ["presence"]
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
      replies: [
        %ChannelSpec.Reply{
          status: :ok,
          payload: MyApp.JoinSuccess,
          description: "Successfully joined"
        },
        %ChannelSpec.Reply{
          status: :error,
          payload: MyApp.JoinError,
          description: "Join failed"
        }
      ],
      tags: ["auth"]
    }
  ],
  outgoing: [
    %ChannelSpec.Event{
      name: "joined",
      description: "A user joined the room",
      payload: MyApp.JoinedPayload,
      tags: ["presence"]
    }
  ]
}
```

## Goals

ChannelSpec is designed as a foundation for tooling around realtime APIs.

From a single channel specification, you can generate:

- Human-readable documentation
- AsyncAPI specifications
- Validation rules for incoming and outgoing messages
- Shared contracts between backend and client systems

## Supported Features

- Channel topics
- Incoming events
- Outgoing events
- Payload definitions
- Reply definitions (success / error patterns)
- Event tagging
- Runtime introspection

## Installation

Add `:channel_spec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:channel_spec, "~> 0.1"}
  ]
end
```

Import `:channel_spec` formatter rules in `.formatter.exs`:

```elixir
[
  # ...
  import_deps: [..., :channel_spec]
  # ...
]
```
