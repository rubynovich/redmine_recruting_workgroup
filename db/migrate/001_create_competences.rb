class CreateCompetences < ActiveRecord::Migration
  def change
    create_table :competences do |t|
      t.string :name
      t.integer :team_id
      t.integer :team_leader_id
    end
  end
end
