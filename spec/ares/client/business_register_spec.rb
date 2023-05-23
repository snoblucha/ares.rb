require 'spec_helper'

describe Ares::Client::BusinessRegister do
  describe '.call' do
    it 'calls instance method' do
      client = double
      allow(Ares::Client::BusinessRegister).to receive(:new).and_return(client)
      expect(client).to receive(:call)
      described_class.call({})
    end
  end

  describe '#call', vcr: { record: :new_episodes } do
    it 'correctly calls API getting back XML response for correct ico' do
      result = described_class.call(ico: '27074358')

      expect(result).to be_a(Ares::Responses::BusinessRegister)
    end

    it 'correctly calls API getting back XML response for fake ico' do
      result = described_class.call(ico: '00000001')

      expect(result).to be_a(Ares::Responses::BusinessRegister)
    end

    it 'correctly calls API getting back XML response for invalid ico' do
      result = described_class.call(ico: '00000000')

      expect(result).to be_a(Ares::Responses::BusinessRegister)
    end
  end
end
