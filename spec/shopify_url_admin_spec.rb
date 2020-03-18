require "spec_helper"

RSpec.describe ShopifyURL::Admin do
  def test_url(suffix)
    "https://foo.myshopify.com/admin/#{suffix}"
  end

  before do
    @admin = described_class.new("foo")
  end

  describe ".new" do
    it "requires a shop" do
      [nil, "", " "].each do |shop|
        expect { described_class.new(shop) }.to raise_error(ArgumentError, "shop required")
      end
    end

    it "accepts a fully qualified domain name" do
      admin = described_class.new("a.myshopify.com")
      expect(admin.to_s).to eq "https://a.myshopify.com/admin"
    end

    it "accepts a URL" do
      admin = described_class.new("http://a.myshopify.com")
      expect(admin.to_s).to eq "http://a.myshopify.com/admin"
    end

    it "accepts a shop name" do
      admin = described_class.new("foo")
      expect(admin.to_s).to eq "https://foo.myshopify.com/admin"
    end
  end

  describe "#customers" do
    it "builds a URL to a customer" do
      expect(@admin.customers).to eq test_url("customers")
      expect(@admin.customers(:foo => "a b", :bar => 99)).to eq test_url("customers?foo=a+b&bar=99")
    end

    context "given an id" do
      it "builds a URL to a customer" do
        expect(@admin.customer(1)).to eq test_url("customers/1")
        expect(@admin.customer(1, :foo => "a b", :bar => 99)).to eq test_url("customers/1?foo=a+b&bar=99")
      end
    end
  end

  describe "#orders" do
    it "builds a URL to all orders" do
      expect(@admin.orders).to eq test_url("orders")
      expect(@admin.orders(:foo => "a b", :bar => 99)).to eq test_url("orders?foo=a+b&bar=99")
    end

    context "given an id" do
      it "builds a URL to an order" do
        expect(@admin.order(1)).to eq test_url("orders/1")
        expect(@admin.order(1, :foo => "a b", :bar => 99)).to eq test_url("orders/1?foo=a+b&bar=99")
      end

      it "build a URL to a new shipping label" do
        expect(@admin.order(1).shipping_labels.new).to eq test_url("orders/1/shipping_labels/new")
        expect(@admin.order(1).shipping_labels.new(:foo => "a b", :bar => 99)).to eq test_url("orders/1/shipping_labels/new?foo=a+b&bar=99")
      end
    end
  end

  describe "#draft_orders" do
    it "builds a URL to all draft orders" do
      expect(@admin.draft_orders).to eq test_url("draft_orders")
      expect(@admin.draft_orders(:foo => "a b", :bar => 99)).to eq test_url("draft_orders?foo=a+b&bar=99")
    end

    it "builds a URL to a new draft order" do
      expect(@admin.draft_orders.new).to eq test_url("draft_orders/new")
      expect(@admin.draft_orders.new(:foo => "a b", :bar => 99)).to eq test_url("draft_orders/new?foo=a+b&bar=99")
    end

    context "given an id" do
      it "builds a URL to a draft order" do
        expect(@admin.draft_order(1)).to eq test_url("draft_orders/1")
        expect(@admin.draft_order(1, :foo => "a b", :bar => 99)).to eq test_url("draft_orders/1?foo=a+b&bar=99")
      end

      it "builds a URL to a duplicate the draft order" do
        expect(@admin.draft_order(1).duplicate).to eq test_url("draft_orders/1/duplicate")
        expect(@admin.draft_order(1).duplicate(:foo => "a b", :bar => 99)).to eq test_url("draft_orders/1/duplicate?foo=a+b&bar=99")
      end
    end
  end

  describe "#products" do
    it "builds a URL to all products" do
      expect(@admin.products).to eq test_url("products")
      expect(@admin.products(:foo => "a b", :bar => 99)).to eq test_url("products?foo=a+b&bar=99")
    end

    context "given an id" do
      it "builds a URL to a product" do
        expect(@admin.product(1)).to eq test_url("products/1")
        expect(@admin.product(1, :foo => "a b", :bar => 99)).to eq test_url("products/1?foo=a+b&bar=99")
      end

      it "builds a URL to a product variant" do
        expect(@admin.product(1).variants(2)).to eq test_url("products/1/variants/2")
        expect(@admin.product(1).variants(2, :foo => "a b", :bar => 99)).to eq test_url("products/1/variants/2?foo=a+b&bar=99")
      end
    end
  end
end
