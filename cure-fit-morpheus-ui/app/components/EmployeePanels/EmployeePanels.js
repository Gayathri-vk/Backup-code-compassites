import React, { Component } from 'react';
import './style.scss';
import EmployeePanelContent from '../EmployeePanelContent/EmployeePanelContent';
import { Accordion, AccordionItem } from 'react-light-accordion';
import 'react-light-accordion/demo/css/index.css';

class EmployeePanels extends Component{
    coldivide = () =>{
        return(
            <div className="columns title-block">
                <div className="column is-5 Title title-date"><span>Feburary 2018-August-2018</span></div>
                <div className="column is-2 is-flex progressTab"><progress class="progress is-success is-small is-marginless" value="35" max="70">35%</progress><span>35%</span></div>
                <div className="column is-offset-2 has-text-right collapseDropdown"><span className="downarrow "><button><i className="fas fa-angle-down"></i></button></span></div>                
            </div>
        )
    }
    render(){
        let coldivide = this.coldivide();
        return(           
            <div className="accordian_block">
                <Accordion atomic="true">
                    <AccordionItem title={ coldivide } >
                        <hr></hr>
                        <div className="columns lists" title="Title 1">             
                            <div className="column has-text-right collapseDropdown"><span className="downarrow ">Collapse All<button><i className="fas fa-angle-down"></i></button></span></div>
                        </div>
                        <EmployeePanelContent />                            
                    </AccordionItem>            
                </Accordion>     
                            
            </div>
        
        )
    }
}
export default EmployeePanels;
