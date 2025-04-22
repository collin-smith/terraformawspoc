import React, { useEffect, useState } from 'react';
import { useParams } from "react-router-dom";
import useFetch from "../hooks/useFetch";


export interface IDataEntryProps {}

const ViewTask: React.FunctionComponent<IDataEntryProps> = () => {
    const { id } = useParams();

    const { data: taskObj , error, isPending } = useFetch('/prod/tasks/' + id);
    const [taskId, setTaskId] = useState('');
    const [title, setTitle] = useState('');
    const [priority, setPriority] = useState('');
    const [notes, setNotes] = useState('');
    const [duedate, setDuedate] = useState('');
    const [created, setCreated] = useState('');
    const [updated, setUpdated] = useState('');


    useEffect(() => {
        if (taskObj !=null)
          {
            setTaskId(taskObj[0]['id']);
            setTitle(taskObj[0]['title']);
            setPriority(taskObj[0]['priority']);
            setNotes(taskObj[0]['notes']);
            setDuedate(taskObj[0]['duedate']);
            setCreated(taskObj[0]['created']);
            setUpdated(taskObj[0]['updated']);
          }
  
    }, [taskObj])
  

    return (

        <div>
        <p className="font-bold">View Task</p>

        { isPending && <div>Loading...</div> }
{ error && <div>{ error }</div> }
{ taskObj && (
        <form>

<div className="grid sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-4">

  <div  className="border-blue-500"> <label  className="font-bold border-black-500">Id:</label>
<label>{taskId}</label></div>

<div  className="border-blue-500"> <label  className="font-bold border-black-500">Title:</label>
<label>{title}</label></div>

<div  className=""><label  className="font-bold border-black-500">Priority:</label>
  <label>{priority}</label>
 </div>

 <div  className=""><label  className="font-bold border-black-500">Notes:</label>
  <label>{notes}</label>
 </div>

 <div  className=""><label  className="font-bold border-black-500">Due Date:</label>
  <label>{duedate}</label>
 </div>

 <div  className=""><label  className="font-bold border-black-500">Created:</label>
  <label>{created}</label>
 </div>

 <div  className=""><label  className="font-bold border-black-500">Updated:</label>
  <label>{updated}</label>
 </div>











</div>
<div>
 </div>
  </form>


)}

    </div>
);
};

export default ViewTask;