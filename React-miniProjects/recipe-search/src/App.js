import React, {Component} from 'react';
import './App.css';
import {recipes} from "./tempList";
import RecipeList from "./components/recipeList";
import RecipeDetails from "./components/recipeDetails";

class App extends Component {
  constructor(props){
    super(props);

  }
  state = {
    recipes: recipes,
    url: "https://www.food2fork.com/api/search?key=83cdb1de68921618bff03b7937c74426",
    base_url: "https://www.food2fork.com/api/search?key=83cdb1de68921618bff03b7937c74426",
    details_id: 35389,
    pageIndex: 1,
    search: "",
    query: "&q=",
    error: ""
  }

  async getRecipes() {
    try {
      const data = await fetch(this.state.url);
      const jsonData = await data.json();
      if(jsonData.recipes.length === 0) {
        this.setState(() => {
          return {error: "sorry, but your search did not return any results"}
        })
      }
      else {
        this.setState(() => {
          return {recipes: jsonData.recipes}
        })
      }
    }
    catch(error) {
      console.log(error);
    }
  }
  componentDidMount() {
    this.getRecipes()
  }

  displayPage = (pageIndex) => {
    switch(pageIndex) {
      case 0: return (
        <RecipeDetails id={this.state.details_id} handleIndex={this.handleIndex} />
      )
      case 1: return (
        <RecipeList
          recipes={this.state.recipes}
          handleDetails={this.handleDetails}
          value={this.state.search}
          handleChange={this.handleChange}
          handleSubmit={this.handleSubmit}
          error={this.state.error}
        />
      )
      default: return (
        <div>No data</div>
      )
    }
  }

  handleIndex = (index) => {
    this.setState({
      pageIndex: index
    });
  }

  handleDetails = (index, id) => {
    this.setState({
      pageIndex: index,
      details_id: id
    });
  }

  handleChange = (e) => {
    this.setState({
      search: e.target.value
    })
  }

  handleSubmit = (e) => {
    e.preventDefault();
    const {base_url, query, search} = this.state;
    this.setState(() => {
      return {
        url: `${base_url}${query}${search}`, search: ""
      }
    }, () => {
      this.getRecipes();
    }
    )
  }
  
  render() {
    return (
      <React.Fragment>
        {this.displayPage(this.state.pageIndex)}
        
      </React.Fragment>
    );
  }
  
}

export default App;
