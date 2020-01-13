import React, { Component } from 'react';
import './style.scss';
import AccordianContent from '../AccordianContent/AccordianContent';
import ProjectCards from '../ProjectCards/ProjectCards';

class ProjectAccordian extends Component{
    render(){
        return(
            <div className="block whole_acc_block">
                <ProjectCards />
            </div>
        )
    }
}
export default ProjectAccordian;
