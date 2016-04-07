defmodule Delivery.Image do
  @derive [Poison.Encoder]
  @moduledoc """
  照片信息

  | name         | type   | meaning        |
  |--------------|--------|----------------|
  | frontal_view | string | 证件正面照   |
  | rear_view    | string | 证件背面照   |
  """
  defstruct frontal_view: nil, rear_view: nil
  @type t :: %Delivery.Image{frontal_view: String.t, rear_view: String.t}

end
