import Board from '@asseinfo/react-kanban';
import React from 'react';

const data = {
  columns: [
    {
      id: 1,
      title: 'Backlog',
      cards: [
        {
          id: 1,
          title: 'Add Card',
          description: 'Add capability to add a card in a column',
        },
      ],
    },
    {
      id: 2,
      title: 'Doing',
      cards: [
        {
          id: 2,
          title: 'Drag-n-Drop Support',
          description: 'Move a card between the columns',
        },
      ],
    },
  ],
};

function TaskBoard() {
  return <Board initialBoard={data} disableColumnDrag />;
}

export default TaskBoard;
