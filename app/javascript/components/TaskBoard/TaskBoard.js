import KanbanBoard from '@asseinfo/react-kanban';
import { concat, propOr } from 'ramda';
import React, { useEffect, useState } from 'react';

import AddPopup from 'components/AddPopup';
import ColumnHeader from 'components/ColumnHeader';
import EditPopup from 'components/EditPopup';
import Task from 'components/Task';
import TaskForm from 'forms/TaskForm';
import TaskPresenter from 'presenters/TaskPresenter';
import TasksRepository from 'repositories/TasksRepository';

import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';

import useStyles from './useStyles';

const STATES = [
  { key: 'new_task', value: 'New' },
  { key: 'in_development', value: 'In Dev' },
  { key: 'in_qa', value: 'In QA' },
  { key: 'in_code_review', value: 'In CR' },
  { key: 'ready_for_release', value: 'Ready for Release' },
  { key: 'released', value: 'Released' },
  { key: 'archived', value: 'Archived' },
];

const MODES = {
  ADD: 'add',
  NONE: 'none',
  EDIT: 'edit',
};

const initialBoard = {
  columns: STATES.map((column) => ({
    id: column.key,
    title: column.value,
    cards: [],
    meta: {},
  })),
};

function TaskBoard() {
  const styles = useStyles();

  const [board, setBoard] = useState(initialBoard);
  const [boardCards, setBoardCards] = useState([]);
  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);

  const loadColumn = (state, page, perPage) =>
    TasksRepository.index({
      q: { stateEq: state, s: 'updated_at+desc' },
      page,
      perPage,
    });

  const loadColumnInitial = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => ({
        ...prevState,
        [state]: { cards: data.items, meta: data.meta },
      }));
    });
  };

  const generateBoard = () => {
    const brd = {
      columns: STATES.map(({ key, value }) => ({
        id: key,
        title: value,
        cards: propOr([], 'cards', boardCards[key]),
        meta: propOr({}, 'meta', boardCards[key]),
      })),
    };

    setBoard(brd);
  };

  const loadBoard = () => {
    STATES.map(({ key }) => loadColumnInitial(key));
  };

  useEffect(() => loadBoard(), []);
  useEffect(() => generateBoard(), [boardCards]);

  const loadColumnMore = (state, page = 1, perPage = 10) => {
    loadColumn(state, page, perPage).then(({ data }) => {
      setBoardCards((prevState) => ({
        ...prevState,
        [state]: { cards: concat(prevState[state].cards, data.items), meta: data.meta },
      }));
    });
  };

  const handleCardDragEnd = (task, source, destination) => {
    const transition = TaskPresenter.transitions(task).transitions.find(({ to }) => destination.toColumnId === to);
    if (!transition) {
      return null;
    }

    return TasksRepository.update(TaskPresenter.id(task), { task: { stateEvent: transition.event } })
      .then(() => {
        loadColumnInitial(destination.toColumnId);
        loadColumnInitial(source.fromColumnId);
      })
      .catch((error) => {
        // eslint-disable-next-line no-alert
        alert(`Move failed! ${error.message}`);
      });
  };

  const handleOpenAddPopup = () => {
    setMode(MODES.ADD);
  };

  const handleClose = () => {
    setMode(MODES.NONE);
    setOpenedTaskId(null);
  };

  const handleTaskCreate = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);
    return TasksRepository.create(attributes).then(({ data: { task } }) => {
      loadColumnInitial(TaskPresenter.state(task));
      handleClose();
    });
  };

  const loadTask = (id) => TasksRepository.show(id).then(({ data: { task } }) => task);

  const handleTaskUpdate = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);

    return TasksRepository.update(TaskPresenter.id(task), attributes).then(() => {
      loadColumnInitial(TaskPresenter.state(task));
      handleClose();
    });
  };

  const handleTaskDestroy = (task) =>
    TasksRepository.destroy(TaskPresenter.id(task)).then(() => {
      loadColumnInitial(TaskPresenter.state(task));
      handleClose();
    });

  const handleOpenEditPopup = (task) => {
    setOpenedTaskId(TaskPresenter.id(task));
    setMode(MODES.EDIT);
  };

  return (
    <div>
      <KanbanBoard
        renderCard={(card) => <Task onClick={handleOpenEditPopup} task={card} />}
        renderColumnHeader={(column) => <ColumnHeader column={column} onLoadMore={loadColumnMore} />}
        disableColumnDrag
        onCardDragEnd={handleCardDragEnd}
      >
        {board}
      </KanbanBoard>
      <Fab className={styles.addButton} color="primary" aria-label="add" onClick={handleOpenAddPopup}>
        <AddIcon />
      </Fab>
      {mode === MODES.ADD && <AddPopup onCreateCard={handleTaskCreate} onClose={handleClose} />}
      {mode === MODES.EDIT && (
        <EditPopup
          onLoadCard={loadTask}
          onCardDestroy={handleTaskDestroy}
          onCardUpdate={handleTaskUpdate}
          onClose={handleClose}
          cardId={openedTaskId}
        />
      )}
    </div>
  );
}

export default TaskBoard;
