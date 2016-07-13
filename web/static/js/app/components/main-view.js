import React from 'react';
import { connect } from 'react-redux';
import TasksView from './tasks-view';
import { newTask } from '../ducks/tasks';

const MainView = ({
  tasks,
  onAddBtnClicked
}) => {
  return (
    <div className="main-view">
      <div className="pane pane-left">
        <div className="toolbar">
          <a className="btn-add" onClick={onAddBtnClicked}>Add</a>
        </div>
        <TasksView tasks={tasks}/>
      </div>

      <div className="pane pane-right">
      </div>
    </div>
  );
};

const mapStateToProps = (state) => {
  return {
    tasks: state.tasks
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    onAddBtnClicked: () => dispatch(newTask({
      description: 'a task'
    }))
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(MainView);

