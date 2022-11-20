class API::V1::TasksController < API::V1::ApplicationController
  def index
    tasks = Task.all
      .includes([:author, :assignee])
      .ransack(ransack_params)
      .result
      .page(page)
      .per(per_page)

    respond_with(tasks, each_serializer: TaskSerializer,
                        root: 'items',
                        meta: build_meta(tasks))
  end

  def show
    task = Task.find(params[:id])

    respond_with(task, serializer: TaskSerializer)
  end

  def create
    task = current_user.my_tasks.new(task_params)

    if task.save
      SendTaskCreateNotificationJob.perform_async(task.id)
    end

    respond_with(task, serializer: TaskSerializer, location: nil)
  end

  def update
    task = Task.find(params[:id])

    if task.update(task_params)
      SendTaskUpdateNotificationJob.perform_async(task.id)
    end

    respond_with(task, serializer: TaskSerializer)
  end

  def destroy
    task = Task.find(params[:id])
    author = task.author

    if task.destroy
      SendTaskDestroyNotificationJob.perform_async(task.id, author.id)
    end

    respond_with(task)
  end

  def attach_image
    task = Task.find(params[:task_id])
    task_attach_image_form = TaskAttachImageForm.new(attachment_params)

    if task_attach_image_form.invalid?
      return respond_with(task_attach_image_form)
    end

    image = task_attach_image_form.processed_image
    task.image.attach(image)

    respond_with(task, serializer: TaskSerializer)
  end

  def remove_image
    task = Task.find(params[:task_id])
    task.image.purge

    respond_with(task, serializer: TaskSerializer)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :author_id,
                                 :assignee_id, :expired_at, :state_event)
  end

  def attachment_params
    params.require(:attachment).permit(:image, :crop_height, :crop_width, :crop_x, :crop_y)
  end
end
