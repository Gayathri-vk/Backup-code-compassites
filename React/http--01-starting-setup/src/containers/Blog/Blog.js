import React, { Component } from 'react';
import axios from 'axios';
import Post from '../../components/Post/Post';
import FullPost from '../../components/FullPost/FullPost';
import NewPost from '../../components/NewPost/NewPost';
import './Blog.css';

class Blog extends Component {
    state = {
       posts: [],
       selectedPost: null,
       error: false
    }
    componentDidMount() {
        axios.get('https://jsonplaceholder.typicode.com/posts')
            .then(response => {
                const posts = response.data.slice(0,4);
                const updatedPost = posts.map(post =>{
                    return{
                        ...post,
                        author: 'gayathri'
                    }
                })
                this.setState({ posts: updatedPost });
            })
            .catch(error =>{
                this.setState({error:true});
            })
    }
    postSelectHandler = (id) =>{
       this.setState({selectedPost : id});
    }
   
    render() {
          let Posts = <p style ={{textAlign: 'center'}}>Something Went Wrong !</p>
          if(!this.state.error){
            Posts = this.state.posts.map(post =>{
                return <Post 
                        key = {post.id} 
                        title ={post.title} 
                        author = {post.author}
                        clicked = {() => this.postSelectHandler(post.id)} />
            })
          }
        

        return (
            <div>
                <section className="Posts">
                   {Posts} 
                </section>
                <section>
                    <FullPost id ={this.state.selectedPost} />
                </section>
                <section>
                    <NewPost />
                </section>
            </div>
        );
    }
}

export default Blog;