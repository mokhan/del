require 'spec_helper'

RSpec.describe Del::User do
  describe '.map_from' do
    subject { described_class }
    let(:attributes) { { 'jid' => SecureRandom.uuid } }

    it 'returns a new user' do
      result = subject.map_from(attributes)
      expect(result).to be_instance_of(described_class)
      expect(result.jid).to eql(attributes['jid'])
      expect(result.attributes).to eql(attributes)
    end
  end
end
