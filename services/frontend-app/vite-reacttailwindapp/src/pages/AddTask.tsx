import React, { useState } from 'react';
import { useNavigate } from "react-router-dom";
import getBaseUrl from "../utils/getBaseUrl";
import getFormattedDate from "../utils/getFormattedDate";
import getTaskValidationErrors from "../utils/getTaskValidationErrors";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

export interface IDataEntryProps {}

const DataCreate: React.FunctionComponent<IDataEntryProps> = () => {
    const baseUrl = getBaseUrl();
    const [title, setTitle] = useState('');
    const [priority, setPriority] = useState('1');
    const [notes, setNotes] = useState('');
   const [dueDate, setDueDate] = useState(new Date());
   const [errors, setErrors] = useState('');
     const navigate = useNavigate();

    const handleSubmit = (event: React.SyntheticEvent<HTMLFormElement>) => {
        event.preventDefault();
        const duedate = getFormattedDate(dueDate);
        
        //Sending in a sample Task interface for a new Task
        const task = { id: -1 , title, priority: Number(priority), notes, duedate, created: "", updated: "" };
        let validationErrors = getTaskValidationErrors(task);
        setErrors(validationErrors);

        if (validationErrors.length==0)
        {
          let headers = new Headers();
          headers.append('Content-Type', 'application/json');
    
              fetch(baseUrl+'/prod/tasks', {
                method: 'POST',
                headers: headers,
                body: JSON.stringify(task)
            }).then(() => {
              navigate('/');        
            })
    
        }

      }

    return (
        <div>
        <form onSubmit={handleSubmit}>
        <h2 className="font-bold">Add a New Task</h2>
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
        <button className="btn-primary">Add Task</button>
          </div>

          <label className="font-bold text-red-500">{errors}</label>

          </form>
      </div>
        );
}
export default DataCreate;