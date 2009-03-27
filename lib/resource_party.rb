require 'httparty'
require 'htmlentities'

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
      handle_errors(response)
      hash = Hash.from_xml(response.body).values.first
      hash.merge! params
      self.class.from_xml hash, self
    end

    def self.find(param, query = {})
      response = self.get("/#{self.route}/#{param}.xml", :query => query) 
      handle_not_found(response)
      handle_errors(response)
      handle_response(response)
    end
    
    def self.create(params = {}, query = {})
      response = self.post("/#{self.route}.xml", :body => body_for(params), :query => query) 
      handle_errors(response)
      handle_response(response)
    end
    
    def self.update(param, params = {}, query = {})
      response = self.put("/#{self.route}/#{param}.xml", :body => body_for(params), :query => query) 
      handle_not_found(response)
      handle_errors(response)
      handle_response(response)
    end
    
    def update(params = {}, query = {})
      self.class.update(self.id, params, query)
    end

    def self.destroy(id, query = {}) 
      response = self.delete("/#{self.route}/#{id}.xml", :query => query) 
      handle_not_found(response)
      handle_errors(response)
      handle_response(response)
    end
    
    def destroy(query = {})
      self.class.destroy(self.id, query)
    end

    def self.all(query = {})
      response = self.get("/#{self.route}.xml", :query => query) 
      handle_errors(response)
      items = response.values.first
      items.map{|hash| self.from_xml hash }        
    end

  private

    def self.handle_not_found(response)
      raise RecordNotFound.new(response.body) if response.code == "404"
    end    

    def self.handle_errors(response)
      raise ServerError.new(response.body) if response.code != "200"
    end
    
    def self.handle_response(response)
      # Rails will return ' ' when you render :nothing => true
      return nil if response.body.blank? || response.body == ' '
      hash = Hash.from_xml(response.body).values.first
      self.from_xml hash    
    end  

    def self.body_for(params)
      require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
      body = {}
      params.each{|n,v| body["#{self.resource}[#{n}]"] = v }
      body.map{|n,v| "#{CGI.escape(n.to_s)}=#{CGI.escape(v.to_s)}"} * "&"
    end
    
    def self.from_xml(params, obj = nil)
      obj ||= self.new({}, {}, true)
      decoded_params = params.dup
      params.each{|n,v| decoded_params[n] = HTMLEntities.new.decode(v) if v && v.is_a?(String) }
      obj.attributes = decoded_params
      mod = Module.new do
        obj.attributes.keys.each do |k|
          define_method(k) do
            return self.attributes[k]
          end
        
          define_method("#{k}=") do |val|
            self.attributes[k] = HTMLEntities.new.decode(val)
          end
        end
      end    
      obj.send(:extend, mod)
      obj
    end
  end
end