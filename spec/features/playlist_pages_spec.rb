require 'spec_helper'

describe "Playlist pages" do

  subject { page }

  describe "home page" do
    before { visit root_path }

    it { should have_title('Wemote') }

    describe "create playlist" do

      let(:submit) { "Create playlist" }

      describe "with invalid information" do
        it "should not create a playlist" do
          expect { click_button submit }.not_to change(Playlist, :count)
        end
      end

      describe "with valid information" do
        before do
          fill_in "Playlist Name", with: "Example Playlist"
        end

        it "should create a playlist" do
          expect { click_button submit }.to change(Playlist, :count).by(1)
        end

        describe "after saving the playlist" do
          before { click_button submit }
          let(:playlist) { Playlist.find_by(name: 'Example Playlist') }

          it { should have_title(playlist.name) }
        end
      end
    end
  end

  describe "searching to add to a playlist" do
    let(:playlist) { FactoryGirl.create(:playlist) }
    before { visit search_playlist_path(playlist) }

    describe "should show search button" do
      it { should have_content('Find a song') }
    end

    describe "searching for a song" do

      let(:submit) { "Search" }

      describe "with invalid information" do
        describe "should not do perform a search" do
          before { click_button submit }

          it { should_not have_content('Search results')}
        end
      end

      describe "with valid information" do
        before do
          fill_in "search", with: "Example Query"
          click_button submit
        end

        it { should have_content('Search results') }
      end
    end
  end
end
