require 'spec_helper'

describe Phone do
  it "連絡先毎に重複した電話番号を許可しないこと" do
    contact = create(:contact)
    create(:home_phone,
      contact: contact,
      phone: '123-123-1234'
    )
    mobile_phone = build(:mobile_phone,
                         contact: contact,
                         phone: '123-123-1234'
    )
    expect(mobile_phone).to have(1).errors_on(:phone)
  end

  it "2件の連絡先で同じ電話番号を共有できること" do
    create(:home_phone)

    other_phone = build(:home_phone)
    expect(other_phone).to be_valid
  end
end