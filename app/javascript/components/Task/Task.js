import PropTypes from 'prop-types';
import React from 'react';

import Card from '@material-ui/core/Card';
import CardContent from '@material-ui/core/CardContent';
import CardHeader from '@material-ui/core/CardHeader';
import Typography from '@material-ui/core/Typography';

import useStyles from './useStyles';

function Task({ task }) {
  const styles = useStyles();

  return (
    <Card className={styles.root}>
      <CardHeader title={task.name} />
      <CardContent>
        <Typography variant="body2" color="textSecondary" component="p">
          {task.description}
        </Typography>
      </CardContent>
    </Card>
  );
}

Task.propTypes = {
  task: PropTypes.shape({
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    description: PropTypes.string.isRequired,
    state: PropTypes.string.isRequired,
    author: PropTypes.shape().isRequired,
    assignee: PropTypes.shape(),
  }).isRequired,
};

export default Task;
