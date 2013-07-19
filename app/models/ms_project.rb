class MSProject
  NOT_USER_ASSIGNED = -65535

  attr_accessor :tasks, :resources, :resource_by_competence

  def initialize(xmlfile)
    @doc = REXML::Document.new(xmlfile.read)
    @resources = get_resources
    @resource_by_competence = get_resource_by_competence
    @tasks = get_tasks
  end

  def create_workload_competences(project_id)
    @tasks.each do |task|
      WorkloadCompetence.transaction do
        WorkloadCompetence.create(
          project_id: project_id,
          competence_id: task.competence,
          subject: "#{task.outlinenumber} #{task.title}",
          start_date: task.start,
          due_date: task.finish
        )
      end
    end
  end

  private

  def get_resources
    resources = {}

    @doc.each_element( 'Project/Resources/Resource' ) do | as |
      resource_uid = as.get_elements('UID').first.text.to_i
      resource_name_element = as.get_elements('Name').first

      if(resource_uid.zero? || resource_name_element.blank?)
        next
      else
        resources[resource_uid] = resource_name_element.text
      end
    end
    resources
  end

  def get_resource_by_competence
    resource_by_competence = {}

    @resources.each do |uid, name|
      competence = Competence.where("name LIKE :name", name: "%#{name}%").first
      if competence.blank?
        next
      else
        resource_by_competence[uid] = competence.id
      end
    end
    resource_by_competence
  end

  def get_tasks
    tasks = []

    @doc.each_element( 'Project/Tasks/Task' ) do |task|
      struct = OpenStruct.new
      struct.outlinenumber = task.get_elements('OutlineNumber')[0].text.strip if task.get_elements('OutlineNumber')[0]
      struct.tid = task.get_elements('ID')[0].text.to_i if task.get_elements('ID')[0]
      struct.uid = task.get_elements('UID')[0].text.to_i if task.get_elements('UID')[0]
      struct.title = task.get_elements('Name')[0].text.strip if task.get_elements('Name')[0]
      struct.start = task.get_elements('Start')[0].text.split("T")[0] if task.get_elements('Start')[0]
      struct.finish = task.get_elements('Finish')[0].text.split("T")[0] if task.get_elements('Finish')[0]

      if outlinenumber = struct.outlinenumber
        if index = outlinenumber.rindex('.')
          struct.outnum = outlinenumber[0...index]
        end
      end

      tasks.push(struct)
    end

    set_assignment_to_task tasks.group_by(&:uid)

    tasks.compact.uniq.sort_by(&:tid)
  end

  def set_assignment_to_task(uid_tasks)
    @doc.each_element('Project/Assignments/Assignment') do |as|
      task_uid = as.get_elements( 'TaskUID' ).first.text.to_i
      resource_id = as.get_elements('ResourceUID').first.text.to_i
      task = task_uid.nonzero? ? uid_tasks[task_uid].first : nil

      if (task && resource_id != NOT_USER_ASSIGNED)
        task.competence = @resource_by_competence[resource_id]
      else
        next
      end
    end
  end
end
