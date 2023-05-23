require 'spec_helper'

describe Ares::Responses::BusinessRegister do
  describe 'parsed result', vcr: { record: :new_episodes } do
    it 'for correct ico' do
      result = Ares::Client::BusinessRegister.call(ico: '27074358')

      expect(result).to be_a(Ares::Responses::BusinessRegister)
      expect(result.record).to be_a(Ares::Responses::BusinessRegister::Record)
    end
  end

  describe '#record', vcr: { record: :new_episodes } do
    it 'for correct ico' do
      result = Ares::Client::BusinessRegister.call(ico: '27074358').record

      expect(result).to be_a(Ares::Responses::BusinessRegister::Record)
      expect(result.introduction).to be_a(Ares::Responses::BusinessRegister::Introduction)
      expect(result.registration).to be_a(Ares::Responses::BusinessRegister::Registration)
      expect(result.registration.court).to be_a(String)
      expect(result.registration.court).to eq 'Městský soud v Praze'
      expect(result.registration.number).to be_a(String)
      expect(result.registration.number).to eq 'B 8525'
      expect(result.texts).to be_a(Array)
    end
  end
end
