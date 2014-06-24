require_relative '../../spec_helper'
require_relative 'helper'

describe "donation search" do
  include SearchHelper
  set_context 'model'

  let(:admin_user) { Signup.make_unsaved(:admin) }

  context "searches" do

    let(:signup1) { Signup.make name: 'spongebob squarepants' }
    let(:signup2) { Signup.make name: 'squidward tortellini' }
    let!(:invoice1) { Invoice.make }
    let!(:invoice2) { Invoice.make }

    it "finds all invoices" do
      search = Search::All.new({ search_context: Search::Invoice::Context.new })
      search.page(admin_user).should =~ [invoice1.id, invoice2.id]
      search.count(admin_user).should == 2
    end
  end

end
