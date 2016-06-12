require 'rails_helper'

RSpec.feature "User can create a wallet from the dasbhoard" do
  scenario "a registered user with no wallet can submit a private key", js: true do
    VCR.use_cassette("wallet/dasbhoard_import", record: :new_episodes) do
      user = create(:user)
      login_as user, scope: :user

      visit '/dashboard'

      expect(user.primary_wallet).to eq(nil)

      within(".primary-wallet") do
        expect(page).to have_content "Create a Wallet in order to get started!"
      end

      within(".page-header") do
        click_button "Create New Wallet"
        fill_in "private_key", with: ENV["PRIVATE_KEY"]
        click_button "Import Private Key"
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path

      wallet = Wallet.find_by(user_id: user.id)

      expect(wallet.user_id).to eq user.id
    end
  end

  scenario "a registered user with no wallet can generate a new wallet", js: true do
    VCR.use_cassette("wallet/dasbhoard_create", record: :new_episodes) do
      user = create(:user)
      login_as user, scope: :user

      visit '/dashboard'

      expect(user.primary_wallet).to eq(nil)

      within(".primary-wallet") do
        expect(page).to have_content "Create a Wallet in order to get started!"
      end

      within(".page-header") do
        click_button "Create New Wallet"

        wait_for_ajax

        click_button "Generate a New Wallet"
      end

      expect(current_path).to eq dashboard_path

      sleep(2)

      wallet = Wallet.find_by(user_id: user.id)

      expect(wallet.user_id).to eq user.id
    end
  end
end
