defmodule Delivery.Api do
  alias Delivery.{Entity, Event}
  @moduledoc """

  # 运单模块客户端

  运单模块客户端集成了 resource_discovery 模块，可以被 elixir 程序直接调用。

  ## 设置

  在 mix.exs 文件中添加如下内容：
  ```elixir
  ...
  defp deps do
  [ {:deliverylib, git: "git@gitlab.ruicloud.cn:titan/logistics-delivery-library.git", tag: "0.0.1" } ]
  end
  ```

  ## 使用方法

  ### 启动代码
  在 Application 的 start 方法中，加入如下代码，确保帐号服务能被 resource_discovery 模块发现。
  ```elixir
  def start(_type, _args) do
  ...
  :resource_discovery.add_target_resource_type(:delivery_service)
  ...
  :resource_discovery.trade_resources()
  :timer.sleep(3000)
  ...
  end
  ```

  为了能让应用读取到正确的配置信息，在 config.exs 文件中添加如下内容：
  ```elixir
  config :resource_discovery, contact_nodes: [:contact1@contact1, :contact2@contact2]
  ```
  contact_nodes 可以根据具体情况进行调整。

  """
  @vsn "0.0.1"

  @typedoc """
  Integer 类型的错误状态编码
  """
  @type code :: integer

  @typedoc """
  错误发生的原因
  """
  @type reason :: String.t

  @typedoc """
  UUID 的 String 表达

  ## 例子
  ```elixir
  "60c0b63f-99f0-5fb1-9f34-46a86acd37fa"
  ```
  """
  @type uuid :: String.t

  @doc """
  创建运单

  ## 参数

  | arg                    | type      | meaning        |
  |------------------------+-----------+----------------|
  | no                     | string    | 运单编号       |
  | oid                    | uuid      | 揽件人编号     |
  | eid                    | uuid      | 企业编号       |
  | consigner_name         | string    | 发货人姓名     |
  | consigner_phone        | string    | 发货人手机     |
  | consigner_license_type | string    | 发货人证件类型 |
  | consigner_license_no   | string    | 发货人证件号码 |
  | consignee_name         | string    | 收货人姓名     |
  | consignee_phone        | string    | 收货人手机     |
  | item                   | string    | 物品名称       |
  | quantity               | integer   | 数量           |
  | description            | string    | 物品描述       |
  | source                 | string    | 发货地址       |
  | destination            | string    | 收货地址       |
  | created_at             | timestamp | 创建时间       |

  ## 结果

  ### 成功

  ```elixir
  {:ok, uuid}
  ```
  uuid 是运单的唯一标识

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec create(String.t, String.t, String.t, String.t, String.t, String.t, String.t, String.t, String.t, String.t, non_neg_integer, String.t, String.t, String.t, non_neg_integer) :: {:ok, uuid} | {:error, code, reason}
  def create(no, oid, eid, consigner_name, consigner_phone, consigner_license_type, consigner_license_no, consignee_name, consignee_phone, item, quantity, description, source, destination, created_at) do
    remote_call(:create, [no, oid, eid, consigner_name, consigner_phone, consigner_license_type, consigner_license_no, consignee_name, consignee_phone, item, quantity, description, source, destination, created_at])
  end

  @doc """
  获取运单详情。

  ## 参数

  | arg | type | meaning  |
  |-----+------+----------|
  | id  | uuid | 运单标识 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, Delivery.Entity.t}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现运单   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec delivery(String.t) :: {:ok, Entity.t} | {:error, code, reason}
  def delivery(id) do
    remote_call(:delivery, [id])
  end

  @doc """
  列出某个运单下的事件流

  ## 参数

  | arg | type | meaning |
  |-----+------+---------|
  | id  | uuid | 运单标识 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Event.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现运单   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec events(String.t) :: {:ok, [Event.t]} | {:error, code, reason}
  def events(id) do
    remote_call(:events, [id])
  end

  @doc """
  列出某个员工某年份的运单。

  ## 参数

  | arg    | type | meaning                                                                         |
  |--------+------+---------------------------------------------------------------------------------|
  | eid    | uuid | 员工编号                                                                        |
  | year   | int  | 年份                                                                            |
  | offset | int  | 列表开始索引                                                                    |
  | limit  | int  | 列表内容长度限制                                                                |
  | max    | uuid | 运单标识, 可选，返回不大于 max 代表条目的结果，若不填，则从系统最新条目开始返回 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec delivery_of_employee(String.t, non_neg_integer, non_neg_integer, non_neg_integer, String.t | nil) :: {:ok, [Entity.t]} | {:error, code, reason}
  def delivery_of_employee(eid, year, offset, limit, max \\ nil) do
    remote_call(:delivery_of_employee, [eid, year, offset, limit, max])
  end

  @doc """
  列出某个企业某年某月的所有运单。

  ## 参数

  | arg    | type | meaning                                                                         |
  |--------+------+---------------------------------------------------------------------------------|
  | eid    | uuid | 企业编号                                                                        |
  | year   | int  | 年份                                                                            |
  | month  | int  | 月份                                                                            |
  | offset | int  | 列表开始索引                                                                    |
  | limit  | int  | 列表内容长度限制                                                                |
  | max    | uuid | 运单标识, 可选，返回不大于 max 代表条目的结果，若不填，则从系统最新条目开始返回 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec delivery_of_enterprise(String.t, non_neg_integer, non_neg_integer, non_neg_integer, non_neg_integer, String.t | nil) :: {:ok, [Entity.t]} | {:error, code, reason}
  def delivery_of_enterprise(eid, year, month, offset, limit, max \\ nil) do
    remote_call(:delivery_of_enterprise, [eid, year, month, offset, limit, max])
  end

  @doc """
  列出所有企业某一天的所有运单。

  ## 参数

  | arg    | type | meaning                                                                         |
  |--------+------+---------------------------------------------------------------------------------|
  | year   | int  | 年份                                                                            |
  | month  | int  | 月份                                                                            |
  | day    | int  | 日期                                                                            |
  | offset | int  | 列表开始索引                                                                    |
  | limit  | int  | 列表内容长度限制                                                                |
  | max    | uuid | 运单标识, 可选，返回不大于 max 代表条目的结果，若不填，则从系统最新条目开始返回 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec delivery_of_all(non_neg_integer, non_neg_integer, non_neg_integer, non_neg_integer, non_neg_integer, String.t | nil) :: {:ok, [Entity.t]} | {:error, code, reason}
  def delivery_of_all(year, month, day, offset, limit, max \\ nil) do
    remote_call(:delivery_of_all, [year, month, day, offset, limit, max])
  end

  @doc """
  根据运单编号，搜索运单信息。

  ## 参数

  | arg | type   | meaning  |
  |-----+--------+----------|
  | no  | string | 运单编号 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec search_by_delivery_no(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_delivery_no(no) do
    remote_call(:search_by_delivery_no, [no])
  end

  @doc """
  根据企业名称，搜索运单信息。

  ## 参数

  | arg | type   | meaning  |
  |-----+--------+----------|
  | no  | string | 企业名称 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec search_by_enterprise(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_enterprise(name) do
    remote_call(:search_by_enterprise, [name])
  end

  @doc """
  根据发货人姓名，搜索运单信息。

  ## 参数

  | arg  | type   | meaning  |
  |------+--------+----------|
  | name | string | 发货人姓名 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec search_by_consigner(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_consigner(name) do
    remote_call(:search_by_consigner, [name])
  end

  @doc """
  根据发货人身份号码，搜索运单信息。

  ## 参数

  | arg | type   | meaning            |
  |-----+--------+--------------------|
  | id  | string | 发货人身份证件号码 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  """
  @spec search_by_consigner_license(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_consigner_license(id) do
    remote_call(:search_by_consigner_license, [id])
  end

  @doc """
  根据发货人手机，搜索运单信息。

  ## 参数

  | arg   | type   | meaning    |
  |-------+--------+------------|
  | phone | string | 发货人手机 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec search_by_consigner_phone(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_consigner_phone(phone) do
    remote_call(:search_by_consigner_phone, [phone])
  end

  @doc """
  根据收货人姓名，搜索运单信息。

  ## 参数

  | arg  | type   | meaning  |
  |------+--------+----------|
  | name | string | 收货人姓名 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec search_by_consignee(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_consignee(name) do
    remote_call(:search_by_consignee, [name])
  end

  @doc """
  根据收货人手机，搜索运单信息。

  ## 参数

  | arg   | type   | meaning    |
  |-------+--------+------------|
  | phone | string | 收货人手机 |

  ## 结果

  ### 成功

  ```elixir
  {:ok, [Delivery.Entity.t]}
  ```

  ### 失败

  ```elixir
  {:error, code, reason}
  ```

  | code | reason       |
  |------+--------------|
  |  404 | 未发现结果   |
  |  500 | 服务内部错误 |

  since: 0.0.1
  """
  @spec search_by_consignee_phone(String.t) :: {:ok, [Entity.t]} | {:error, code, reason}
  def search_by_consignee_phone(phone) do
    remote_call(:search_by_consignee_phone, [phone])
  end

  @spec remote_call(atom, [integer | String.t]) :: :ok | {:ok, Entity.t} | {:ok, [Entity.t]} | {:ok, [Event.t]} | {:error, code, reason}
  defp remote_call(cmd, args) when is_atom(cmd) and is_list(args) do
    :resource_discovery.rpc_call(:delivery_service, Delivery.Service, cmd, args)
  end

end
