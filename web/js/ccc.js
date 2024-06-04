        on_loading = false;
        tab_active = "tests";
        is_init_flag = 0;
        function active_nav_tab(tab) {
            tab_active = tab;
            $('#id_show_test_list_button').removeClass('btn-success').addClass('btn-light');
            $('#id_show_failed_list_button').removeClass('btn-success').addClass('btn-light');
            $('#id_show_suspended_list_button').removeClass('btn-success').addClass('btn-light');
            $('#id_show_server_list_button').removeClass('btn-success').addClass('btn-light');
            $('#id_show_settings_button').removeClass('btn-success').addClass('btn-light');
            switch (tab) {
                case 'servers':
                    $('#id_show_server_list_button').removeClass('btn-light').addClass('btn-success');
                    break;
                case 'tests':
                    $("#id_test_failed").html("Tests");
                    $('#id_show_test_list_button').removeClass('btn-light').addClass('btn-success');
                    break;
                case 'failed':
                    $("#id_test_failed").html("Failed");
                    $('#id_show_failed_list_button').removeClass('btn-light').addClass('btn-success');
                    break;
                case 'suspended':
                    $("#id_test_failed").html("Suspended");
                    $('#id_show_suspended_list_button').removeClass('btn-light').addClass('btn-success');
                    break;
                case 'settings':
                    $("#id_test_failed").html("Settings");
                    $('#id_show_settings_button').removeClass('btn-light').addClass('btn-success');
                    break;
            }
        }
        function refresh() {
         switch (tab_active) {
                case 'servers':
                    refresh_server_list()
                    break;
                case 'tests':
                    refresh_test_list()
                    break;
                case 'failed':
                    refresh_failed_list()
                    break;
                case 'suspended':
                    refresh_suspended_list()
                    break;
                case 'settings':

                    save_settings()
                    break;
            }
        }
        function hourglass_show() {
            document.getElementById('overlay').classList.remove('d-none');
            on_loading = true;
        }
        function hourglass_hide() {
            document.getElementById('overlay').classList.add('d-none');
            on_loading = false;
        }
 <!--        settings -->
         function save_settings() {
            if(on_loading)return;
            update_cute_main_param();
        }
        function show_settings() {
            if(on_loading)return;
            hide_all_errors()
            active_nav_tab("settings")
            $('#server_list').hide();
            $('#settings_id').show();
            $('#test_list').hide();
            load_cute_main_param();
        }
<!--        failed -->
        function show_failed_list() {
            if(on_loading)return;
            hourglass_show();
            active_nav_tab("failed")
            fetch_failed(false);
            $('#server_list').hide();
            $('#settings_id').hide();
            $('#test_list').show();
        }
        function refresh_failed_list() {
            if(on_loading)return;
            hourglass_show();
            fetch_failed(true);
        }
<!--        suspended -->
        function show_suspended_list() {
            if(on_loading)return;
            hourglass_show();
            active_nav_tab("suspended")
            fetch_suspended(false);
            $('#server_list').hide();
            $('#settings_id').hide();
            $('#test_list').show();
        }
        function refresh_suspended_list() {
            if(on_loading)return;
            hourglass_show();
            fetch_suspended(true);
        }
<!-- servers -->
        function show_server_list() {
            if(on_loading)return;
            hourglass_show();
            active_nav_tab("servers")
            fetch_servers(false);
            $('#server_list').show();
            $('#settings_id').show();
            $('#test_list').hide();
            $('#settings_id').hide();
        }

        function stop_all_server_list() {
            if(on_loading)return;

            if(confirm("Stop all nodes?")) {
                hourglass_show();
                op_all_servers("stop_all_servers");
            }
        }

        function start_all_server_list() {
            if(on_loading)return;

            if(confirm("Start all nodes?")) {
                hourglass_show();
                op_all_servers("start_all_servers");
            }
        }

        function restart_all_server_list() {
            if(on_loading)return;

            if(confirm("Restart all nodes?")) {
                hourglass_show();
                op_all_servers("restart_all_servers");
            }
        }

        function refresh_server_list() {
            if(on_loading)return;
            hourglass_show();
            fetch_servers(true);
        }

<!--        tests -->
        function suspend_branch1(branch) {
            if(on_loading)return;
            hourglass_show();
            suspend_branch(branch);
        }

        function activate_branch1(branch) {
            if(on_loading)return;
            hourglass_show();
            activate_branch(branch);
        }

        function failed_test1(branch) {
            if(on_loading)return;
            hourglass_show();
            failed_test(branch);
        }


        function show_test_list() {
            hide_all_errors()
            if(on_loading)return;
            hourglass_show();
            active_nav_tab("tests")
            fetch_tests(false);
            $('#server_list').hide();
            $('#settings_id').hide();
            $('#test_list').show();
        }
        function refresh_test_list() {
            if(on_loading)return;
            hourglass_show();
            fetch_tests(true);
        }