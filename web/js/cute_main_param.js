
function startup(show_dialog) {
    is_init_flag = is_init()
    if(is_init_flag==2) {
        hourglass_hide()
        show_test_list()
    }
    else if(is_init_flag==1) {
        hourglass_hide()
        $('#id_show_test_list_button').hide()
        $('#id_show_failed_list_button').hide()
        $('#id_show_suspended_list_button').hide()
         $('#id_show_server_list_button').show()
        show_server_list()
    }
    else if(is_init_flag==0) {
        if(show_dialog)showDialog("Set your Github repository and create the branch 'base'. Than create branches with prefix '/_test_' example git checkout -b _test_/foo. Will start a match between 'base' and '_test_/foo'")
        $('#id_show_test_list_button').hide()
        $('#id_show_failed_list_button').hide()
        $('#id_show_suspended_list_button').hide()
        $('#id_show_server_list_button').hide()
        on_loading=false
        show_settings()
    }
}

 function show_param(param){
         $("#repoInput").val(param.repo);
         $("#resignInput").val(param.resign);
         $("#drawInput").val(param.draw);
         $("#tcInput").val(param.tc);
         $("#hashSizeInput").val(param.hash_size);
         $("#concurrencyInput").val(param.concurrency);
         $("#variantInput").val(param.variant);
         $("#totMatchInput").val(param.tot_match);
         $("#makeCommandAarch64Input").val(param.make_command_aarch64);
         $("#makeCommandX86_64Input").val(param.make_command_x86_64);
         $("#pathSrcInput").val(param.path_src);
         $("#pathExeInput").val(param.path_exe);
         $("#firstParamInput").val(param.first_param);
         $("#secondParamInput").val(param.second_param);
         $("#openingInput").val(param.opening_epd);
 }
 function is_init(){
     hourglass_show();
     res=0
     $.ajax({
        type: 'PUT',
        async: false,
        data: '{"operation": "is_init"}',
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
             hourglass_hide();
             if( JSON.stringify(msg).includes("OKK_no_nodes"))res=1;
             else if( JSON.stringify(msg).includes("OKK"))res =2;
             else res= 0;
        },

        error: function(msg) {
             alert("err444 "+JSON.stringify(msg))
             hourglass_hide();
        }
    });
    return res
 }
 function load_cute_main_param(){
     hourglass_show();
     $.ajax({
        type: 'PUT',
        async: true,
        data: '{"operation": "load_cute_main_param"}',
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
             const param=JSON.parse(msg);
             show_param(param);
             hourglass_hide();
        },

        error: function(msg) {
             alert("err44 "+JSON.parse(msg))
             hourglass_hide();
        }
    });
 }

 function hide_all_errors(){
  $("#errRepo").hide();
  $("#errTC").hide();
 $("#errHash").hide();
 $("#errTotGames").hide();
 $("#errAarc").hide();
 $("#errMakeX64").hide();
 $("#errSrc").hide();
 $("#errExe").hide();
 $("#errConcurrency").hide();
$("#errUser").hide();
$("#errIP").hide();
$("#errPassword").hide();
 }
 function show_error(label){
   $("#"+label).show();
 }
function isPositiveInteger(fieldValue) {
  if (isNaN(fieldValue)) return false;
  var intValue = parseInt(fieldValue);
  return intValue > 0;
}
$(document).ready(function() {
  $.ajax({
        type: 'PUT',
        async: true,
        data: '{"operation": "get_opening_epd" }',
        contentType: "application/json",
        dataType: 'json',
        success: function(data) {
            data=JSON.parse(data);
            $.each(data.aaData,function(i,data) {
                var div_data="<option value="+data.value+">"+data.value+"</option>";
                $(div_data).appendTo('#openingInput');
            });
        },

        error: function(data) {
            alert("err6 "+JSON.stringify(data))

        }
    });
 });
 function update_cute_main_param(){

    const repoInput=$("#repoInput").val();
    const resignInput=$("#resignInput").val();
    const drawInput=$("#drawInput").val();
    const tcInput=$("#tcInput").val();
    const hashSizeInput=$("#hashSizeInput").val();
    const concurrencyInput=$("#concurrencyInput").val();
    const variantInput=$("#variantInput").val();
    const totMatchInput=$("#totMatchInput").val();
    const makeCommandAarch64Input=$("#makeCommandAarch64Input").val();
    const makeCommandX86_64Input=$("#makeCommandX86_64Input").val();
    const pathSrcInput=$("#pathSrcInput").val();
    const pathExeInput=$("#pathExeInput").val();
    const firstParamInput=$("#firstParamInput").val();
    const secondParamInput=$("#secondParamInput").val();
    const openingInput=$("#openingInput").val();

    hide_all_errors()
    err=false
    if(!repoInput.trim().length ){show_error("errRepo");err=true}
    if(!tcInput.trim().length ){show_error("errTC");err=true}
    if(!isPositiveInteger(hashSizeInput.trim())){show_error("errHash");err=true}
    if(!isPositiveInteger(totMatchInput.trim())){show_error("errTotGames");err=true}
    if(!isPositiveInteger(concurrencyInput.trim())){show_error("errConcurrency");err=true}

    if(!pathSrcInput.trim().length ){show_error("errSrc");err=true}
    if(!pathExeInput.trim().length ){show_error("errExe");err=true}
    if(!makeCommandAarch64Input.trim().length && !makeCommandX86_64Input.trim().length ){show_error("errAarc");show_error("errMakeX64");err=true}

    if(err)return
    hourglass_show();
    class Cute_main_param_bean {
        constructor(ips, repo,
                 first_param, second_param, first_ponder, second_ponder, opening_epd,
                 resign,draw, tc, hash_size, concurrency, variant,
                 tot_match, make_command_aarch64, make_command_x86_64, path_src, path_exe) {

        this.ips = ips ;

        this.repo = repo.trim();
        this.first_param = first_param.trim();
        this.second_param = second_param.trim();
        this.first_ponder = first_ponder.trim();
        this.second_ponder = second_ponder.trim();
        this.opening_epd = opening_epd.trim();
        this.resign = resign.trim();
        this.draw = draw.trim();
        this.tc = tc.trim();
        this.hash_size = hash_size.trim();
        this.concurrency = concurrency.trim();
        this.variant = variant.trim();
        this.tot_match = tot_match.trim();
        this.make_command_aarch64 = make_command_aarch64.trim();
        this.make_command_x86_64 = make_command_x86_64.trim();
        this.path_src = path_src.trim();
        this.path_exe = path_exe.trim();
        }

    }
    const param = new Cute_main_param_bean("dummy",repoInput,firstParamInput,secondParamInput,"","",openingInput,resignInput,drawInput,tcInput,hashSizeInput,
    concurrencyInput,variantInput,totMatchInput,makeCommandAarch64Input,makeCommandX86_64Input,pathSrcInput,pathExeInput);
    const jsonString = JSON.stringify(param);

    const op = '{"operation": "update_cute_main_param", "params": '+jsonString+' }';


    $.ajax({
        type: 'PUT',
        async: true,
        data: op,
        contentType: "application/json",
        dataType: 'json',
        success: function(msg) {
            hourglass_hide();
            if(msg!="OKK")alert(JSON.stringify(msg).replace("\"",""))
            else startup(false)
        },

        error: function(msg) {
            alert(JSON.stringify(msg))
            hourglass_hide();
        }
    });
 }
