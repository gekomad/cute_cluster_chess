function fetch(d){
    $.ajax({
        async: true,
        type: 'PUT',
        data: d,
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
            hourglass_hide()

            if(tab_active=="tests" && msg && !msg.includes("Rank Name"))  alert("Waiting for a branch with prefix '_test_/'...")
            set_tests(msg);
        },

        error: function(msg) {
            hourglass_hide()
            $("#test_dynamic_list").html("");
            alert("err1 data: "+d+ " err: " +JSON.stringify(msg))
        }
    });
}

function fetch_suspended(refresh){
    $("#test_dynamic_list").html("");
    const op = refresh ? '{"operation": "refresh_all_suspended"}':'{"operation": "get_all_suspended"}';
    fetch(op)
}
function fetch_failed(refresh){
    $("#test_dynamic_list").html("");
    const op = refresh ? '{"operation": "refresh_all_failed"}':'{"operation": "get_all_failed"}';
    fetch(op)
}
function fetch_tests(refresh){
    $("#test_dynamic_list").html("");
    const op = refresh ? '{"operation": "refresh_all_tests"}':'{"operation": "get_all_tests"}';
    fetch(op)
}
function activate_branch(branch){
    const op = '{"operation": "activate_branch", "branch": "'+branch+'" }';
    fetch(op)
}
function failed_test(branch){
    $("#row_"+branch).hide();
    const op = '{"operation": "failed_branch", "branch": "'+branch+'" }';
    fetch(op)
}
function suspend_branch(branch){
    $("#row_"+branch).hide();
    const op = '{"operation": "suspend_branch", "branch": "'+branch+'" }';
    fetch(op)
}
function set_tests(date_and_list){
    res=""
    $("#test_dynamic_list").html(res);
    if(date_and_list==null){return}

    const j=JSON.parse(date_and_list);

    $("#time_stamp_test").html(j.timestamp);

    suspend_list = j.suspend_list
    j.list.forEach(function(the_test, index){
        rating=the_test.res.replace(/\n/g, "<br />").replace("<br /><br />","");
        color=the_test.color;
        has_error=the_test.has_error;
        name=the_test.name;
        test_date=the_test.test_date;
        git_comment=the_test.git_comment;
        git_commit=the_test.git_commit;
        git_url=the_test.git_url.replace(".git", '');
        git_base=the_test.git_base;
        hide_suspend="hidden"
        hide_activate="hidden"
        force_hidden=""
        hide_failed=""
        if(tab_active != "suspended")hide_failed="hidden"
        if(tab_active == "failed")force_hidden="hidden"
        if(has_error=="true"){text="cute.err" ;errors="color: red;"} else {text="no error" ;errors="color: green;"}

        if(suspend_list.includes(name)) {hide_activate="";} else hide_suspend="";
        res += ` <tr id="row_${name}">

                                    <td style="width: 1%;" class="run-elo">
                                        <pre style="background-color: ${color};" class="rounded elo-results  ">
                                         ${rating}
                                        </pre>
                                    </td>

                                    <td style="width: 16%;font-weight: bold;" class="run-view">${name}</td>
                                    <td style="width: 16%;" class="run-view">${git_comment}</td>
                                    <td style="width: 16%;${errors}" class="run-view">${text}</td>
                                    <td style="width: 16%;" class="run-view">${test_date}</td>

                                    <td style="width: 16%;" class="run-view"><a target="_blank" href="download_pgn/${name}">PGN</a></td>

                                    <td ${force_hidden} ${hide_suspend} class="run-view"><button onclick="suspend_branch1('${name}')" type="button" class="btn btn-success">Suspend</button></td>
                                    <td ${force_hidden} ${hide_activate} class="run-view"><button onclick="activate_branch1('${name}')" type="button" class="btn btn-warning">Activate</button></td>
                                    <td ${hide_failed} class="run-view"><button onclick="failed_test1('${name}')" type="button" class="btn btn-danger">Failed</button></td>

                                    <td  >
                                        <a target="_blank" href="${git_url}/compare/${git_commit}...${git_base}?w=1" class="btn btn-info" role="button">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-github" viewBox="0 0 16 16">
                                            <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8"></path>
                                        </svg>
                                        Diff</a>
                                    </td>

                               </tr>`
    })

    $("#test_dynamic_list").html(res);
}


