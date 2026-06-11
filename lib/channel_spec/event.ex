defmodule ChannelSpec.Event do
  @moduledoc """
  Represents an incoming or outgoing channel event.

  Events are used to describe the contract between channel clients and
  servers, including payload schemas, reply schemas, examples, and metadata.
  """

  @typedoc """
  The name of a channel event.
  """
  @type name :: String.t()

  @typedoc """
  A human-readable description.
  """
  @type description :: String.t()

  @typedoc """
  A schema module describing an event payload.

  This will typically be an Ecto embedded schema or another module capable of
  describing a payload contract.
  """
  @type payload :: module()

  @typedoc """
  An example event payload used for documentation purposes.
  """
  @type example :: map()

  @typedoc """
  Arbitrary metadata associated with an event.
  """
  @type metadata :: %{optional(atom()) => term()}

  @typedoc """
  A schema module describing the payload returned in response to an event.

  Reply schemas are typically only applicable to incoming events.
  """
  @type reply :: module()

  @typedoc """
  Represents a Phoenix Channel event specification.
  """
  @type t :: %__MODULE__{
          name: name(),
          description: description() | nil,
          payload: payload() | nil,
          reply: reply() | nil,
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
    :reply,
    deprecated: false,
    examples: [],
    tags: [],
    metadata: %{}
  ]
end
