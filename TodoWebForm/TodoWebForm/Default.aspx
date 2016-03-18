<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TodoWebForm._Default" %>

<asp:Content runat="server" ContentPlaceHolderID="HeadContent" ID="Head">
    <script type="text/javascript">

        $(document).ready(function () {

            var container = $("#container");

            var check_change = function (ev) {
                var done = false;
                var taskId = $(this).attr("data-id");

                if ($(this).attr("checked")) {
                    $(this).closest("li").css("text-decoration", "line-through");
                    done = true;
                }
                else {
                    $(this).closest("li").css("text-decoration", "none");
                }

                var data = {
                    taskId: taskId,
                    done: done
                };

                $.ajax({
                    contentType: "application/json",
                    type: "POST",
                    url: "/Default.aspx/ChangeDone",
                    data: JSON.stringify(data),
                    dataType: "json",
                });

            };

            $.ajax({
                contentType: "application/json",
                type: "POST",
                url: "/Default.aspx/GetTodos",
                dataType: "json",
                success: function (response) {
                    $.each(response.d, function (i, e) {
                        var listItem = $("<li></li>");
                        var checkbox = $("<input data-id='" + e.TaskId + "' type='checkbox'></input><span>" + e.TaskName + "</span>");
                        listItem.append(checkbox);
                        container.append(listItem);
                        checkbox.change(check_change);

                        if (e.Done) {
                            $(listItem).css("text-decoration", "line-through");
                            $(checkbox).attr("checked", "checked");
                        }


                    });
                }
            });

            $("button").click(function (ev) {
                ev.preventDefault();

                if ($("#txtTask").val() === "") {
                    alert("Voce deve digitar uma nova tarefa");
                    return;
                }

                $.ajax({
                    contentType: "application/json",
                    type: "POST",
                    url: "/Default.aspx/AddTodo",
                    data: JSON.stringify({ taskName: $("#txtTask").val() }),
                    dataType: "json",
                    success: function (response) {
                        var listItem = $("<li></li>");
                        var checkbox = $("<input data-id='" + response.d + "' type='checkbox'></input><span>" + $("#txtTask").val() + "</span>");
                        listItem.append(checkbox);
                        container.append(listItem);
                        $("#txtTask").val("");
                        checkbox.change(check_change);
                    }
                });


            });

        });

    </script>
</asp:Content>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <ul id="container">
    </ul>
    <input type="text" placeholder="Crie nova tarefa" id="txtTask" />
    <button>OK</button>


</asp:Content>
