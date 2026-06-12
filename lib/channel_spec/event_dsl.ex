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

  @doc """
  Defines the reply payload for an event.

  Replies are typically associated with incoming events.

  ## Example

      incoming "join" do
        reply MyApp.JoinReply
      end

  """
  @spec reply(module()) :: Macro.t()
  defmacro reply(mod) when is_atom(mod) do
    quote do
      {:reply, unquote(mod)}
    end
  end

  @doc """
  Associates tags with an event.

  ## Example

      incoming "join" do
        tags ["auth", "presence"]
      end

  """
  @spec tags([String.t()]) :: Macro.t()
  defmacro tags(tags) when is_list(tags) do
    quote do
      {:tags, unquote(tags)}
    end
  end
end
