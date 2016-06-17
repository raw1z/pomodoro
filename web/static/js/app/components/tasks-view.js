import React from 'react';
import { createTask } from '../ducks/tasks';
import TaskView from './task-view';

const TasksView = ({tasks}) => {
  return (
    <div class="tasks">
      {
        tasks.map((task) => {
          return <TaskView task={task} />
        })
      }
    </div>
  );
};

export default TasksView;
