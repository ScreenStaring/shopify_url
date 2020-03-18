# Shopify URL

[![Build Status](https://travis-ci.org/ScreenStaring/shopify_url.svg?branch=master)](https://travis-ci.org/ScreenStaring/shopify_url)

Build URLs to Shopify web pages.

## Usage

### Admin URLs

```rb
require "shopify_url"

url = ShopifyURL::Admin.new("shopname")

# https://shopname.myshopify.com/admin"
url.to_s

# https://shopname.myshopify.com/admin/orders
url.orders

# https://shopname.myshopify.com/admin/orders/6303508996
url.order(6303508996)

# https://shopname.myshopify.com/admin/products
url.products

# https://shopname.myshopify.com/admin/products/345323423
url.product(345323423)

# https://shopname.myshopify.com/admin/products/345323423/variants/2421342331
url.product(345323423).variant(2421342331)
```

See the RDocs for a complete list of methods.

### Store URLs
```rb
require "shopify_url"

url = ShopifyURL::Store.new("shopname")  # you can also use your top-level domain

# https://shopname.myshopify.com/collections
url.collections

# https://shopname.myshopify.com/collections/amaaaaazing-thangz
url.collection("amaaaaazing-thangz")
```

See the RDocs for a complete list of methods.

### Query String Parameters

All Shopify URL generation methods accept a `Hash` of query string parameters:

```rb
url = ShopifyURL::Store.new("shopname")  # you can also use your top-level domain

# https://shopname.myshopify.com/products/some-handle?tracking=data
url.products("some-handle", :tracking => "data")
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

Made by [ScreenStaring](http://screenstaring.com)
