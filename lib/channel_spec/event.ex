defmodule ChannelSpec.Event do
  @moduledoc """
  Represents an incoming or outgoing channel event.

  Events describe the contract between participants in a realtime channel,
  including payload definitions, reply definitions, examples, and metadata.
  """

  alias ChannelSpec.Reply

  @typedoc """
  The name of a channel event.
  """
  @type name :: String.t()

  @typedoc """
  A human-readable description.
  """
  @type description :: String.t()

  @typedoc """
  A module describing the structure of an event payload.

  This will typically be an Ecto embedded schema or another module used to
  define a payload contract.
  """
  @type payload :: module()

  @typedoc """
  An example payload used for documentation purposes.
  """
  @type example :: map()

  @typedoc """
  Arbitrary metadata associated with an event.
  """
  @type metadata :: %{optional(atom()) => term()}

  @typedoc """
  A module describing the payload returned in response to an event.

  Replies are typically only applicable to incoming events.
  """
  @type reply :: module()

  @typedoc """
  Represents an event specification for a realtime channel.
  """
  @type t :: %__MODULE__{
          name: name(),
          description: description() | nil,
          payload: payload() | nil,
          replies: [Reply.t()],
          deprecated: boolean(),
          examples: [example()],
          tags: [String.t()],
          metadata: metadata()
        }

  @enforce_keys [:name]
  defstruct [
    :name,
    :description,
    :payload,
    replies: [],
    deprecated: false,
    examples: [],
    tags: [],
    metadata: %{}
  ]
end
