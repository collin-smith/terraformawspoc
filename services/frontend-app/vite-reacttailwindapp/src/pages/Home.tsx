import React from 'react';

import useFetch from "../hooks/useFetch";
import TaskList from "../components/TaskList";
import '../index.css';

export interface IHomePageProps {}

const HomePage: React.FunctionComponent<IHomePageProps> = () => {

    const url = "/prod/tasks"
    const { error, isPending, data: tasks } = useFetch(url)
    return (

    <div>
      <p className="font-bold text-left">Tasks:</p>

        <div>
            <div className="home">
      { error && <div>{ error }</div> }
      { isPending && <div>Loading...</div> }
      { tasks && <TaskList tasks={tasks} /> }
      </div>
        </div>

    </div>
    );
};

export default HomePage;