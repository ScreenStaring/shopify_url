require "spec_helper"

RSpec.describe ShopifyURL::Store do
  def test_url(suffix)
    "https://foo.myshopify.com/#{suffix}"
  end

  before do
    @store = described_class.new("foo")
  end

  describe ".new" do
    it "requires a shop" do
      [nil, "", " "].each do |shop|
        expect { described_class.new(shop) }.to raise_error(ArgumentError, "shop required")
      end
    end

    it "accepts a fully qualified domain name" do
      store = described_class.new("example.com")
      expect(store.to_s).to eq "https://example.com"
    end

    it "accepts a URL" do
      store = described_class.new("http://example.com")
      expect(store.to_s).to eq "http://example.com"
    end

    it "accepts a shop name" do
      store = described_class.new("foo")
      expect(store.to_s).to eq "https://foo.myshopify.com"
    end
  end

  describe "#products" do
    it "builds a URL to all products" do
      expect(@store.products).to eq test_url("products")
      expect(@store.products(:foo => "a b", :bar => 99)).to eq test_url("products?foo=a+b&bar=99")
    end

    context "given an id" do
      it "builds a URL to a product" do
        expect(@store.product("foo-bar")).to eq test_url("products/foo-bar")
        expect(@store.product("foo-bar", :foo => "a b", :bar => 99)).to eq test_url("products/foo-bar?foo=a+b&bar=99")
      end
    end
  end

  describe "#collections" do
    it "builds a URL to the collections page" do
      expect(@store.collections).to eq test_url("collections")
      expect(@store.collections(:foo => "a b", :bar => 99)).to eq test_url("collections?foo=a+b&bar=99")
    end

    context "given an id" do
      it "builds a URL to a collection" do
        expect(@store.collection("foo-bar")).to eq test_url("collections/foo-bar")
        expect(@store.collection("foo-bar", :foo => "a b", :bar => 99)).to eq test_url("collections/foo-bar?foo=a+b&bar=99")
      end
    end
  end

  describe "#blogs" do
    it "builds a URL to the given blog category" do
      expect(@store.blogs("category")).to eq test_url("blogs/category")
      expect(@store.blogs("category", :foo => "a b", :bar => 99)).to eq test_url("blogs/category?foo=a+b&bar=99")
    end

    it "builds a URL to the given blog entry in the given category" do
      expect(@store.blogs("category").entry("entry")).to eq test_url("blogs/category/entry")
      expect(@store.blogs("category").entry("entry", :foo => "a b", :bar => 99)).to eq test_url("blogs/category/entry?foo=a+b&bar=99")
    end
  end

  describe "#page" do
    it "builds a URL to the given page" do
      expect(@store.page("foo")).to eq test_url("pages/foo")
      expect(@store.page("foo", :foo => "a b", :bar => 99)).to eq test_url("pages/foo?foo=a+b&bar=99")
    end
  end
end
