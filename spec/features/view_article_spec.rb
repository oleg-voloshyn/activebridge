require 'rails_helper'

feature 'View article', type: :feature do
  let(:member) { create(:member) }
  let!(:article) { create(:article, member: member) }

  before(:each) { change_host 'blog.lvh.me:3000' }

  after(:each) { change_host 'localhost:3000' }

  scenario do
    visit root_path
    click_link 'Random title', match: :first
    expect(page).to have_content('Alex')
    expect(page).to have_content('Random title')
    expect(page).to have_content(article.body)
    expect(current_path).to eq('/random-title')
  end
end
