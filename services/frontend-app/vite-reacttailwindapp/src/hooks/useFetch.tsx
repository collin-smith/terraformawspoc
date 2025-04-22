import { useState, useEffect } from 'react';
import getBaseUrl from "../utils/getBaseUrl"


//const baseUrl = "https://ytbs6t79y4.execute-api.us-east-1.amazonaws.com";
const baseUrl = getBaseUrl();
//const useFetch = <T,>(url: string)=>  {
  const useFetch = (path: string)=>  {
  const [data, setData] = useState(null);
  const [isPending, setIsPending] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const abortCont = new AbortController();

    setTimeout(() => {
      let url = baseUrl + path;

      let headers = new Headers();
      headers.append('Content-Type', 'application/json');

      fetch(url, { signal: abortCont.signal })
      .then(res => {
        if (!res.ok) { // error coming back from server
          throw Error('could not fetch the data for that resource');
        } 
        return res.json();
      })
      .then(data => {
        setIsPending(false);
        setData(data);
        setError(null);
      })
      .catch(err => {
        if (err.name === 'AbortError') {

        } else {
          // auto catches network / connection error
          setIsPending(false);
          setError(err.message);
        }
      })
    }, 1000);

    // abort the fetch
    return () => abortCont.abort();
  }, [path])

  return { data, isPending, error };
}
 
export default useFetch;