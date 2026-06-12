defmodule ChannelSpec.Reply do
  @moduledoc """
  Represents a possible reply for a channel event.

  Replies describe payloads that may be returned in response to an incoming
  event, such as successful or error responses.
  """

  @typedoc """
  The reply status.

  Common values include `:ok` and `:error`, though applications may define
  additional statuses as needed.
  """
  @type status :: atom()

  @typedoc """
  A human-readable description.
  """
  @type description :: String.t()

  @typedoc """
  A module describing the structure of a reply payload.

  This will typically be an Ecto embedded schema or another module used to
  define a reply contract.
  """
  @type payload :: module()

  @typedoc """
  Represents a reply specification for a channel event.
  """
  @type t :: %__MODULE__{
          status: status(),
          payload: payload() | nil,
          description: description() | nil
        }

  @enforce_keys [:status]
  defstruct [
    :status,
    :payload,
    :description
  ]
end
