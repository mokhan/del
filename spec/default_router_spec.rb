RSpec.describe Del::DefaultRouter do
  subject { described_class.new }

  describe "#route" do
    let(:recorder) { [] }
    before :each do
      subject.register(/^Hello World!$/) do |message|
        recorder.push(text: message.text)
      end

      subject.register(/^cowsay (.*)$/) do |message, match_data|
        recorder.push(text: message.text, match_data: match_data)
      end
    end

    it 'routes to the registered route' do
      subject.route(double(text: 'Hello World!'))
      expect(recorder).to match_array([text: 'Hello World!'])
    end

    it 'does not route a route that does not match' do
      subject.route(double(text: "What's good?"))
      expect(recorder).to be_empty
    end

    it 'passes captures to the block' do
      subject.route(double(text: "cowsay HELLO"))
      matches = /^cowsay (.*)$/.match("cowsay HELLO")
      expect(recorder).to match_array([text: 'cowsay HELLO', match_data: matches])
    end
  end
end
