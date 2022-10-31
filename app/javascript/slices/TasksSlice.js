import { changeColumn } from '@asseinfo/react-kanban';
import { createSlice } from '@reduxjs/toolkit';
import { concat, prepend, propEq, without } from 'ramda';
import { useDispatch } from 'react-redux';

import TaskForm from 'forms/TaskForm';
import TaskPresenter, { STATES } from 'presenters/TaskPresenter';
import TasksRepository from 'repositories/TasksRepository';

const initialState = {
  board: {
    columns: STATES.map((column) => ({
      id: column.key,
      title: column.value,
      cards: [],
      meta: {},
    })),
  },
};

const tasksSlice = createSlice({
  name: 'tasks',
  initialState,
  reducers: {
    columnTasksReplace(state, { payload }) {
      const { items, meta, columnId } = payload;
      const column = state.board.columns.find(propEq('id', columnId));

      state.board = changeColumn(state.board, column, {
        cards: items,
        meta,
      });

      return state;
    },
    columnTasksAppend(state, { payload }) {
      const { items, meta, columnId } = payload;
      const column = state.board.columns.find(propEq('id', columnId));

      state.board = changeColumn(state.board, column, {
        cards: concat(column.cards, items),
        meta,
      });

      return state;
    },
    taskTransition(state, { payload: { task, from, to } }) {
      const fromColumn = state.board.columns.find(propEq('id', from));
      const toColumn = state.board.columns.find(propEq('id', to));

      state.board = changeColumn(state.board, toColumn, {
        cards: prepend(task, toColumn.cards),
      });

      state.board = changeColumn(state.board, fromColumn, {
        cards: without([task], fromColumn.cards),
      });

      return state;
    },
  },
});

export default tasksSlice.reducer;

const { columnTasksReplace, columnTasksAppend, taskTransition } = tasksSlice.actions;

export const useTasksActions = () => {
  const dispatch = useDispatch();

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
