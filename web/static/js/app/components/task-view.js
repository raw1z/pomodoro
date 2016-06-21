import React from 'react';

const TaskView = ({task}) => {
  return (
    <li className="task">
      {task.description}
    </li>
  );
};

export default TaskView;

