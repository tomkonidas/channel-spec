defmodule ChannelSpec.EventDSL do
  @moduledoc """
  DSL used inside `incoming` and `outgoing` blocks.
  """

  @doc """
  Sets the event description.

  ## Example

      incoming "join" do
        description "User joins room"
      end

  """
  @spec description(String.t()) :: Macro.t()
  defmacro description(value) when is_binary(value) do
    quote do
      {:description, unquote(value)}
    end
  end
end
