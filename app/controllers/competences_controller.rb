class CompetencesController < ApplicationController
  unloadable
  layout 'admin'

  before_filter :require_admin
  before_filter :new_object, only: [:index, :new, :create]
  before_filter :find_object, only: [:edit, :update, :destroy]
  before_filter :get_collection, only: [:index]

  def create
    if @object.save
      flash[:notice] = l(:notice_successful_create)
      get_collection
    else
      render action: 'new'
    end
  end

  def update
    if @object.update_attributes(params[object_name])
      flash[:notice] = l(:notice_successful_update)
      get_collection
    else
      render action: 'edit'
    end
  end

  def destroy
    @object.destroy
    get_collection
  end

  private
    def new_object
      @object = object_class.new(params[object_name])
    end

    def find_object
      @object = object_class.find(params[:id])
    end

    def get_collection
      scope = object_class.order(:name)
      @count = scope.count
      @pages, @collection = paginate scope, per_page: per_page_option
    end

    def object_class
      Competence
    end

    def object_name
      :competence
    end
end
