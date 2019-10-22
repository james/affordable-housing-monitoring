require 'rails_helper'

RSpec.describe PageTitleHelper, type: :helper do
  describe 'page_title' do
    context 'when no page title is passed' do
      it 'renders the default page title' do
        expect(helper.page_title).to eq 'Southwark Affordable Homes Monitoring'
      end
    end

    context 'when a page title is passed' do
      it 'renders the page title followed by the default page title' do
        title = 'All developments'
        expect(helper.page_title(title)).to eq 'All developments - Southwark Affordable Homes Monitoring'
      end
    end
  end
end
