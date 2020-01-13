/**
 *
 * App
 *
 * This component is the skeleton around the actual pages, and should only
 * contain code that should be seen on all pages. (e.g. navigation bar)
 */

import React from 'react';
import { Helmet } from 'react-helmet';
import { Switch, Route } from 'react-router-dom';

import HomePage from 'containers/HomePage/Loadable';
import NotFoundPage from 'containers/NotFoundPage/Loadable';
import Header from 'components/Header';
import Footer from 'components/Footer';
import Project from 'containers/Project/Project'
import './style.scss';

const App = () => (
  <div className="app-wrapper">
    <Helmet
      titleTemplate="%s - Curefit Morpheus"
      defaultTitle="Curefit Morpheus"
    >
      <meta name="description" content="Curefit Morpheus application" />
    </Helmet>
    <Header />

    <Switch>
      <Route exact path="/" component={HomePage} />
       <Route exact path="/project" component={Project} />
      <Route path="" component={NotFoundPage} />
    </Switch>
    <Footer />
  </div>
);

export default App;
