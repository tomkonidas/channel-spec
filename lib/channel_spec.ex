defmodule ChannelSpec do
  @moduledoc """
  A DSL for defining realtime channel specifications.

  Channel specifications describe the contract between channel clients and
  servers, including topics, events, payloads, replies, and metadata.

  ## Example

      defmodule MyAppWeb.RoomChannel do
        use ChannelSpec

        channel_spec do
          topic "room:*"
          description "Realtime chat rooms"

          incoming "join" do
            descritpion "User joins room"
            payload MyApp.JoinPayload
            tags ["auth", "presence"]
          end
        end
      end

      MyAppWeb.RoomChannel.__channel_spec__()

  """

  alias ChannelSpec.Event
  alias ChannelSpec.Reply

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
      topic {:room, 123}

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

      description "Realtime chat rooms"

  """
  @spec description(String.t()) :: Macro.t()
  defmacro description(description) do
    quote do
      @channel_spec_description unquote(description)
    end
  end

  @doc """
  Defines an incoming channel event.

  ## Examples

      incoming "join"

      incoming "join" do
        descritpion "User joins room"
      end

  """
  @spec incoming(String.t()) :: Macro.t()
  defmacro incoming(name) do
    quote do
      @channel_spec_incoming {:incoming, unquote(name), nil}
    end
  end

  @spec incoming(String.t(), do: Macro.t()) :: Macro.t()
  defmacro incoming(name, do: block) do
    quote do
      @channel_spec_incoming {:incoming, unquote(name), unquote(Macro.escape(block))}
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
      |> Enum.map(&build_event/1)
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

  defp build_event({:incoming, name, nil}) do
    %Event{name: name}
  end

  defp build_event({:incoming, name, block}) do
    attrs = normalize_event_block(block)

    replies =
      for {:reply, status, opts} <- attrs do
        %Reply{
          status: status,
          payload: Keyword.get(opts, :payload),
          description: Keyword.get(opts, :description)
        }
      end

    attrs =
      attrs
      |> Enum.reject(fn
        {:reply, _, _} -> true
        _ -> false
      end)
      |> Map.new()

    %Event{
      name: name,
      description: attrs[:description],
      payload: attrs[:payload],
      replies: replies,
      tags: attrs[:tags] || []
    }
  end

  defp normalize_event_block(nil), do: []

  defp normalize_event_block({:__block__, _meta, exprs}) do
    Enum.flat_map(exprs, &normalize_event_block/1)
  end

  defp normalize_event_block(expr) when is_list(expr) do
    Enum.flat_map(expr, &normalize_event_block/1)
  end

  defp normalize_event_block(expr) do
    [normalize_event_expr(expr)]
  end

  defp normalize_event_expr({:description, _meta, [value]}) do
    {:description, value}
  end

  defp normalize_event_expr({:payload, _meta, [mod]}) do
    {:payload, resolve_alias(mod)}
  end

  defp normalize_event_expr({:tags, _meta, [tags]}) do
    {:tags, tags}
  end

  defp normalize_event_expr({:reply, _meta, [status]}) do
    {:reply, status, []}
  end

  defp normalize_event_expr({:reply, _meta, [status, opts]}) do
    opts = Keyword.update(opts, :payload, nil, &resolve_alias/1)
    {:reply, status, opts}
  end

  defp resolve_alias({:__aliases__, _, parts}), do: Module.concat(parts)
  defp resolve_alias(mod) when is_atom(mod), do: mod
end
