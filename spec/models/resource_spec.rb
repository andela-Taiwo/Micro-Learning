RSpec.describe Resource, type: :model do
  it "has valid Factory" do
    expect(FactoryBot.create(:resource)).to be_valid
  end

  describe "Validations" do
    context "should not have a invalid title" do
      it "is blank title", focus: true do
        resource = Resource.new(title: "", description: "test title",
                                url: "https://learninruby.com")
        expect(resource).not_to be_valid
      end
      it "title too short", focus: true do
        resource = Resource.new(title:       "tes",
                                description: "Element of testing short descr.",
                                url:         "https://learninruby.com")
        expect(resource).not_to be_valid
      end
    end

    context "should not have a invalid description" do
      it "is blank description", focus: true do
        resource = Resource.new(title: "test title", description: "",
                                url: "https://learninruby.com")
        expect(resource).not_to be_valid
      end
      it "description too short", focus: true do
        resource = Resource.new(title: "test title", description: "Element",
                                url: "https://learninruby.com")
        expect(resource).not_to be_valid
      end
    end

    context "should not have a invalid url" do
      it "is blank url", focus: true do
        resource = Resource.new(title:       "test title",
                                description: "The url is not valid for this resource",
                                url:         "")
        expect(resource).not_to be_valid
      end
      it "description too short", focus: true do
        resource = Resource.new(title: "test title", description: "Element",
                                url: "https://learninruby.com")
        expect(resource).not_to be_valid
      end
    end
  end
end
