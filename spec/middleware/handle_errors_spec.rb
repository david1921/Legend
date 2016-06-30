require 'spec_helper'

require 'epic/middleware/handle_errors'

describe Epic::Middleware::HandleErrors do
  let(:app) { double('app', call: nil) }

  subject(:middleware) { described_class.new(app) }

  describe '#on_complete' do
    let(:body) { double }

    let(:env) {
      {
        status: status,
        body: body,
      }
    }

    {
      200 => 'an OK',
      201 => 'a Created',
    }.each do |status, status_name|
      context "with #{status_name} status" do
        let(:status) { status }

        it 'does not raise an error' do
          expect { middleware.on_complete(env) }.to_not raise_error
        end
      end
    end

    {
      0 => ['an unknown', Epic::RequestError],
      400 => ['a Bad Request', Epic::BadRequest],
      401 => ['an Unauthorized', Epic::Unauthorized],
      403 => ['a Forbidden', Epic::Forbidden],
      404 => ['a Not Found', Epic::NotFound],
      405 => ['a Method Not Allowed', Epic::MethodNotAllowed],
      422 => ['an Unprocessable Entity', Epic::UnprocessableEntity],
      500 => ['an Internal Server Error', Epic::InternalServerError],
    }.each do |status, (status_name, error_class)|
      context "with #{status_name} status" do
        let(:status) { status }

        it 'raises an error' do
          expect { middleware.on_complete(env) }.to raise_error error_class
        end

        it 'sets the status on the error' do
          expect { middleware.on_complete(env) }
            .to raise_error { |error| expect(error.status).to eq status }
        end

        it 'sets the body on the error' do
          expect { middleware.on_complete(env) }
            .to raise_error { |error| expect(error.body).to eq body }
        end
      end
    end
  end
end
