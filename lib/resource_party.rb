require 'httparty'

module ResourceParty
  class ServerError < RuntimeError; end
  class RecordNotFound < RuntimeError; end
  class Base
    include HTTParty

    attr_accessor :attributes
    
    def self.route_for(val)
      class_eval("def self.route; '#{val}'; end")
    end
    
    def self.resource_for(val)
      class_eval("def self.resource; '#{val}'; end")
    end
    
    def initialize(params = {}, query = {}, no_defaults = false) 
      return self if no_defaults
      response = self.class.get("/#{self.class.route}/new.xml")
      raise ServerError.new(response.body) if response.code != "200"
      hash = Hash.from_xml(response.body).values.first
      hash.merge! params
      self.class.from_xml hash, self
    end

    def self.find(id, query = {})
      response = self.get("/#{self.route}/#{id}.xml", :query => query) 
      raise RecordNotFound.new(response.body) if response.code == "404"
      raise ServerError.new(response.body) if response.code != "200"
      hash = Hash.from_xml(response.body).values.first
      self.from_xml hash
    end
    
    def self.create(params = {}, query = {})
      response = self.post("/#{self.route}.xml", :body => body_for(params), :query => query) 
      raise ServerError.new(response.body) if response.code != "200"
      hash = Hash.from_xml(response.body).values.first
      self.from_xml hash    
    end
    
    def self.update(id, params = {}, query = {})
      response = self.put("/#{self.route}/#{id}.xml", :body => body_for(params), :query => query) 
      raise RecordNotFound.new(response.body) if response.code == "404"
      raise ServerError.new(response.body) if response.code != "200"
      hash = Hash.from_xml(response.body).values.first
      self.from_xml hash    
    end
    
    def update(params = {}, query = {})
      self.class.update(self.id, params, query)
    end

    def self.destroy(id, query = {}) 
      response = self.delete("/#{self.route}/#{id}.xml", :query => query, :format => :text) 
      raise RecordNotFound.new(response.body) if response.code == "404"
      raise ServerError.new(response.body) if response.code != "200"
      true
    end
    
    def destroy(query = {})
      self.class.destroy(self.id, query)
    end

    def self.all(query = {})
      response = self.get("/#{self.route}.xml", :query => query) 
      raise ServerError.new(response.body) if response.code != "200"
      items = response.values.first
      items.map{|hash| self.from_xml hash }        
    end

  private

    def self.body_for(params)
      body = {}
      params.each{|n,v| body["#{self.resource}[#{n}]"] = v }
      body.to_query
    end
    
    def self.from_xml(params, obj = nil)
      obj ||= self.new({}, {}, true)
      obj.attributes = params
      mod = Module.new do
        obj.attributes.keys.each do |k|
          define_method(k) do
            return self.attributes[k]
          end
        
          define_method("#{k}=") do |val|
            self.attributes[k] = val
          end
        end
      end    
      obj.send(:extend, mod)
      obj
    end
  end
end