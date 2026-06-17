defmodule ChannelSpec.ValidationError do
  @moduledoc """
  Raised when a channel specification is invalid.

  This exception is typically raised at compile time while ChannelSpec
  validates channel definitions and event contracts.
  """

  defexception [:message]
end
