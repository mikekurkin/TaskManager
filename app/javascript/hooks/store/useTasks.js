import { useSelector } from 'react-redux';

import { useTasksActions } from 'slices/TasksSlice';

const useTasks = () => {
  const board = useSelector((state) => state.TasksSlice.board);

  const tasksActions = useTasksActions();

  return {
    board,
    ...tasksActions,
  };
};

export default useTasks;
