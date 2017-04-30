# frozen_string_literal: true

require 'rails_helper'

describe HomeController do
  describe 'GET #index' do
    it 'should return ok' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('ok')
    end

    describe 'rate limiting', type: :request do
      before(:all) do
        @redis = Redis.new
      end

      before(:each) do
        @redis.flushall
      end

      after(:each) do
        Timecop.return
      end

      context 'for a client that has not reached the rate limit' do
        let(:client) { '1.2.3.4' }

        it 'should allow 100 consecutive requests' do
          first_request_time = Time.local(2000, 1, 1, 1, 0, 0)
          subsequent_request_time = first_request_time + 30.minutes
          last_request_time = first_request_time + 1.hour

          Timecop.freeze(first_request_time)
          get '/', headers: { 'REMOTE_ADDR' => client }
          expect(response).to have_http_status(:ok)

          Timecop.freeze(subsequent_request_time)
          98.times do
            get '/', headers: { 'REMOTE_ADDR' => client }
            expect(response).to have_http_status(:ok)
          end

          Timecop.freeze(last_request_time)
          get '/', headers: { 'REMOTE_ADDR' => client }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'for a client that has reached the rate limit' do
        let(:limited_client)        { '1.2.3.4' }
        let(:valid_client)          { '2.3.4.5' }
        let(:first_request_time)    { Time.local(2000, 1, 1, 1, 0, 0) }
        let(:rejected_request_time) { first_request_time + 59.minutes + 30.seconds }
        let(:retry_time)            { 1.hour - (rejected_request_time - first_request_time) }

        before(:each) do
          Timecop.freeze(first_request_time)
          get '/', headers: { 'REMOTE_ADDR' => limited_client }
          Timecop.freeze(first_request_time + 30.minutes)
          99.times do
            get '/', headers: { 'REMOTE_ADDR' => limited_client }
          end
        end

        it 'should reject subsequent requests and return a retry time' do
          Timecop.freeze(rejected_request_time)
          get '/', headers: { 'REMOTE_ADDR' => limited_client }
          expect(response).to have_http_status(:too_many_requests)
          expect(response.body).to eq("Rate limit exceeded. Try again in #{retry_time.to_i} seconds.")
        end

        it 'should allow requests after the retry time has passed' do
          retry_request_time = rejected_request_time + retry_time
          Timecop.freeze(retry_request_time)
          get '/', headers: { 'REMOTE_ADDR' => limited_client }
          expect(response).to have_http_status(:ok)
        end

        it 'should not reject requests from other clients' do
          Timecop.freeze(rejected_request_time)
          get '/', headers: { 'REMOTE_ADDR' => valid_client }
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
