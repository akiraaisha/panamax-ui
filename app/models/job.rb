class Job < BaseResource
  has_one :override, class_name: 'JobOverride'
  has_many :steps

  schema do
    integer :template_id
  end

  def with_step_status!
    steps.each do |step|
      step.status = step.get_status(completed_steps)
    end
    self
  end

  def self.new_from_template(template)
    self.new(
      override: { environment: template.environment },
      template_id: template.id
    )
  end

  def self.nested_create(attrs)
    instance = self.new(template_id: attrs[:template_id])
    instance.write_attributes(attrs)
    instance.save
  end

  def override_attributes=(attrs)
    override = JobOverride.new
    override.write_attributes(attrs)
    self.override = override
  end

  def total_steps
    steps.length
  end
end
