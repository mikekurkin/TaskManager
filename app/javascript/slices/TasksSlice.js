import { changeColumn } from '@asseinfo/react-kanban';
import { createSlice } from '@reduxjs/toolkit';
import { concat, prepend, propEq, without } from 'ramda';

import { STATES } from 'presenters/TaskPresenter';

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

export const tasksActions = tasksSlice.actions;
