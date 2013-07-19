class WorkloadCompetencesController < ApplicationController
  unloadable

#  before_filter :get_project, only: [:index, :create]

  def index
    @project = Project.find(params[:project_id])
  end

  def new
    @project = Project.find(params[:project_id])
    @ms_project = MSProject.new(params[:workload_competence][:xmlfile])
  end

end
