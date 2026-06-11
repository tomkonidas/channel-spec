defmodule ChannelSpec do
  @moduledoc """
  A DSL for defining Phoenix Channel specifications.

  Channel specifications describe the contract between channel clients and
  servers, including topics, events, payloads, replies, and metadata.

  ## Example

      defmodule MyAppWeb.RoomChannel do
        use ChannelSpec

        channel_spec do
          topic "room:*"
        end
      end

      MyAppWeb.RoomChannel.__channel_spec__()

  """

  @doc false
  @spec __using__(keyword()) :: Macro.t()
  defmacro __using__(_opts) do
    quote do
      import ChannelSpec

      Module.register_attribute(__MODULE__, :channel_spec_topic, [])
      Module.register_attribute(__MODULE__, :channel_spec_description, [])
      Module.register_attribute(__MODULE__, :channel_spec_incoming, accumulate: true)

      @before_compile ChannelSpec
    end
  end

  @doc """
  Defines a channel specification.

  The block may contain topic declarations and, in future versions,
  incoming and outgoing event definitions.

  ## Example

      channel_spec do
        topic "room:*"
      end

  """
  @spec channel_spec(do: Macro.t()) :: Macro.t()
  defmacro channel_spec(do: block) do
    block
  end

  @doc """
  Defines the channel topic pattern.

  ## Examples

      topic "room:*"
      topic "user:*"

  """
  @spec topic(String.t()) :: Macro.t()
  defmacro topic(topic) do
    quote do
      @channel_spec_topic unquote(topic)
    end
  end

  @doc """
  Defines a human-readable description for the channel.

  ## Example

      description "Chat room channel"

  """
  @spec description(String.t()) :: Macro.t()
  defmacro description(description) do
    quote do
      @channel_spec_description unquote(description)
    end
  end

  @doc """
  Defines an incoming channel event.

  ## Example

      incoming "new_msg"

  """
  @spec incoming(String.t()) :: Macro.t()
  defmacro incoming(name) do
    quote do
      @channel_spec_incoming %ChannelSpec.Event{
        name: unquote(name)
      }
    end
  end

  @doc false
  @spec __before_compile__(Macro.Env.t()) :: Macro.t()
  defmacro __before_compile__(env) do
    topic = Module.get_attribute(env.module, :channel_spec_topic)
    description = Module.get_attribute(env.module, :channel_spec_description)

    incoming =
      env.module
      |> Module.get_attribute(:channel_spec_incoming)
      |> Enum.reverse()

    quote do
      @channel_spec %ChannelSpec.Spec{
        topic: unquote(topic),
        description: unquote(description),
        incoming: unquote(Macro.escape(incoming)),
        outgoing: []
      }

      @doc false
      @spec __channel_spec__() :: ChannelSpec.Spec.t()
      def __channel_spec__, do: @channel_spec
    end
  end
end
