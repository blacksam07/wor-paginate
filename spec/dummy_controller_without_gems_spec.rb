require 'spec_helper'

describe DummyModelsWithoutGemsController, type: :controller do
  describe '#index' do
    let!(:model_count) { 28 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }
    let(:expected_list) { dummy_models.first(25).as_json(only: %i[id name something]) }

    before do
      [Wor::Paginate::Adapters::Kaminari, Wor::Paginate::Adapters::WillPaginate].each do |klass|
        allow_any_instance_of(klass).to receive(:adapt?).and_return(false)
      end
    end

    context 'with param page in -1' do
      it 'throws exception' do
        expect { get :index, params: { page: -1 } }
          .to raise_exception(Wor::Paginate::Exceptions::InvalidPageNumber)
      end
    end

    context 'with param page in 2' do
      before do
        expected_list
        get :index, params: { page: 2 }
      end

      let(:expected_list) do
        dummy_models.slice(25, 25).first(3).map do |dummy|
          { 'id' => dummy.id, 'name' => dummy.name, 'something' => dummy.something }
        end
      end

      include_context 'with param page in 2'

      include_examples 'proper pagination params'

      include_examples 'valid page'
    end

    context 'with param page in 1' do
      before { get :index, params: { page: 1 } }

      include_context 'with default pagination params'

      include_examples 'proper pagination params'

      include_examples 'valid page'
    end

    context 'without specific page' do
      before { get :index }

      include_context 'with default pagination params'

      include_examples 'proper pagination params'

      include_examples 'valid page'
    end
  end

  describe '#index_scoped' do
    let!(:model_count) { 28 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }
    let(:expected_list) do
      create_list(:dummy_model, 15, something: -3)
      DummyModel.some_scope.first(25).map do |dummy|
        { 'id' => dummy.id, 'name' => dummy.name, 'something' => dummy.something }
      end
    end

    before do
      [Wor::Paginate::Adapters::Kaminari, Wor::Paginate::Adapters::WillPaginate].each do |klass|
        allow_any_instance_of(klass).to receive(:adapt?).and_return(false)
      end
    end

    context 'with param page in -1' do
      it 'throws exception' do
        expect { get :index, params: { page: -1 } }
          .to raise_exception(Wor::Paginate::Exceptions::InvalidPageNumber)
      end
    end

    context 'with param page in 2' do
      before do
        expected_list
        get :index, params: { page: 2 }
      end

      let(:expected_list) do
        dummy_models.slice(25, 25).first(3).map do |dummy|
          { 'id' => dummy.id, 'name' => dummy.name, 'something' => dummy.something }
        end
      end

      include_context 'with param page in 2'

      include_examples 'proper pagination params'

      include_examples 'valid page'
    end

    context 'with param page in 1' do
      before { get :index, params: { page: 1 } }

      include_context 'with default pagination params'

      include_examples 'proper pagination params'

      include_examples 'valid page'
    end

    context 'without specific page' do
      before { get :index }

      include_context 'with default pagination params'

      include_examples 'proper pagination params'

      include_examples 'valid page'
    end
  end

  describe '#index_total_count' do
    subject(:make_request) { get :index_total_count, params: { per: 5 } }

    let!(:model_count) { 9 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }
    let(:expected_list) { dummy_models.first(5).as_json(only: %i[id name something]) }

    before do
      [Wor::Paginate::Adapters::Kaminari, Wor::Paginate::Adapters::WillPaginate].each do |klass|
        allow_any_instance_of(klass).to receive(:adapt?).and_return(false)
      end
    end

    context 'with total_count param' do
      before { make_request }

      include_examples 'total count pagination param'

      include_examples 'valid page'
    end
  end

  describe '#index_scoped_total_count' do
    subject(:make_request) { get :index_scoped_total_count, params: { per: 5 } }

    let(:expected_list) { dummy_models.first(5).as_json(only: %i[id name something]) }
    let!(:model_count) { 9 }
    let!(:dummy_models) { create_list(:dummy_model, model_count) }

    before do
      [Wor::Paginate::Adapters::Kaminari, Wor::Paginate::Adapters::WillPaginate].each do |klass|
        allow_any_instance_of(klass).to receive(:adapt?).and_return(false)
      end
    end

    context 'with total_count param' do
      before { make_request }

      include_examples 'total count pagination param'

      include_examples 'valid page'
    end
  end
end
