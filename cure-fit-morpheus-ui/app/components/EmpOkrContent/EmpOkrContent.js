import React ,{Component} from 'react';
import { Form, Text } from 'informed';
import './style.scss';
class EmpOkrContent extends Component{   
    constructor(props) {
        super(props);
        
        this.state = {
          shown: true,
         
        };
      }
      toggle() {
		this.setState({
			shown: !this.state.shown
		});
	}
    render(){
        var shown = {
			display: this.state.shown ? "block" : "none"
		};
		var hidden = {
			display: this.state.shown ? "none" : "block"
		}
        return(  
            <div>
                <div className="okr-block" style={hidden}>
                    <label><a href='#' className="has-text-black is-size-7">Libero Autem Omnis Dolar</a></label>
                    <button className="button is-small is-light is-rounded has-text-grey-light">Mind.Fit</button>                
                    <Form id="intro-form" className="form-textarea">
                        <div className="columns field text-heading-label">
                            <div className="column is-6  key-result">
                                <label htmlFor="keyResult" className="has-text-grey-light">Key Result</label>                                                                     
                            </div>
                            <div className="column is-6  self-assesment"> 
                                <label htmlFor="selfAssesment" className=" has-text-grey-light">Self Assesment</label>                                                                       
                            </div>               
                        </div>
                        <div className="columns field  text-area-field">
                            <div className="column is-6 control key-result">                     
                                <Text field="keyResult" id="keyResult" className="textarea text-design" value="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."/>    
                                <div className="custom-button">
                                <button className=" button is-success is-small"></button>
                                <button className=" button is-warning is-small"></button>
                                <button className=" button is-small"></button>
                                </div>                                                        
                            </div>
                            <div className="column is-6  self-assesment">                           
                                <Text field="selfAssesment" id="selfAssesment" className="textarea text-design" value="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."/>
                                <div className="custom-button">
                                <button className=" button is-success is-small"></button>
                                <button className=" button is-warning is-small"></button>
                                <button className=" button is-small"></button>
                                </div>
                            </div>         
                        </div>
                        <div className="columns field  text-area-field">
                            <div className="column is-6 control key-result">                     
                                <Text field="keyResult-additional" id="keyResult-additional" className="textarea text-design" value="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."/> 
                                <div className="custom-button">
                                <button className=" button is-success is-small"></button>
                                <button className=" button is-warning is-small"></button>
                                <button className=" button is-small"></button>
                                </div>                                                           
                            </div>
                            <div className="column is-6  self-assesment">                           
                                <Text field="selfAssesment-additional" id="selfAssesment-additional" className="textarea text-design" value="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." />
                                <div className="custom-button">
                                <button className=" button is-success is-small"></button>
                                <button className=" button is-warning is-small"></button>
                                <button className=" button is-small"></button>
                                </div>
                            </div>         
                        </div>
                    </Form>   
                    <button onClick={this.toggle.bind(this)}>
                        <span class="icon edit-icon" >
                            <i class="fa fa-pen"></i><span className="edit-label">Edit</span>
                        </span>
                    </button>             
                </div> 
                <div className="okr-block" style={shown}>
                    <label><a href='#' className="has-text-black">Libero Autem Omnis Dolar</a></label>
                    <button className="button is-small is-light is-rounded has-text-grey-light">Mind.Fit</button>                
                    <Form id="intro-form" className="form-textarea">
                        <div className="columns field text-heading-label">
                            <div className="column is-6  key-result">
                                <label htmlFor="keyResult" className="has-text-grey-light">Key Result</label>                                                                     
                            </div>
                            <div className="column is-6  self-assesment self-label"> 
                                <label htmlFor="selfAssesment" className=" has-text-grey-light">Self Assesment</label>                                                                       
                            </div>               
                        </div>
                        <div className="columns field  text-area-field is-paddingless">
                            <span className="icon star-icon"><i className="fa fa-star"></i>  </span>
                            <div className="column is-6 control key-result">                                           
                                <p className="pad-align">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p>     
                                                                                    
                            </div>
                            <div className="column is-6  self-assesment">                           
                                <p className="pad-align">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p>  
                            </div>         
                        </div>
                        <div className="columns field  text-area-field is-paddingless">
                            <span className="icon-hide"><i className="fa fa-star"></i>  </span>
                            <div className="column is-6 control key-result">                     
                                <p className="pad-align">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p>                                                            
                            </div>
                            <div className="column is-6  self-assesment">                           
                                <p className="pad-align">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. </p>  
                            </div>         
                        </div>
                    </Form>                  
                    <button className="button-icon" onClick={this.toggle.bind(this)}>
                        <span className="icon edit-icon" >
                            <i className="fa fa-pen"></i><span className="edit-label">Edit</span>
                        </span>
                    </button>              
                </div>      

             </div>         
                        
        )
    }
}
export default EmpOkrContent;