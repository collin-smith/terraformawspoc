import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from "react-router-dom";
import useFetch from "../hooks/useFetch"
import getBaseUrl from "../utils/getBaseUrl";
import DatePicker from "react-datepicker";
import getFormattedDate from "../utils/getFormattedDate";
import getTaskValidationErrors from "../utils/getTaskValidationErrors";


export interface IDataEntryProps {}


const DataCreate: React.FunctionComponent<IDataEntryProps> = () => {
    const { id } = useParams();

    const { data: taskObj , error, isPending } = useFetch('/prod/tasks/' + id);
    console.log("error="+error);
    console.log("isPending="+isPending);

    const [taskId, setTaskId] = useState('');
    const [title, setTitle] = useState('');
    const [priority, setPriority] = useState('');
    const [notes, setNotes] = useState('');
    const [dueDate, setDueDate] = useState(new Date());
    const [created, setCreated] = useState('');
    const [updated, setUpdated] = useState('');
    console.log("created="+created);
    console.log("updated="+updated);
    const navigate = useNavigate();

    const [errors, setErrors] = useState('');


   const baseUrl = getBaseUrl();

    useEffect(() => {

        if (taskObj !=null)
          {
            setTaskId(taskObj[0]['id']);
            setTitle(taskObj[0]['title']);
            setPriority(taskObj[0]['priority']);
            setNotes(taskObj[0]['notes']);


            //The Date Picker needs an actual Date Object
            //backend Date string
            //let backendDateString = taskObj[0]['duedate'];
            //2026-06-24 13:23:30
            const backendDateString = ""+taskObj[0]['duedate'];
            let year = backendDateString.substring(0,4);
            let month = backendDateString.substring(5,7);
            let monthIndex = Number(month) - 1;
            let dayOfMonth = backendDateString.substring(8,10);
            let hours = backendDateString.substring(11,13);
            let minutes = backendDateString.substring(14,16);
            let seconds = backendDateString.substring(17,20);

            let frontEndDate = new Date(Number(year), monthIndex, Number(dayOfMonth), Number(hours), Number(minutes), Number(seconds));

            setDueDate(frontEndDate);
            setCreated(taskObj[0]['created']);
            setUpdated(taskObj[0]['updated']);

          }
  
    }, [taskObj])

    const handleSubmit = (event: React.SyntheticEvent<HTMLFormElement>) => {
      event.preventDefault();

      const duedate = getFormattedDate(dueDate);
      const idNumber = Number(taskId);
      //Sending in a sample Task interface for a new Task
      const task = { id: idNumber , title, priority: Number(priority), notes, duedate, created: "", updated: "" };

      let validationErrors = getTaskValidationErrors(task);
      setErrors(validationErrors);

      if (validationErrors.length==0)
        {

          let headers = new Headers();
          headers.append('Content-Type', 'application/json');
    
              fetch(baseUrl+'/prod/tasks', {
                method: "PUT",
                headers: headers,
                body: JSON.stringify(task)
            }).then(() => {

              navigate('/');        
            })
    
        }

    }


      const handleDelete = () => {

        const idNumber = Number(taskId);

        const json = { id: idNumber };
        let headers = new Headers();
        headers.append('Content-Type', 'application/json');
  
            fetch(baseUrl+'/prod/tasks', {
              method: "DELETE",
              headers: headers,
              body: JSON.stringify(json)
          }).then(() => {
            navigate('/');        
          })
      }

    return (

        <div>
        <form onSubmit={handleSubmit}>
        <h2 className="font-bold">Edit Task</h2>
        <div className="grid sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-4">

          <div className=""><label className="font-bold text-black">Title:</label><input className="input box-content border-1 p-1 min-w-80"
              type="text" 
              required 
              value={title}
              onChange={(e) => setTitle(e.target.value)}
            /></div>

<div  className="border-blue-500"> <label  className="font-bold border-black-500">Priority:</label>
            <select className="input box-content border-1 p-1 min-w-10"
              value={priority}
              onChange={(e) => setPriority(e.target.value)}
            >
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
            </select></div>


          <div  className=""><label  className="font-bold border-black-500">Notes:</label>
            <textarea className="input input box-content border-1 p-1 min-w-80"
              required
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              rows={5} cols={20}
                  ></textarea></div>


<div className=""><label className="font-bold text-black">Due Date:</label>

<DatePicker
      selected={dueDate}
      onChange={date => date && setDueDate(date)}
      timeInputLabel="Time:"
      dateFormat="MM/dd/yyyy h:mm aa"
      showTimeInput
      className="box-content border-1 p-1"
    />
            
            </div>


        </div>
        <div className="flex justify-start space-x-2">
        <button className="btn-primary">Save</button>
        <button className="btn-secondary" onClick={handleDelete}>Delete</button>
          </div>
          <label className="font-bold text-red-500">{errors}</label>
          </form>
      </div>


        );
}
export default DataCreate;