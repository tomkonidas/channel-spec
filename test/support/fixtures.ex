defmodule ChannelSpec.Fixtures do
  @moduledoc false

  alias ChannelSpec.Event
  alias ChannelSpec.Spec

  @spec event(map()) :: Event.t()
  def event(attrs \\ %{}) do
    struct!(
      Event,
      Map.merge(
        %{
          name: "new_msg",
          description: "A new message event"
        },
        attrs
      )
    )
  end

  @spec spec(map()) :: Spec.t()
  def spec(attrs \\ %{}) do
    struct!(
      Spec,
      Map.merge(
        %{
          topic: "room:*",
          description: "Realtime chat rooms",
          incoming: [],
          outgoing: []
        },
        attrs
      )
    )
  end
end
