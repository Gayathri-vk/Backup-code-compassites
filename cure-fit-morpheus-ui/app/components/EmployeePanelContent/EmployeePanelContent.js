import React, { Component } from 'react';
import './style.scss';
import EmpOkrContent from '../EmpOkrContent/EmpOkrContent';

class EmployeePanelContent extends Component {
    constructor(props) {
        super(props);
        this.state = {
            current: 0
        };
    }

    toggle(index) {
        this.setState({
            current: index
        })
    }
    render() {
        return (
            <div className="empOkrContent">
                <div className="box" onClick={this.toggle.bind(this, 1)}>
                    <div className="is-flex">
                        <span className="has-addson">OKR2</span>
                        <div className="column has-text-right is-marginless is-paddingless"><span className="downarrow "><button><i className="fas fa-angle-down"></i></button></span></div>
                    </div>
                    <div className={`collapsible ${this.state.current === 1 ? 'open ' : ''}`}>
                        <EmpOkrContent />

                    </div>
                </div>
                <div className="box" onClick={this.toggle.bind(this, 2)}>
                    <div className="is-flex">
                        <span className="has-addson">OKR2</span>
                        <div className="column has-text-right is-marginless is-paddingless"><span className="downarrow "><button><i className="fas fa-angle-down"></i></button></span></div>
                    </div>
                    <div className={`collapsible ${this.state.current === 2 ? 'open ' : ''}`}>
                        <EmpOkrContent />
                    </div>
                </div>
                <div className="box" onClick={this.toggle.bind(this, 3)}>
                    <div className="is-flex">
                        <span className="has-addson">OKR2</span>
                        <div className="column has-text-right is-marginless is-paddingless"><span className="downarrow "><button><i className="fas fa-angle-down"></i></button></span></div>
                    </div>
                    <div className={`collapsible ${this.state.current === 3 ? 'open ' : ''}`}>
                        <EmpOkrContent />
                    </div>
                </div>
            </div>

        );

    }
}

export default EmployeePanelContent;