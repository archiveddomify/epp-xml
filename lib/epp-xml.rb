require 'active_support'
require 'builder'
require 'epp-xml/session'
require 'epp-xml/domain'
require 'epp-xml/contact'
require 'epp-xml/keyrelay'

module EppXml
  attr_accessor :cl_trid_prefix, :cl_trid

  def initialize(args = {})
    self.cl_trid = args[:cl_trid]
    self.cl_trid_prefix = args[:cl_trid_prefix]
  end

  def clTRID
    return cl_trid if cl_trid
    return "#{cl_trid_prefix}-#{Time.now.to_i}" if cl_trid_prefix
    Time.now.to_i
  end

  class << self
    def generate_xml_from_hash(xml_params, xml, ns = '')
      xml_params.each do |k, v|
        # Value is a hash which has string type value
        if v.is_a?(Hash) && v[:value].is_a?(String)
          xml.tag!("#{ns}#{k}", v[:value], v[:attrs])
        # Value is a hash which is nested
        elsif v.is_a?(Hash)
          attrs = v.delete(:attrs)
          value = v.delete(:value) || v
          xml.tag!("#{ns}#{k}", attrs) do
            generate_xml_from_hash(value, xml, ns)
          end
        # Value is an array
        elsif v.is_a?(Array)
          if k.to_s.start_with?('_')
            v.each do |x|
              generate_xml_from_hash(x, xml, ns)
            end
          else
            xml.tag!("#{ns}#{k}") do
              v.each do |x|
                generate_xml_from_hash(x, xml, ns)
              end
            end
          end
        end
      end
    end
  end
end
