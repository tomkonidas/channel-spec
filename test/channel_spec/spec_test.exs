defmodule ChannelSpec.SpecTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Spec

  test "defaults incoming events to empty lists" do
    spec = %Spec{}
    assert spec.incoming == []
  end

  test "defaults outgoing events to empty lists" do
    spec = %Spec{}
    assert spec.outgoing == []
  end
end
