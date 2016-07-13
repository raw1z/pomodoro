import React from 'react';

const TaskView = ({task}) => {
  return (
    <li className="task">
      <div className="done">
        <input type="checkbox" />
      </div>
      <div className="description">
        {task.description}
      </div>
      <div className="actions">
        <a>start</a>
        <a>edit</a>
        <a>delete</a>
      </div>
    </li>
  );
};

export default TaskView;

