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

  @doc """
  Defines the payload module for an event.

  The payload is expected to be a module that describes the structure
  of the incoming or outgoing message.

  ## Example

      incoming "join" do
        payload MyApp.JoinPayload
      end

  """
  @spec payload(module()) :: Macro.t()
  defmacro payload(mod) when is_atom(mod) do
    quote do
      {:payload, unquote(mod)}
    end
  end
end
