RSpec.describe Del::DefaultRouter do
  subject { described_class.new(Logger.new(STDOUT)) }

  describe "#route" do
    let(:recorder) { [] }
    before :each do
      subject.register(/^Hello World!$/) do |message|
        recorder.push(message.text)
      end
    end

    it 'routes to the registered route' do
      subject.route(double(text: 'Hello World!'))
      expect(recorder).to include('Hello World!')
    end

    it 'does not route a route that does not match' do
      subject.route(double(text: "What's good?"))
      expect(recorder).to be_empty
    end
  end
end
