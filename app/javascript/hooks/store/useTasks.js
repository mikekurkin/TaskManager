import { useDispatch, useSelector } from 'react-redux';

import TaskForm from 'forms/TaskForm';
import TaskPresenter, { STATES } from 'presenters/TaskPresenter';
import TasksRepository from 'repositories/TasksRepository';
import { tasksActions } from 'slices/TasksSlice';

const useTasks = () => {
  const dispatch = useDispatch();
  const board = useSelector((state) => state.TasksSlice.board);

  const { columnTasksReplace, columnTasksAppend, taskTransition } = tasksActions;

  const fetchColumn = (columnId, page = 1, perPage = 10) =>
    TasksRepository.index({
      q: { stateEq: columnId, s: 'updated_at+desc' },
      page,
      perPage,
    });

  const loadColumnInitial = (columnId, ...args) =>
    fetchColumn(columnId, ...args).then(({ data }) => {
      dispatch(columnTasksReplace({ ...data, columnId }));
    });

  const loadColumnMore = (columnId, ...args) =>
    fetchColumn(columnId, ...args).then(({ data }) => {
      dispatch(columnTasksAppend({ ...data, columnId }));
    });

  const loadBoard = () => Promise.all(STATES.map(({ key }) => loadColumnInitial(key)));

  const cardDragEnd = (task, source, destination) => {
    const transition = TaskPresenter.transitions(task).find(({ to }) => destination.toColumnId === to);
    console.log(transition);
    if (!transition) {
      return null;
    }

    // Update state right away so the cards don't jump back and forth
    dispatch(taskTransition({ task, from: source.fromColumnId, to: destination.toColumnId }));

    return TasksRepository.update(TaskPresenter.id(task), { task: { stateEvent: transition.event } })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(`Move failed! ${error.message}`);
      })
      .finally(() => {
        loadColumnInitial(source.fromColumnId);
        loadColumnInitial(destination.toColumnId);
      });
  };

  const taskCreate = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);
    return TasksRepository.create(attributes).then(({ data: { task } }) => {
      loadColumnInitial(TaskPresenter.state(task));
    });
  };

  const taskLoad = (id) => TasksRepository.show(id).then(({ data: { task } }) => task);

  const taskUpdate = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);

    return TasksRepository.update(TaskPresenter.id(task), attributes).then(() => {
      loadColumnInitial(TaskPresenter.state(task));
    });
  };

  const taskDestroy = (task) =>
    TasksRepository.destroy(TaskPresenter.id(task)).then(() => {
      loadColumnInitial(TaskPresenter.state(task));
    });

  return {
    board,
    loadBoard,
    loadColumnInitial,
    loadColumnMore,
    cardDragEnd,
    taskCreate,
    taskLoad,
    taskUpdate,
    taskDestroy,
  };
};

export default useTasks;
