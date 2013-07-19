class WorkloadCompetence < ActiveRecord::Base
  unloadable

  belongs_to :competence
  belongs_to :project

  validates_presence_of :project_id, :competence_id, :subject, :start_date, :due_date
  validates_uniqueness_of :subject, scope: [:competence_id, :project_id]

  def self.load(xmlfile)
    doc = REXML::Document.new( xmlfile.read )
    resource_by_competence = self.get_bind_resource_competences(doc)
  end

  def self.resources(doc)
    resources = {}

    doc.each_element( 'Project/Resources/Resource' ) do | as |
      resource_uid = as.get_elements('UID').first.text.to_i
      resource_name_element = as.get_elements('Name').first

      if(resource_uid.zero? || resource_name_element)
        next
      else
        resources[resource_uid] = resource_name_element.text
      end
    end
    resources
  end

  def self.resource_by_competence(doc)
    resources = self.get_resources(doc)
    resource_by_competence = {}

    resources.each do |uid, name|
      competence = Competence.where("name LIKE :name", name: "%#{name}%").first
      if competence.blank?
        next
      else
        resource_by_competence[uid] = competence.id
      end
    end
    resource_by_competence
  end
end
