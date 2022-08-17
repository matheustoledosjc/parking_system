require 'rails_helper'

RSpec.describe 'ParkingsController', type: :request do
  let(:parking) { create(:parking, :left)}

  it "GET /parking/:plate" do  
    headers = { "ACCEPT" => "application/json" }
    get "/parking/#{parking.plate}", headers: headers

    # expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(:ok)
    expect(response.body).to be_nil
  end
end