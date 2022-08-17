require "rails_helper"
require "rspec/json_expectations"

RSpec.shared_context "when plate not found" do
  context "when plate not found" do
    let(:plate) { "aaa-1234" }
    it { expect(response).to have_http_status(:not_found) }
    it { expect(response.body).to include_json(error: "plate not found") }
  end
end

RSpec.shared_context "when invalid plate" do
  context "when invalid plate" do
    ["#####", "1231234", "aaaaaaa", "aaa1234"].each do |invalid_plate| 
      let(:plate) { invalid_plate }
      it { expect(response).to have_http_status(:forbidden) }
      it { expect(response.body).to include_json(error: "invalid plate") }
    end
  end
end

RSpec.describe "ParkingsController", type: :request do
  let(:created_parking) { create(:parking) }
  let(:paid_parking) { create(:parking, :paid) }
  let(:left_parking) { create(:parking, :left) }
  let(:another_parking) { create(:parking, :left, plate: "abc-1234") }
  before(:each) { do_request }

  describe "GET /parking/:plate" do
    def do_request
      get "/parking/#{plate}"
    end

    include_context "when plate not found"
    include_context "when invalid plate"

    context "when plate is valid and found" do
      let(:plate) { left_parking.plate }

      it "should return http_status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "the response body should contain the parking history" do
        expect(response.body).to include_json([id: left_parking.id, plate: left_parking.plate, time: left_parking.time, paid: left_parking.paid?, left: left_parking.left?])
      end

      it "the response body should not include parking history from another plate" do
        expect(response.body).to_not include_json([id: another_parking.id, plate: another_parking.plate])
      end
    end
  end

  describe "POST /parking" do
    def do_request
      post "/parking", params: {plate: plate}
    end

    include_context "when invalid plate"

    context "when plate is valid" do
      context "but this plate has a parking pending" do
        let(:plate) { paid_parking.plate }

        it "should return http_status bad_request" do
          expect(response).to have_http_status(:bad_request)
        end
        
        it "the response body should contain a erro message" do
          expect(response.body).to include_json(error: "invalid transition, [\"Plate this plate has pendency\"]")
        end
      end

      context "and has not pendency" do
        let(:plate) { left_parking.plate }

        it "should return http_status accepted" do
          expect(response).to have_http_status(:created)
        end
        
        it "the response body should contain a success message" do
          expect(response.body).to include_json(message: "created")
        end
      end
    end
  end

  describe "PUT /parking/:plate/pay" do
    def do_request
      put "/parking/#{plate}/pay"
    end

    include_context "when plate not found"
    include_context "when invalid plate"

    context "when plate is valid and found" do
      context "but this plate has not a parking with created status" do
        let(:plate) { left_parking.plate }

        it "should return http_status bad_request" do
          expect(response).to have_http_status(:bad_request)
        end
        
        it "the response body should contain a erro message" do
          expect(response.body).to include_json(error: "invalid transition, Invalid transition")
        end
      end

      context "and has a parking to pay" do
        let(:plate) { created_parking.plate }

        it "should return accepted accepted" do
          expect(response).to have_http_status(:accepted)
        end
        
        it "the response body should contain a success message" do
          expect(response.body).to include_json(message: "paid")
        end
      end
    end
  end

  describe "PUT /parking/:plate/out" do
    def do_request
      put "/parking/#{plate}/out"
    end

    include_context "when plate not found"
    include_context "when invalid plate"

    context "when plate is valid and found" do
      context "but this plate has not a parking with paid status" do
        let(:plate) { left_parking.plate }

        it "should return http_status bad_request" do
          expect(response).to have_http_status(:bad_request)
        end
        
        it "the response body should contain a erro message" do
          expect(response.body).to include_json(error: "invalid transition, Invalid transition")
        end
      end

      context "and has a parking to get out" do
        let(:plate) { paid_parking.plate }

        it "should return http_status accepted" do
          expect(response).to have_http_status(:accepted)
        end
        
        it "the response body should contain a success message" do
          expect(response.body).to include_json(message: "out")
        end
      end
    end
  end
end