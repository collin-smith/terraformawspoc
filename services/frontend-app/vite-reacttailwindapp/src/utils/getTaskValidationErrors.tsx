import * as Module from "../interfaces/Task";

const getTaskValidationErrors = (task: Module.Task) => {
    let errors :string = "";
    if (task.title.toLowerCase().indexOf("elvis") > -1)
    {
      errors += "No Elvis Titles are allowed!"
    }
    return errors;
  }

  export default getTaskValidationErrors;