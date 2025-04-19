import React from "react";
import { BrowserRouter as Router, Routes, Route, Link, Switch } from 'react-router-dom';
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";
import logo from "./assets/img/logo.svg";
import AddStudent from "./components/AddStudent";
import Students from "./components/Students";
import StudentList from "./components/StudentList";

function App() {
  return (
    <Router>
      <div>
        <nav className="navbar navbar-expand navbar-dark bg-dark">
            <Link to="/students" className="navbar-brand d-flex align-items-center">
              <img src={logo} alt="Logo" style={{ height: "30px", marginRight: "10px" }} />
              Application Demo
            </Link>
            <div className="navbar-nav mr-auto">
              <li className="nav-item">
                <Link to={"/students"} className="nav-link">
                  Students
                </Link>
              </li>
              <li className="nav-item">
                <Link to={"/add"} className="nav-link">
                  Add
                </Link>
              </li>
            </div>
          </nav>

        <div className="container mt-3">
          <Switch>
            <Route exact path={["/", "/students"]} component={StudentList} />
            <Route exact path="/add" component={AddStudent} />
            <Route path="/students/:id" component={Students} />
          </Switch>
        </div>
      </div>
    </Router>
  );
}

export default App;
