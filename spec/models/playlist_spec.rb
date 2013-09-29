require 'spec_helper'

describe Playlist do

  before { @playlist = Playlist.new(name: "Example Playlist") }

  subject { @playlist }

  it { should respond_to(:name) }
  it { should be_valid }

  describe "when name is not present" do
    before { @playlist.name = " " }
    it { should_not be_valid }
  end
end
