require 'spec_helper'

describe Contact do

  it "有効なファクトリを持つこと" do
    expect(build(:contact)).to be_valid
  end

  describe "文字で苗字をフィルタする" do
    before :each do
      @piyo1 = Contact.create(
          firstname: 'Hoge1',
          lastname: 'piyo1',
          email: 'tester1@example.com'
      )
      @piyo2 = Contact.create(
          firstname: 'Hoge2',
          lastname: 'piyo2',
          email: 'tester2@example.com'
      )
      @hoge = Contact.create(
          firstname: 'Hoge',
          lastname: 'Hoge',
          email: 'tester3@example.com'
      )
    end
    context "マッチする文字の場合" do
      it "ソートされた配列が返ってくること" do
        expect(Contact.by_letter('p')).to eq [@piyo1, @piyo2]
      end
    end

    context "マッチしない文字の場合" do
      it "ソートされた配列が返ってくること" do
        expect(Contact.by_letter('p')).to_not include @hoge
      end
    end
  end

  it "全てのデータが有効な状態であること" do
    contact = Contact.new(
        firstname: 'Hoge',
        lastname: 'piyo',
        email: 'tester@example.com'
    )
    expect(contact).to be_valid
  end
  it "名前がなければ無効な状態であること" do
    contact = build(:contact, firstname: nil)
    expect(contact).to have(1).errors_on(:firstname)
  end
  it "苗字がなければ無効な状態であること" do
    contact = build(:contact, lastname: nil)
    expect(contact).to have(1).errors_on(:lastname)
  end
  it "メールがなければ無効な状態であること" do
    contact = build(:contact, email: nil)
    expect(contact).to have(1).errors_on(:email)
  end
  it "重複したメールアドレスなら無効な状態であること" do
    create(:contact, email: 'tester@example.com')
    contact = build(:contact, email: 'tester@example.com')
    expect(contact).to have(1).errors_on(:email)
  end
  it "連絡先のフルネームを文字列として返すこと" do
    contact = build(:contact, firstname: 'Hoge', lastname: 'piyo')
    expect(contact.name).to eq 'Hoge piyo'
  end
  it "3つの電話番号を持つこと" do
    expect(create(:contact).phones.count).to eq 3
  end
end