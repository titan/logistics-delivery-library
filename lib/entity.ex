defmodule Delivery.Entity do
  @derive [Poison.Encoder]
  @moduledoc """
  运单实体对象

  | name        | type      | meaning  |
  |-------------+-----------+----------|
  | did         | uuid      | 唯一标识 |
  | no          | string    | 运单编号 |
  | oid         | uuid      | 揽件人   |
  | eid         | uuid      | 企业编号 |
  | consigner   | person    | 发货人   |
  | consignee   | person    | 收货人   |
  | item        | string    | 物品名称 |
  | quantity    | integer   | 数量     |
  | description | string    | 物品描述 |
  | source      | string    | 发货地址 |
  | destination | string    | 收货地址 |
  | created_at  | timestamp | 创建时间 |
  | image       | image     | 照片信息 |

  """
  defstruct did: nil, no: nil, oid: nil, eid: nil, consigner: nil, consignee: nil, item: nil, quantity: 0, description: nil, source: nil, destination: nil, created_at: 0, image: nil
  @type t :: %Delivery.Entity{did: String.t, no: String.t, oid: String.t, eid: String.t, consigner: Delivery.Person.t, consignee: Delivery.Person.t, item: String.t, quantity: non_neg_integer, description: String.t, source: String.t, destination: String.t, created_at: non_neg_integer, image: Delivery.Image.t}
end
