require 'spec_helper'

RSpec.describe Del::Message do
  subject { described_class.new(text, robot: robot, source: source) }
  let(:robot) { instance_double(Del::Robot) }
  let(:source) { instance_double(Del::Source) }
  let(:text) { SecureRandom.hex(16) }

  describe "#reply" do
    before { allow(source).to receive(:reply) }

    it 'delegates to the source to reply' do
      subject.reply('hello')
      expect(source).to have_received(:reply).with(robot, 'hello')
    end
  end

  describe "#execute_shell" do
    before { allow(source).to receive(:reply) }

    it 'executes the command' do
      result = subject.execute_shell(['ls', '-al'])
      expect(result).to be_truthy
    end

    it 'returns false when the shell command fails' do
      expect(subject.execute_shell(['exit', '1'])).to be_falsey
    end

    it 'replies with the stdout content' do
      subject.execute_shell(['echo', 'hello'])
      expect(source).to have_received(:reply).with(robot, "/code hello\n")
    end

    it 'yields each line to stdout' do
      @called = false
      subject.execute_shell(['echo', 'hello']) do |line|
        @called = true
        expect(line).to eql("hello\n")
      end
      expect(@called).to be(true)
    end

    it 'replies with the stderr content' do
      subject.execute_shell(['>&2', 'echo', 'hello'])
      expect(source).to have_received(:reply).with(robot, "/code hello\n")
    end

    it 'yields each line to stderr' do
      @called = false
      subject.execute_shell(['>&2', 'echo', 'hello']) do |line|
        @called = true
        expect(line).to eql("hello\n")
      end
      expect(@called).to be(true)
    end
  end

  describe "#to_s" do
    specify { expect(subject.to_s).to include(source.to_s) }
    specify { expect(subject.to_s).to include(text) }
  end
end
