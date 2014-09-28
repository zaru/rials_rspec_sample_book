require 'spec_helper'

describe ContactsController do

  describe 'GET #index' do
    context 'params[:letter]がある場合' do
      it "指定された文字で始まる連絡先を配列にまとめること" do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index, letter: 'S'
        expect(assigns(:contacts)).to match_array([smith])
      end
      it ":indexテンプレートを表示すること" do
        get :index, letter: 'S'
        expect(response).to render_template :index
      end
    end
    context "params[:letter]がない場合" do
      it "すべての連絡先を配列にまとめること" do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index
        expect(assigns(:contacts)).to match_array([smith, jones])
      end
      it ":indexテンプレートを表示すること" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    it "@contactに要求された連絡先を割り当てること" do
      contact = create(:contact)
      get :show, id: contact
      expect(assigns(:contact)).to eq contact
    end
    it ":showテンプレートを表示すること" do
      contact = create(:contact)
      get :show, id: contact
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it "@contactに新しい連絡先を割り当てること" do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end
    it ":newテンプレートを表示すること" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "@contactに要求された連絡先を割り当てること" do
      contact = create(:contact)
      get :edit, id: contact
      expect(assigns(:contact)).to eq contact
    end

    it ":editテンプレートを表示すること" do
      contact = create(:contact)
      get :edit, id: contact
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do

    before :each do
      @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
      ]
    end

    context "有効な属性の場合" do
      it "データベースに新しい連絡先を保存すること" do
        expect{
          post :create, contact: attributes_for(:contact,
                                                phones_attributes: @phones
          )
        }.to change(Contact, :count).by(1)
      end
      it "contacts#showにリダイレクトすること" do
        post :create, contact: attributes_for(:contact,
                                              phones_attributes: @phones
        )
        expect(response).to redirect_to contact_path(assigns[:contact])
      end
    end
    context "無効な属性の場合" do
      it "データベースに新しい連絡先を保存しないこと" do
        expect{
          post :create, contact: attributes_for(:invalid_contact)
        }.to_not change(Contact, :count)
      end
      it ":newテンプレートを再表示すること" do
        post :create, contact: attributes_for(:invalid_contact)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    before :each do
      @contact = create(:contact, firstname: 'Hoge', lastname: 'piyo')
    end

    context "有効な属性の場合" do
      it "要求された@contactを取得すること" do
        patch :update, id: @contact, contact: attributes_for(:contact)
        expect(assigns(:contact)).to eq(@contact)
      end
      it "@contactの属性を変更すること" do
        patch :update, id: @contact,
              contact: attributes_for(:contact, firstname: 'Puka', lastname: 'piko')
        @contact.reload
        expect(@contact.firstname).to eq('Puka')
        expect(@contact.lastname).to eq('piko')
      end
      it "更新した連絡先のページヘリダイレクトすること" do
        patch :update, id: @contact, contact: attributes_for(:contact)
        expect(response).to redirect_to @contact
      end
    end
    context "無効な属性の場合" do
      it "連絡先を更新しないこと" do
        patch :update, id: @contact,
              contact: attributes_for(:contact, firstname: 'Puka', lastname: nil)
        @contact.reload
        expect(@contact.firstname).to_not eq('Puka')
        expect(@contact.lastname).to eq('piyo')
      end
      it ":editテンプレートを再表示すること" do
        patch :update, id: @contact,
              contact: attributes_for(:invalid_contact)
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do

    before :each do
      @contact = create(:contact)
    end

    it "データベースから連絡先を削除すること" do
      expect{
        delete :destroy, id: @contact
      }.to change(Contact, :count).by(-1)
    end
    it "contacts#indexにリダイレクトすること" do
      delete :destroy, id: @contact
      expect(response).to redirect_to contacts_url
    end
  end

  describe "PATCH hide_contact" do

    before :each do
      @contact = create(:contact)
    end

    it "連絡先をhidden状態にすること" do
      patch :hide_contact, id: @contact
      expect(@contact.reload.hidden?).to be_true
    end

    it "contacts#indexにリダイレクトすること" do
      patch :hide_contact, id: @contact
      expect(response).to redirect_to contacts_url
    end
  end
end