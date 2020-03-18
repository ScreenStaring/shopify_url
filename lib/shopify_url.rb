# frozen_string_literal: true
require "uri"

module ShopifyURL
  VERSION = "0.0.1"
  TOP_LEVEL_DOMAIN = ".myshopify.com"

  class Linker
    def initialize(shop)
      raise ArgumentError, "shop required" if empty?(shop)

      @host = shop.dup
      @host.prepend("https://") unless @host =~ %r{\Ahttps?://}i
    end

    def to_s
      @host.dup
    end

    alias to_str to_s
    alias inspect to_s

    protected

    attr_reader :host

    def id_required!(id)
      # Add caller to remove this frame from stack
      raise ArgumentError, "id required", caller if id.to_s.strip.empty?
    end

    def empty?(s)
      s.to_s.strip.empty?
    end

    def q(params)
      return unless params && params.respond_to?(:to_a)
      URI.encode_www_form(params.to_a)
    end
  end

  class Store < Linker
    class Collections < String
      def initialize(host, id = nil, qs = nil)
        super host + "/collections"
        self << "/" << id if id
        self << "?" << qs if qs
      end
    end

    class Products < String
      def initialize(host, qs = nil)
        super host + "/products"
        self << "?" << qs if qs
      end
    end

    class Product < String
      def initialize(host, id, qs = nil)
        super host + "/products/" << id.to_s
        self << "?" << qs if qs
      end
    end

    class Blogs < String
      def initialize(host, category, qs = nil)
        super host + "/blogs"
        self << "/" << category
        self << "?" << qs if qs
      end

      def entry(name, params = nil)
        self << "/" << name
        self << "?" << URI.encode_www_form(params.to_a) if params && params.any?
        self
      end
    end

    def initialize(shop)
      super

      host << TOP_LEVEL_DOMAIN unless @host =~ %r{\.[-0-9a-z]+\z} # non-ASCII domains!
      host.freeze
    end

    def collection(id, query = nil)
      id_required!(id)
      Collections.new(host, id, q(query))
    end

    def collections(query = nil)
      Collections.new(host, nil, q(query))
    end

    def product(id, query = nil)
      id_required!(id)
      Product.new(host, id, q(query))
    end

    def products(query = nil)
       Products.new(host, q(query))
    end

    def page(id, query = nil)
      url = host + "/pages/" << id.to_s
      url << "?" << q(query) if query
      url
    end

    def blogs(category, query = nil)
      raise "category required" if empty?(category)
      Blogs.new(host, category, q(query))
    end
  end

  class Admin < Linker
    class Customers < String
      def initialize(host, id = nil, qs = nil)
        super host + "/customers"
        self << "/" << id.to_s if id
        self << "?" << qs if qs
      end
    end

    class Products < Store::Products
      def inventory
        self + "/inventory"
      end
    end

    class Product < Store::Product
      def variants(id, params = nil)
        url = self + "/variants/" << id.to_s
        url << "?" << URI.encode_www_form(params.to_a) if params && params.any?
        url
      end
    end

    class Order < String
      def initialize(host, id, qs = nil)
        super host + "/orders/" << id.to_s
        self << "?" << qs if qs
      end

      def shipping_labels
        ShippingLabel.new(self + "/shipping_labels")
      end
    end

    class Orders < String
      def initialize(host, qs = nil)
        super host + "/orders"
        self << "?" << qs if qs
      end
    end

    class ShippingLabel < String
      def new(params = nil)
        url = self + "/new"
        url << "?" << URI.encode_www_form(params.to_a) if params && params.any?
        url
      end
    end

    class DraftOrder < String
      def initialize(base, id, qs = nil)
        super base + "/draft_orders/" << id.to_s
        self << "?" << qs if qs
      end

      def duplicate(params = nil)
        url = self + "/duplicate"
        url << "?" << URI.encode_www_form(params.to_a) if params && params.any?
        url
      end
    end

    class DraftOrders < String
      def initialize(base, qs = nil)
        super base + "/draft_orders"
        self << "?" << qs if qs
      end

      def new(params = nil)
        url = self + "/new"
        url << "?" << URI.encode_www_form(params.to_a) if params && params.any?
        url
      end
    end

    def initialize(shop)
      super
      host << TOP_LEVEL_DOMAIN unless host.end_with?(TOP_LEVEL_DOMAIN)
      host << "/admin"
      host.freeze
    end

    def customer(id, query = nil)
      id_required!(id)
      Customers.new(host, id, q(query))
    end

    def customers(query = nil)
      Customers.new(host, nil, q(query))
    end

    def draft_orders(query = nil)
      DraftOrders.new(host, q(query))
    end

    def draft_order(id, query = nil)
      id_required!(id)
      DraftOrder.new(host, id, q(query))
    end

    def order(id, query = nil)
      id_required!(id)
      Order.new(host, id, q(query))
    end

    def orders(query = nil)
      Orders.new(host, q(query))
    end

    def product(id, query = nil)
      id_required!(id)
      Product.new(host, id, q(query))
    end

    def products(query = nil)
      Products.new(host, q(query))
    end
  end
end
