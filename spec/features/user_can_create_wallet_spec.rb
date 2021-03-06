require 'rails_helper'

RSpec.feature "User can create a wallet" do
  scenario "a registered user with no wallet is offered to create a wallet", js: true do
    VCR.use_cassette("wallet/new", record: :new_episodes) do
      user = create(:user)
      login_as user, scope: :user

      visit '/wallets/new'

      expect(user.primary_wallet).to eq(nil)

      within(".new-wallet-message") do
        expect(page).to have_content "You Need a Wallet"
        find("#generateWallet").trigger("click")
      end

      wait_for_ajax

      expect(current_path).to eq dashboard_path
      expect(Wallet.find_by(user_id: user.id).user_id).to eq user.id
    end
  end
end
