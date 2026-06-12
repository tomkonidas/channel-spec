defmodule ChannelSpec.Spec do
  @moduledoc """
  Represents the specification for a realtime channel.

  A channel specification describes a channel identifier, its events,
  and any associated documentation or metadata.
  """

  alias ChannelSpec.Event

  @typedoc """
  Identifies a realtime channel.

  The format is framework-specific and may be a string, atom,
  tuple, or any other term used to identify a channel.

  ## Examples

      "room:*"
      :notifications
      {:room, 123}

  """
  @type channel_identifier :: term()

  @typedoc """
  A human-readable description.
  """
  @type description :: String.t()

  @typedoc """
  A collection of event specifications.
  """
  @type events :: [Event.t()]

  @typedoc """
  Represents a realtime channel specification.
  """
  @type t :: %__MODULE__{
          topic: channel_identifier() | nil,
          description: description() | nil,
          incoming: events(),
          outgoing: events()
        }

  defstruct [
    :topic,
    :description,
    incoming: [],
    outgoing: []
  ]
end
