 function add_node(){
    err=false
    hide_all_errors()
    user=$("#inputUser").val();
    ip=$("#inputIP").val();
    password =$("#inputPassword3").val();
    port =$("#inputPort").val();
    if(port.trim() != "")port =":"+port
    cpus=$( "#cpus option:selected" ).text();


    if(!user.trim().length ){show_error("errUser");err=true}
    if(!ip.trim().length ){show_error("errIP");err=true}
    if(!password.trim().length ){show_error("errPassword");err=true}
    if(err)return;
    const op = '{"operation": "share_pub_key", "user": "'+user+'"  , "ip_port": "'+ip+port+'" , "password": "'+password+'", "cpus": "'+cpus+'"}';
    hourglass_show();
    $.ajax({
        type: 'PUT',
        async: true,
        data: op,
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
            if(msg!="0")alert("err 5"+JSON.stringify(msg))
            hourglass_hide();
            refresh_server_list()

        },

        error: function(msg) {
            alert("err2 "+JSON.stringify(msg))
             hourglass_hide();
        }
    });
 }

 function op_all_servers(op){

     $.ajax({
        type: 'PUT',
        async: true,
        data: '{"operation": "'+op+'" }',
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
            fetch_servers(true)

        },

        error: function(msg) {
             hourglass_hide();
        }
    });
}


function fetch_servers(refresh){

    const op = refresh ? "refresh_all_server":"get_all_server";

    $.ajax({
        type: 'PUT',
        async: true,
        data: '{"operation": "'+op+'"}',
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
            hourglass_hide();
            set_servers(msg);

        },

        error: function(msg) {
            hourglass_hide();
        }
    });
}
function stop_start_remove_server(op,id){
    if(!confirm(op.replace("_", " ")+ "  "+id+ " ?")) return
    const op1 = '{"operation": "'+op+'" , "id": "'+id+'"}';
    hourglass_show();
    $.ajax({
        type: 'PUT',
        async: true,
        data: op1,
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
            fetch_servers(true)
            if(op=="remove_server")alert("Manually remove the Crontab item on nodes and ~/.ssh/authorized_keys item.")
        },
        error: function(msg) {
            alert("err3 "+JSON.stringify(msg))
            hourglass_hide();
        }
    });
}
function showDialog(d){
    $("#dialog_box").html(decodeURIComponent(d))
    $( "#dialog" ).dialog();
}
function set_servers(date_and_list){
    res=""

    j=JSON.parse(date_and_list);
    $('#restart_all_server_id').hide();
    $('#stop_all_server_id').hide();
    $('#start_all_server_id').hide();
    //$('#refresh_button').hide();
    $("#time_stamp_server").html(j.timestamp);
    j.list.forEach(function(server, index){
        $('#restart_all_server_id').show();
        $('#stop_all_server_id').show();
        $('#start_all_server_id').show();
        //$('#refresh_button').show();
        test_name = server.test_name.trim()=="" ? "-": server.test_name;
        const st=server.stopped.trim()=="true" ?'style="color: red;"' : '';

        hide_stop=""
        hide_start=""
        server.stopped.trim()=="true"?hide_stop="hidden":hide_start="hidden"

        command=encodeURI(server.command)
        res += ` <tr>\
                        <td class='rank'>${index+1}</td>\
                        <td>${server.id} </td>\
                        <td>${server.ip} </td>\
                        <td class='text-end'>${server.tot_match}</td>\
                        <td class='text-end'>${server.load_avarage}</td>\
                        <td class='text-end'>${test_name}</td>\
                        <td class='text-end'>${server.max_cpu}</td>\
                        <td class="text-end"><a href="#" onclick="javascript:showDialog('${command}');">Command</a></td>\
                        <td ${st} class='text-end'>${server.stopped}</td>\
                        <td ${hide_stop} class="run-view"><button id="id_stop_${server.id}" onclick="stop_start_remove_server('stop_server', '${server.id}')" type="button" class="btn btn-danger">Stop</button></td>\
                        <td ${hide_start} class="run-view"><button id="id_enable_${server.id}" onclick="stop_start_remove_server('start_server', '${server.id}')" type="button" class="btn btn-success">Start</button></td>\
                        <td class="run-view"><button id="id_enable_${server.id}" onclick="stop_start_remove_server('remove_server', '${server.id}')" type="button" class="btn btn-danger">Remove node</button></td>\

                    </tr>`
    })

    $("#server_dynamic_list").html(res);
}
