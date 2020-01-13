import React, { Component } from 'react';
import './style.scss';

class AccordianContent extends Component{
    render(){
        return(
            <div className="block whole_card_block">
                <h4 className="is-4 cardlabel">Objective</h4>
                <p className="objcontent mar_top">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi vel dapibus mi, dictum consectetur orci. Mauris semper, augue id auctor consequat, risus arcu lobortis justo, nec aliquet turpis dolor eu nibh. Aenean vitae tortor iaculis, hendrerit nisl vel, semper magna. Quisque luctus leo non dolor venenatis, maximus dapibus augue venenatis. Etiam in eros sed nisl ullamcorper sollicitudin. Proin sit amet eleifend massa.</p>

                <div className="block">
                <div className="columns mar_top">
                    <div className="column is-4">
                        <h4 className="is-4 cardlabel">Key Results</h4>
                    </div>
                    <div className="column is-4">
                        <h4 className="is-4 cardlabel">Mid Review</h4>
                    </div>
                    <div className="column is-4">
                        <h4 className="is-4 cardlabel">End Review</h4>
                    </div>
                </div>
                    <div className="columns cardsdetails">
                      <div className="column is-4 cardcol">
                        <p className="reviewcontent">Fusce gravida scelerisque ligula, a rhoncus eros accumsan quis. Vivamus mollis risus et urna consectetur efficitur. Aenean vestibulum in dolor ut pellentesque.</p>
                      </div>
                      <div className="column is-4 cardcol">
                         <p className="reviewcontent">Nullam ut nulla aliquet, blandit mi eget, viverra odio. Phasellus posuere ac eros et mattis. Aliquam vitae eros quis felis cursus sodales et non purus.</p>
                      </div>
                      <div className="column is-4 cardcol">

                          <p className="reviewcontent">Vestibulum interdum hendrerit purus, vel semper nisl dignissim at. Vivamus sagittis porttitor turpis, eget mollis nisi suscipit fermentum. Sed maximus nec sem in egestas. </p>
                      </div>
                    </div>
                    <div className="columns cardsdetails">
                      <div className="column is-4 cardcol">
                          <p className="reviewcontent">Vestibulum interdum hendrerit purus, vel semper nisl dignissim at. Vivamus sagittis porttitor turpis, eget mollis nisi suscipit fermentum. Sed maximus nec sem in egestas. </p>
                      </div>
                      <div className="column is-4 cardcol">
                      <p className="reviewcontent">Nullam ut nulla aliquet, blandit mi eget, viverra odio. Phasellus posuere ac eros et mattis. Aliquam vitae eros quis felis cursus sodales et non purus.</p>
                      </div>
                      <div className="column is-4 cardcol">
                      <p className="reviewcontent">Vestibulum interdum hendrerit purus, vel semper nisl dignissim at. Vivamus sagittis porttitor turpis, eget mollis nisi suscipit fermentum. Sed maximus nec sem in egestas. </p>
                      </div>
                    </div>
                    <div className="block cardcol">
                        <p className="addproject"><i className="fas fa-user-plus"></i>Add yourself to Project</p>
                    </div>
                </div>

            </div>
        )
    }
}
export default AccordianContent;
