import React from 'react';
import tasks from '../ducks/tasks';
import TasksView from './tasks-view';

export default ({tasks}) => {
  return <TaskView tasks={tasks}/>;
};
