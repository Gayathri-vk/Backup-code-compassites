import React, { Component } from 'react';
import './style.scss';
import AccordianContent from '../AccordianContent/AccordianContent';
import { Accordion, AccordionItem } from 'react-light-accordion';
import 'react-light-accordion/demo/css/index.css';

class ProjectCards extends Component{
    render(){
        return(
            <div className="accordian_block">
            <Accordion atomic={true}>
             <AccordionItem>
                <div className="columns lists" title="Title 1">
                      <div className="column is-1 label_project">01</div>
                      <div className="column is-3 label_project">Libero Autern Omris Dolor</div>
                      <div className="column is-2 label_project">Cure Fit</div>
                      <div className="column is-2 label_project">Hitesh Gowda</div>
                      <div className="column is-3 label_project">Hitesh Gowda,Sjiv Chetan,Abhinav,Michel Smith,Meghan,Amit</div>
                      <div className="column is-1"><span className="downarrow"><i className="fas fa-angle-down"></i></span></div>
                  </div>
            <AccordianContent />
            </AccordionItem>
            <AccordionItem>
               <div className="columns lists" title="Title 2">
                     <div className="column is-1 label_project">01</div>
                     <div className="column is-3 label_project">Libero Autern Omris Dolor</div>
                     <div className="column is-2 label_project">Cure Fit</div>
                     <div className="column is-2 label_project">Hitesh Gowda</div>
                     <div className="column is-3 label_project">Hitesh Gowda,Sjiv Chetan,Abhinav,Michel Smith,Meghan,Amit</div>
                     <div className="column is-1"><span className="downarrow"><i className="fas fa-angle-down"></i></span></div>
                 </div>
           <AccordianContent />
           </AccordionItem>
           <AccordionItem>
              <div className="columns lists" title="Title 3">
                    <div className="column is-1 label_project">01</div>
                    <div className="column is-3 label_project">Libero Autern Omris Dolor</div>
                    <div className="column is-2 label_project">Cure Fit</div>
                    <div className="column is-2 label_project">Hitesh Gowda</div>
                    <div className="column is-3 label_project">Hitesh Gowda,Sjiv Chetan,Abhinav,Michel Smith,Meghan,Amit</div>
                    <div className="column is-1"><span className="downarrow"><i className="fas fa-angle-down"></i></span></div>
                </div>
          <AccordianContent />
          </AccordionItem>
          <AccordionItem>
             <div className="columns lists" title="Title 4">
                   <div className="column is-1 label_project">01</div>
                   <div className="column is-3 label_project">Libero Autern Omris Dolor</div>
                   <div className="column is-2 label_project">Cure Fit</div>
                   <div className="column is-2 label_project">Hitesh Gowda</div>
                   <div className="column is-3 label_project">Hitesh Gowda,Sjiv Chetan,Abhinav,Michel Smith,Meghan,Amit</div>
                   <div className="column is-1"><span className="downarrow"><i className="fas fa-angle-down"></i></span></div>
               </div>
         <AccordianContent />
         </AccordionItem>
         <AccordionItem>
            <div className="columns lists" title="Title 5">
                  <div className="column is-1 label_project">01</div>
                  <div className="column is-3 label_project">Libero Autern Omris Dolor</div>
                  <div className="column is-2 label_project">Cure Fit</div>
                  <div className="column is-2 label_project">Hitesh Gowda</div>
                  <div className="column is-3 label_project">Hitesh Gowda,Sjiv Chetan,Abhinav,Michel Smith,Meghan,Amit</div>
                  <div className="column is-1"><span className="downarrow"><i className="fas fa-angle-down"></i></span></div>
              </div>
        <AccordianContent />
        </AccordionItem>
         </Accordion>
            </div>
    )
}
}
export default ProjectCards;
