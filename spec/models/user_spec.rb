RSpec.describe User, type: :model do
  it "has valid Factory" do
    expect(FactoryBot.create(:user)).to be_valid
  end

  describe "Validations" do
    context "should not have a invalid email address" do
      it "is blank email", focus: true do
        user = User.new(email: "", password: "testpass", username: "test123")
        expect(user).not_to be_valid
      end
    end

    context "should not have a invalid username" do
      it "is blank username", focus: true do
        user = User.new(email: "e@example.com", password: "testpass",
                        username: "", password_confirmation: "testpass")
        expect(user).not_to be_valid
      end
      it "username too short", focus: true do
        user = User.new(email: "e@example.com", password: "testpass",
                        username: "pi", password_confirmation: "testpass")
        expect(user).not_to be_valid
      end
    end

    context "should have valid password and confirmation password" do
      it "is invalid when password does not match", focus: true do
        user = User.new(email: "e.example.com", password: "testpass",
                        username: "a", password_confirmation: "testpass23")
        expect(user).not_to be_valid
      end
      it "length of password is less than 6", focus: true do
        user = User.new(email: "e.example.com", password: "test",
                        username: "henry", password_confirmation: "test")
        expect(user).not_to be_valid
      end
    end

    context "valid user" do
      it "when valid data is supplied", focus: true do
        user = User.new(email: "e.example.com", password: "testpass",
                        username: "testadm", password_confirmation: "testpass")
        expect(user).to be_valid
      end
    end
  end
end
