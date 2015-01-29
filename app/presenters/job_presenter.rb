class JobPresenter
  def initialize(job, view_context)
    @job = job
    @view_context = view_context
  end

  delegate :status, to: :@job

  def title
    @job.key
  end

  def steps(&block)
    @job.steps.map do |step|
      @view_context.capture(step.name, step.status, &block)
    end.join("\n").html_safe
  end
end
