using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TodoWebForm
{
    public partial class _Default : Page
    {
        public static List<Todo> TodoDb = new List<Todo>();

        static _Default()
        {
            TodoDb.Add(new Todo() 
            {
                TaskId = Guid.NewGuid(),
                TaskName = "Levar cachorro para passear"
            });

            TodoDb.Add(new Todo()
            {
                TaskId = Guid.NewGuid(),
                TaskName = "Tomar Banho"
            });
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat= ResponseFormat.Json)]
        public static List<Todo> GetTodos()
        {
            return TodoDb;
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string AddTodo(string taskName)
        {
            TodoDb.Add(new Todo()
            {
                TaskId = Guid.NewGuid(),
                TaskName = taskName
            });

            return TodoDb.LastOrDefault().TaskId.ToString();
            
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static bool ChangeDone(string taskId, bool done)
        {
            var task = (from x in TodoDb
                        where x.TaskId == new Guid(taskId)
                        select x).FirstOrDefault();

            task.Done = done;

            return true;

        }


        public class Todo
        {
            public Guid TaskId { get; set; }
            public String TaskName { get; set; }
            public bool Done { get; set; }
        }


    }
}