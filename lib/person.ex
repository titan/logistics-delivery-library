defmodule Delivery.Person do
  @derive [Poison.Encoder]
  @moduledoc """
  发件人和收件人

  | name          | type   | meaning  |
  |---------------+--------+----------|
  | name          | string | 姓名     |
  | phone         | string | 电话     |
  | license_type  | string | 证件类型 |
  | license_no    | string | 证件号   |

  """
  defstruct name: nil, phone: nil, license_type: nil, license_no: nil
  @type t :: %Delivery.Person{name: String.t, phone: String.t, license_type: String.t, license_no: String.t}
end
