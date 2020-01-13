import React, { Component } from 'react';
import './style.scss';
import ViewOkr from '../../containers/Project/ViewOkr';
// import ProjectBlock  from '../ProjectBlock/ProjectBlock';
// import ProjectAccordian from '../ProjectAccordian/ProjectAccordian';
import EmployeeSection from '../EmployeeSection/EmployeeSection';
import EmployeePanels from '../EmployeePanels/EmployeePanels';
class Tabs extends Component{
    render(){
        return(

            <div className="column is-10 tabscol">
                <div className="tabs tabs_blk">
                  <ul className="tabslist">
                    <li><a className="datepickr"><i className="far fa-calendar"></i>2018<i className="fas fa-angle-down"></i></a></li>
                    <li><a>JFM</a></li>
                    <li className="is-active"><a>AMJ</a></li>
                    <li><a>JAS</a></li>
                    <li><a>OND</a></li>
                  </ul>
                </div>
                <div className="container_block">
                    {/* <ViewOkr /> */}
                    {/* <ProjectBlock /> */}
                    
                    {/* <ProjectAccordian /> */}
                    <EmployeeSection />
                    <EmployeePanels />
                    <EmployeePanels />
                    <EmployeePanels />
                </div>

            </div>
        )
    }
}
export default Tabs;
