require 'spec_helper'

RSpec.describe Del::Repository do
  subject { described_class.new(storage: storage, mapper: mapper) }
  let(:storage) { Hash.new }
  let(:mapper) { double(:mapper, map_from: nil) }

  describe "#[]" do
    let(:id) { SecureRandom.uuid }
    let(:attributes) { { id: id, name: 'Teren Delvon Jones' } }
    let(:user) { instance_double(Del::User) }

    before do
      subject.upsert(id, attributes)
      allow(mapper).to receive(:map_from).with(attributes).and_return(user)
    end

    specify { expect(subject[id]).to eql(user) }
    specify { expect(subject.find(id)).to eql(user) }
  end
end
