module ClientTransactionId
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
end
