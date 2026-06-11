defmodule ChannelSpec.EventTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Event

  test "enforces name" do
    assert_raise ArgumentError, fn ->
      struct!(Event, %{})
    end
  end

  test "defaults optional fields" do
    event = %Event{name: "new_msg"}

    assert event.description == nil
    assert event.payload == nil
    assert event.reply == nil
    assert event.deprecated == false
    assert event.examples == []
    assert event.tags == []
    assert event.metadata == %{}
  end
end
