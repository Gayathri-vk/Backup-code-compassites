import React, { Component } from 'react';
import './style.scss';

class ProjectBlock extends Component{
    render(){
        return(
            <div className="block ">
                <div className="box box-block">
                <div className="columns project_col">
                        <div className="column is-10 has-text-left">Projects</div>
                        <div className="column is-2">
                            <button className="button addprojectbtn"><i className="fas fa-plus"></i>Add a new Project</button>
                        </div>
                    </div>
                    <div className="columns">
                      <div className="column is-1 label_project">Sl.No.</div>
                      <div className="column is-3 label_project">Title<i className="fas fa-caret-down"></i></div>
                      <div className="column is-2 label_project">Super Project<i className="fas fa-caret-down"></i></div>
                      <div className="column is-2 label_project">Owner<i className="fas fa-caret-down"></i></div>
                      <div className="column is-3 label_project">Participant<i className="fas fa-caret-down"></i></div>
                      <div className="column is-1"></div>
                    </div>
                </div>
            </div>
        )
    }
}
export default ProjectBlock;
