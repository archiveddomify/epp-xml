require 'spec_helper'

describe EppXml do
  it 'sets correct clTRID' do
    ex = EppXml.new(cl_trid: 'asd')
    expect(ex.clTRID).to eq('asd')
    ex.cl_trid = nil
    expect(ex.clTRID).to be_within(2).of(Time.now.to_i)
    ex.cl_trid_prefix = 'bla'
    expect(ex.clTRID.split('-')[0]).to eq('bla')
    expect(ex.clTRID.split('-')[1].to_i).to be_within(2).of(Time.now.to_i)
  end
end
