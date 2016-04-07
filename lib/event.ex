defmodule Delivery.Event do
  @derive [Poison.Encoder]
  @moduledoc """
  运单事件对象

  | name        | type      | meaning      |
  |-------------+-----------+--------------|
  | type        | int       | 事件类型     |
  | oid         | uuid      | 事件触发者   |
  | occurred_at | timestamp | 事件发生时间 |
  | did         | uuid      | 运单标识     |
  | no          | uuid      | 运单编号     |
  | eid         | uuid      | 企业编号     |
  | consigner   | person    | 发货人       |
  | consignee   | person    | 收货人       |
  | item        | string    | 物品名称     |
  | quantity    | integer   | 物品数量     |
  | description | string    | 物品描述     |
  | source      | string    | 发货地址     |
  | destination | string    | 收货地址     |
  | image       | image     | 照片信息     |
  | created_at  | timestamp | 运单创建时间 |

  """
  defstruct type: 0, oid: nil, occurred_at: 0, did: nil, no: nil, eid: nil, consigner: nil, consignee: nil, item: nil, quantity: 0, description: nil, source: nil, destination: nil, image: nil, created_at: 0
  @type t :: %Delivery.Event{type: non_neg_integer, oid: String.t, occurred_at: non_neg_integer, did: String.t, no: String.t, eid: String.t, consigner: Delivery.Person.t, consignee: Delivery.Person.t, item: String.t, quantity: non_neg_integer, description: String.t, source: String.t, destination: String.t, image: Delivery.Image.t, created_at: 0}
end
