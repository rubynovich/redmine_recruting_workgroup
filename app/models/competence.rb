class Competence < ActiveRecord::Base
  unloadable

  belongs_to :team, class_name: "Principal"
  belongs_to :team_leader, class_name: "User"

  validates_presence_of :name, :team_id, :team_leader_id
  validates_uniqueness_of :name
end
