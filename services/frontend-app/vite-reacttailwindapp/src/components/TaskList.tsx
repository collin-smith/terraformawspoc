import { Link } from 'react-router-dom';
import * as Module from "../interfaces/Task";


//Props Interface
interface BlogListProps { tasks: Module.Task[]  } 

const BlogList = ({ tasks}:BlogListProps) => {
  return (
    <div className="task-list">
      {tasks.map(task => (
        <div className="task-preview" key={task.id} >
          <Link to={`/updatetask/${task.id}`}>
          <p className="text-left">{task.title} Due: {task.duedate}</p>
          </Link>
          <div className="flex justify-start space-x-2">
          <Link to={`/viewtask/${task.id}`}>
            <button className="btn-primary">View Task</button>
            </Link>
            <Link to={`/edittask/${task.id}`}>
            <button className="btn-primary">Edit Task</button>
            </Link>
            </div>
        </div>
      ))}
    </div>
  );
}
 
export default BlogList;