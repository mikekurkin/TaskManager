import KanbanBoard from '@asseinfo/react-kanban';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import React, { useEffect, useState } from 'react';

import AddPopup from 'components/AddPopup';
import ColumnHeader from 'components/ColumnHeader';
import EditPopup from 'components/EditPopup';
import Task from 'components/Task';

import useTasks from 'hooks/store/useTasks';

import useStyles from './useStyles';

const MODES = {
  ADD: 'add',
  NONE: 'none',
  EDIT: 'edit',
};

function TaskBoard() {
  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);
  const styles = useStyles();

  const { board, loadBoard, loadColumnMore, cardDragEnd, taskCreate, taskLoad, taskUpdate, taskDestroy } = useTasks();

  useEffect(() => {
    loadBoard();
  }, []);

  const handleAddPopupOpen = () => {
    setMode(MODES.ADD);
  };

  const handleEditPopupOpen = (task) => {
    setOpenedTaskId(task.id);
    setMode(MODES.EDIT);
  };

  const handlePopupClose = () => {
    setMode(MODES.NONE);
    setOpenedTaskId(null);
  };

  const handleTaskCreate = (...attr) => taskCreate(...attr).then(handlePopupClose);

  const handleTaskUpdate = (...attr) => taskUpdate(...attr).then(handlePopupClose);

  const handleTaskDestroy = (...attr) => taskDestroy(...attr).then(handlePopupClose);

  return (
    <div>
      <KanbanBoard
        renderCard={(task) => <Task onClick={handleEditPopupOpen} task={task} />}
        renderColumnHeader={(column) => <ColumnHeader stickyHeader column={column} onLoadMore={loadColumnMore} />}
        disableColumnDrag
        onCardDragEnd={cardDragEnd}
      >
        {board}
      </KanbanBoard>
      <Fab className={styles.addButton} color="primary" aria-label="add" onClick={handleAddPopupOpen}>
        <AddIcon />
      </Fab>
      {mode === MODES.ADD && <AddPopup onCreateCard={handleTaskCreate} onClose={handlePopupClose} />}
      {mode === MODES.EDIT && (
        <EditPopup
          onLoadCard={taskLoad}
          onCardDestroy={handleTaskDestroy}
          onCardUpdate={handleTaskUpdate}
          onClose={handlePopupClose}
          cardId={openedTaskId}
        />
      )}
    </div>
  );
}

export default TaskBoard;
