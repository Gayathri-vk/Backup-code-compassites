import React, { Component } from 'react';
import './style.scss';

class EmployeeSection extends Component{
    render(){
        return(
            <div className="block">
                <div className="box box-block">
                    <div className="columns">
                            <div className="column has-text-left is-size-6">Employee File</div>                      
                          
                    </div>
                    <hr></hr>
                    <div className="columns reviewBlock">
                      <div className="column is-5 has-text-left is-size-7 reviewCycle">Review Cycle</div>
                      <div className="column is-5 is-size-7 reviewComplete">Review Completion</div>
                    </div>                  

                </div>
            </div>
        )
    }
}
export default EmployeeSection;
