defmodule ChannelSpec.Spec do
  @moduledoc """
  Represents the specification for a Phoenix Channel.

  A channel specification contains information about the topic,
  incoming messages, outgoing messages, and associated metadata.
  """

  alias ChannelSpec.Event

  @typedoc """
  A Phoenix Channel topic pattern.

  ## Examples

      "room:*"
      "user:*"
      "notifications"

  """
  @type topic :: String.t()

  @typedoc """
  A human-readable description.
  """
  @type description :: String.t()

  @typedoc """
  A collection of event specifications.
  """
  @type events :: [Event.t()]

  @typedoc """
  Represents a Phoenix Channel specification.
  """
  @type t :: %__MODULE__{
          topic: topic() | nil,
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
