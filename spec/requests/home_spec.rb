require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    context "when user is not authenticated" do
      it "renders landing page" do
        get root_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is authenticated" do
      it "redirects participant to their dashboard" do
        sign_in_as(create(:user, :participant))

        get root_path

        expect(response).to redirect_to(participant_my_courses_path)
      end

      it "redirects instructor to their dashboard" do
        sign_in_as(create(:user, :instructor))

        get root_path

        expect(response).to redirect_to(instructor_root_path)
      end

      it "redirects admin to their dashboard" do
        sign_in_as(create(:user, :admin))

        get root_path

        expect(response).to redirect_to(admin_root_path)
      end
    end
  end
end
