# Delivery

**运单模块API**

## Installation

  1. Add deliverylib to your list of dependencies in `mix.exs`:

        def deps do
          [{:deliverylib, git: "git@gitlab.ruicloud.cn:titan/logistics-delivery-library.git", tag: "0.0.2" }]
        end

  2. Ensure deliverylib is started before your application:

        def application do
          [applications: [:deliverylib]]
        end
