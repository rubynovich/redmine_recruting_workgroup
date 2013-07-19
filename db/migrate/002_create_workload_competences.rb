class CreateWorkloadCompetences < ActiveRecord::Migration
  def change
    create_table :workload_competences do |t|
      t.references :project
      t.references :competence
      t.string :subject
      t.date :start_date
      t.date :due_date
    end
    add_index :workload_competences, :project_id
    add_index :workload_competences, :competence_id
  end
end
